#!/bin/bash

# Command "Move to Trash".

# Import file manager variables (scroll down for info).
$fm_import

# Localization, requirements, variables, files and functions.
. "$fm_cmd_dir/init.inc.sh"

########################################################################
##
## Functions specific to this script.
##
########################################################################

# Example: the path "/home/user/Système d'exploitation.txt" becomes 
# "/home/user/Syst%C3%A8me%20d%27exploitation.txt".
encodePath()
{
	length=${#1}
	
	for ((i = 0; i < length; ++i)); do
		char=${1:$i:1}
		
		if [[ $char == [/A-Za-z0-9._~-] ]]; then
			printf "$char"
		else
			printf "%%%02X" "'$char"
		fi
	done
}

moveToTrash()
{
	testFileExists
	
	# See the README file about files not located on the same device than the home trash.
	if [[ (-f $file || -L $file) && $trashDevice != $currentDirectoryDevice ]] \
	   || [[ -d $file && ! -L $file && $trashDevice != $(stat -c %D "$file") ]]; then
		printf "${msg[ERR_DEVICE]}\n\n" "$file" >&2
		continue
	fi
	
	# Assertion: the file to remove and the home trash directory are both on the same device.
	
	# Ensure that the parent permissions allow to move the file.
	
	parent=${file%/*}
	
	if ! [[ -w $parent && -x $parent ]]; then
		printf "${msg[ERR_PERM_PARENT]}\n\n" "$file" >&2
		continue
	fi
	
	# Ensure that the file itself can be deleted.
	
	testIsNotFileDot
	
	if [[ $file == $trash || $file == $trash/files?(/*) || $file == $trash/info?(/*) ]]; then
		printf "${msg[ERR_TRASHING_TRASH]}\n\n" "$file" >&2
		continue
	fi
	
	# A directory that doesn't have "rwx" permissions must be empty in order to
	# be deleted. Example: "mkdir -m 000 directory && rmdir directory". However,
	# a directory must have read permissions to be able to test if it's empty.
	# Read permissions are therefore a requirement. Also, when the directory is
	# moved to the trash, we first create a directory with "mkdir" since this
	# command is atomic and will return an error if a file with the same name
	# already exists. Then, the directory is moved with the command "mv",
	# requiring write permissions. We get another requirement.
	if [[ -d $file && ! -L $file ]]; then
		if ! [[ -r $file && -w $file ]] || { [[ ! -x $file ]] && isNotEmpty "$file"; }; then
			printf "${msg[ERR_PERM_DIR]}\n\n" "$file" >&2
			continue
		fi
	fi
	
	filename=${file##*/}
	getTrashinfoFilePath
	trashinfoContent="[Trash Info]\n"
	
	# Only unreserved characters and the slash ("/") are directly used for the path.
	# Other characters are encoded. See [RFC 3986](http://www.rfc-editor.org/rfc/rfc3986.txt).
	
	LC_CTYPE_TMP=$LC_CTYPE
	LC_CTYPE=C
	
	if [[ $file == +([/A-Za-z0-9._~-]) ]]; then
		encodedPath=$file
	else
		encodedPath=$(encodePath "$file")
	fi
	
	LC_CTYPE=$LC_CTYPE_TMP
	
	trashinfoContent+="Path=$encodedPath\n"
	trashinfoContent+="DeletionDate=$now"
	
	# With "set -o noclobber", the redirection will fail if the file already exists,
	# so the creation of the trashinfo file is an atomic operation. More information:
	#
	# * Extract from "man 2 open": "O_EXCL Ensure that this call creates the file:
	#   if this flag is specified in conjunction with O_CREAT, and  pathname already
	#   exists, then open() will fail."
	#
	# * We can test the effects of "set -o noclobber" with the following command:
	#
	#   "strace -e open bash -c 'set -o noclobber; > test-file' 2>&1 | grep O_EXCL"
	#
	#   Example of output: "open("test-file", O_WRONLY|O_CREAT|O_EXCL, 0666) = 3".
	set -o noclobber
	i=1
	
	until { echo -en "$trashinfoContent" > "$trashinfoFilePath"; } 2>&-; do
		# Avoid an infinite loop in case the directory isn't writable.
		
		trashinfoParent=${trashinfoFilePath%/*}
		
		if ! [[ -w $trashinfoParent && -x $trashinfoParent ]]; then
			printf "${msg[ERR_CREATE_TRASHINFO]}\n\n" "$trashinfoFilePath" >&2
			set +o noclobber
			continue 2
		fi
		
		((++i))
		
		# Example: if "file.sh.trashinfo" already exists, "file-2.sh.trashinfo"
		# is tried, and so on.
		if [[ $filename == +([^.]).* ]]; then
			# Filename before => Filename after
			# file.sh         => file-2.sh.trashinfo
			# file.inc.sh     => file-2.inc.sh.trashinfo
			trashinfoFilePath=${trashinfoFilePath%/*}/${filename%%.*}-$i.${filename#*.}.trashinfo
		elif [[ $filename =~ ^(\.[^.]*)\.(.*)$ ]]; then
			# .file.sh        => .file-2.sh.trashinfo
			# .file.inc.sh    => .file-2.inc.sh.trashinfo
			trashinfoFilePath=${trashinfoFilePath%/*}/${BASH_REMATCH[1]}-$i.${BASH_REMATCH[2]}.trashinfo
		else
			# file            => file-2
			# .file           => .file-2
			trashinfoFilePath=${trashinfoFilePath%/*}/$filename-$i.trashinfo
		fi
	done
	
	# Example: if the trash info file is "~/.local/share/Trash/info/file.txt.trashinfo",
	# the trashed file will be "~/.local/share/Trash/files/file.txt".
	trashedFile=$trash/files/${trashinfoFilePath##*/}
	trashedFile=${trashedFile%.*}
	
	if [[ -d $file && ! -L $file ]]; then
		# We first create the directory with "mkdir" since this command is atomic
		# and will return an error if the directory already exists.
		{ mkdir "$trashedFile" && mv -T "$file" "$trashedFile"; } 2>&-
	else
		# The creation of the file is atomic because of "set -o noclobber".
		{ > "$trashedFile" && mv "$file" "$trashedFile"; } 2>&-
	fi
	
	exitStatus=$?
	set +o noclobber
	
	if [[ $exitStatus != 0 ]]; then
		printf "${msg[ERR_TRASHING]}\n\n" "$file" >&2
		
		if ! rm -rf "$trashinfoFilePath" 2>&-; then
			printf "${msg[ERR_RM_TRASHINFO]}\n\n" "$trashinfoFilePath" >&2
		fi
		
		continue
	fi
}

########################################################################
##
## Main script code.
##
########################################################################

testFmFilenameIsNotEmpty

# The current directory is the parent of all selected files and directories
# ("${fm_files[@]}"). Instead of getting the device number for each file in the
# loop ("${fm_files[@]}"), we get it once here. It's faster when trashing
# thousands of files. However, the device number will still need to be tested in
# the loop for directories because one could be a mount point.
currentDirectoryDevice=$(stat -c %D "$fm_pwd")

# Will be used for the deletion date. It's faster to get it once here than to
# create a subprocess for each file in the loop ("${fm_files[@]}"), and the
# small possible difference is really no big deal.
now=$(date +%FT%T)

getTrashDevice
getNumberOfProcessors
numberOfSubshells=0

for file in "${fm_files[@]}"; do
	if ((numberOfProcessors > 1)); then
		if ((numberOfSubshells >= numberOfProcessors)); then
			# The use of "wait" isn't suboptimal here because the asynchronous
			# commands are so fast than tracking jobs as the example below slows
			# down the script:
			#
			# for file in "${fm_files[@]}"; do
			#	if ((numberOfProcessors > 1)); then
			#		while (($(jobs -r | wc -l) >= numberOfProcessors)); do
			#			sleep 0.0001
			#		done
			#		
			#		moveToTrash &
			#	else
			#		moveToTrash
			#	fi
			# done
			wait
			numberOfSubshells=0
		fi
		
		moveToTrash &
		((++numberOfSubshells))
	else
		moveToTrash
	fi
done

wait
exit $?

# Example variables available for use: (imported by $fm_import)
# These variables represent the state of the file manager when command is run.
# These variables can also be used in command lines and in the Smartbar.

# "${fm_files[@]}"          selected files              ( same as %F )
# "$fm_file"                first selected file         ( same as %f )
# "${fm_files[2]}"          third selected file

# "${fm_filenames[@]}"      selected filenames          ( same as %N )
# "$fm_filename"            first selected filename     ( same as %n )

# "$fm_pwd"                 current directory           ( same as %d )
# "${fm_pwd_tab[4]}"        current directory of tab 4
# $fm_panel                 current panel number (1-4)
# $fm_tab                   current tab number

# "${fm_panel3_files[@]}"   selected files in panel 3
# "${fm_pwd_panel[3]}"      current directory in panel 3
# "${fm_pwd_panel3_tab[2]}" current directory in panel 3 tab 2
# ${fm_tab_panel[3]}        current tab number in panel 3

# "${fm_desktop_files[@]}"  selected files on desktop (when run from desktop)
# "$fm_desktop_pwd"         desktop directory (eg '/home/user/Desktop')

# "$fm_device"              selected device (eg /dev/sr0)  ( same as %v )
# "$fm_device_udi"          device ID
# "$fm_device_mount_point"  device mount point if mounted (eg /media/dvd) (%m)
# "$fm_device_label"        device volume label            ( same as %l )
# "$fm_device_fstype"       device fs_type (eg vfat)
# "$fm_device_size"         device volume size in bytes
# "$fm_device_display_name" device display name
# "$fm_device_icon"         icon currently shown for this device
# $fm_device_is_mounted     device is mounted (0=no or 1=yes)
# $fm_device_is_optical     device is an optical drive (0 or 1)
# $fm_device_is_table       a partition table (usually a whole device)
# $fm_device_is_floppy      device is a floppy drive (0 or 1)
# $fm_device_is_removable   device appears to be removable (0 or 1)
# $fm_device_is_audiocd     optical device contains an audio CD (0 or 1)
# $fm_device_is_dvd         optical device contains a DVD (0 or 1)
# $fm_device_is_blank       device contains blank media (0 or 1)
# $fm_device_is_mountable   device APPEARS to be mountable (0 or 1)
# $fm_device_nopolicy       udisks no_policy set (no automount) (0 or 1)

# "$fm_panel3_device"       panel 3 selected device (eg /dev/sdd1)
# "$fm_panel3_device_udi"   panel 3 device ID
# ...                       (all these are the same as above for each panel)

# "fm_bookmark"             selected bookmark directory     ( same as %b )
# "fm_panel3_bookmark"      panel 3 selected bookmark directory

# "fm_task_type"            currently SELECTED task type (eg 'run','copy')
# "fm_task_name"            selected task name (custom menu item name)
# "fm_task_pwd"             selected task working directory ( same as %t )
# "fm_task_pid"             selected task pid               ( same as %p )
# "fm_task_command"         selected task command

# "$fm_command"             current command
# "$fm_value"               menu item value             ( same as %a )
# "$fm_user"                original user who ran this command
# "$fm_cmd_name"            menu name of current command
# "$fm_cmd_dir"             command files directory (for read only)
# "$fm_cmd_data"            command data directory (must create)
#                                 To create:   mkdir -p "$fm_cmd_data"
# "$fm_plugin_dir"          top plugin directory
# tmp="$(fm_new_tmp)"       makes new temp directory (destroy when done)
#                                 To destroy:  rm -rf "$tmp"

# $fm_import                command to import above variables (this
#                           variable is exported so you can use it in any
#                           script run from this script)


# Script Example 1:

#   # show MD5 sums of selected files
#   md5sum "${fm_files[@]}"


# Script Example 2:

#   # Build list of filenames in panel 4:
#   i=0
#   for f in "${fm_panel4_files[@]}"; do
#       panel4_names[$i]="$(basename "$f")"
#       (( i++ ))
#   done
#   echo "${panel4_names[@]}"


# Script Example 3:

#   # Copy selected files to panel 2
#      # make sure panel 2 is visible ?
#      # and files are selected ?
#      # and current panel isn't 2 ?
#   if [ "${fm_pwd_panel[2]}" != "" ] \
#               && [ "${fm_files[0]}" != "" ] \
#               && [ "$fm_panel" != 2 ]; then
#       cp "${fm_files[@]}" "${fm_pwd_panel[2]}"
#   else
#       echo "Can't copy to panel 2"
#       exit 1    # shows error if 'Popup Error' enabled
#   fi


# Bash Scripting Guide:  http://www.tldp.org/LDP/abs/html/index.html

# NOTE: Additional variables or examples may be available in future versions.
#       Create a new command script to see the latest list of variables.

