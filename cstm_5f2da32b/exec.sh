#!/bin/bash

# Command "Restore".

# Import file manager variables (scroll down for info).
$fm_import

# Localization, requirements, variables, files and functions.
. "$fm_cmd_dir/init.inc.sh"

########################################################################
##
## Functions specific to this script.
##
########################################################################

restore()
{
	testFileExists
	testIsTrashed
	testIsNotFileDot
	getTrashinfoFilePath
	testTrashinfoFileExists
	getTrashinfoValue "Path"
	
	if [[ -z $restoredFile ]]; then
		printf "${msg[ERR_TRASHINFO_FORMAT]}\n\n" "$trashinfoFilePath" "$file" >&2
		continue
	fi
	
	# Decode encoded path.
	restoredFile=$(printf "${restoredFile//%/\x}")
	
	# Make sure the path is absolute. From the specification:
	#
	#	"The key “Path” contains the original location of the file/directory, as
	#	either an absolute pathname (starting with the slash character “/”) or a
	#	relative pathname (starting with any other character). A relative pathname
	#	is to be from the directory in which the trash directory resides (i.e.,
	#	from $XDG_DATA_HOME for the “home trash” directory); it MUST not include
	#	a “..” directory, and for files not “under” that directory, absolute
	#	pathnames must be used."
	#
	# It's a bit strange. Why should a relative path start from the parent
	# directory of the trash? No files are in practice trashed from there.
	# I searched on the web and found the following discussion:
	# <http://lists.freedesktop.org/archives/xdg/2008-July/009750.html>.
	# Extract:
	#
	#	"what this means here is: relative to the $topdir. This is where the
	#	trash resides, globally, without taking into account the small detail
	#	of the .Trash/$uid subdir stuff. [...] I agree that this could be
	#	misread, but then it doesn't make sense :-) What makes sense, is to
	#	store relative paths from the mountpoint, i.e. from $topdir."
	#
	# Indeed. It's what I do below. However, taken literally, the specification
	# doesn't say that.
	if [[ $restoredFile != /* ]]; then
		restoredFile=$trashMountPoint/$restoredFile
	fi
	
	if [[ -e $restoredFile || -L $restoredFile ]]; then
		printf "${msg[ERR_ORIGINAL_EXISTS]}\n\n" "$file" "$restoredFile" >&2
		continue
	fi
	
	set -o noclobber
	
	# The creation of the file/directory is atomic. See the script
	# "Move to Trash" for details.
	if [[ -d $file && ! -L $file ]]; then
		{ mkdir "$restoredFile" && mv -T "$file" "$restoredFile"; } 2>&-
	else
		{ > "$restoredFile" && mv "$file" "$restoredFile"; } 2>&-
	fi
	
	exitStatus=$?
	set +o noclobber
	
	if [[ $exitStatus != 0 ]]; then
		printf "${msg[ERR_RESTORING]}\n\n" "$file" "$restoredFile" >&2
		continue
	elif ! rm -f "$trashinfoFilePath" 2>&-; then
		printf "${msg[ERR_RM_TRASHINFO]}\n\n" "$trashinfoFilePath" >&2
		continue
	fi
}

########################################################################
##
## Main script code.
##
########################################################################

testFmFilenameIsNotEmpty
trashMountPoint=$(df -P "$trash")
trashMountPoint="${trashMountPoint##*% }"
getNumberOfProcessors
numberOfSubshells=0

for file in "${fm_files[@]}"; do
	if ((numberOfProcessors > 1)); then
		if ((numberOfSubshells >= numberOfProcessors)); then
			wait
			numberOfSubshells=0
		fi
		
		restore &
		((++numberOfSubshells))
	else
		restore
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

