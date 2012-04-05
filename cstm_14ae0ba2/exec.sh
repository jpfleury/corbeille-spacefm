#!/bin/bash

# Command "Limit the Size of the Trash".

# Import file manager variables (scroll down for info).
$fm_import

# Localization, requirements, variables, files and functions.
. "$fm_cmd_dir/init.inc.sh"

########################################################################
##
## Functions specific to this script.
##
########################################################################

addFileProperties()
{
	getTrashinfoFilePath
	testTrashinfoFileExists
	getTrashinfoValue "DeletionDate"
	testDeletionDateIsWellFormed
	getFileSize "$file"
	
	# This string format will allow to easily sorting by deletion date, then by
	# file size, then by file path.
	printf "%s\0" "$deletionDate/$fileSize/$file" >> "$1"
}

delete()
{
	getTrashinfoFilePath
	testTrashinfoFileExists
	rmFileInTrash
}

rmTmpDir()
{
	rm -rf "$tmpDir"
}

testTmpFileExists()
{
	if [[ ! -e $1 ]]; then
		printf "${msg[ERR_CREATE_TMP]}\n\n" >&2
		exit 1
	fi
}

########################################################################
##
## Main script code.
##
########################################################################

testFmValueIsNonNegativeInteger
((bytesPerGiB = 1024 * 1024 * 1024))
trashSizeLimit=$((fm_value * bytesPerGiB))
getTrashSize

if ((trashSize <= trashSizeLimit)); then
	exit 0
fi

getTrashedFiles

if [[ $trashSizeLimit == 0 ]]; then
	filesToDelete=("${trashedFiles[@]}")
else
	tmpDir=$(fm_new_tmp 2>&-)
	testTmpFileExists "$tmpDir"
	trap rmTmpDir 0 1 2 3 15
	
	# About the append redirect in the temporary file by concurrent processes, it
	# wouldn't cause any problem locally because the redirection operator ">>" makes
	# Bash to use the flag "O_APPEND". More information:
	#
	# * Extract from "man 2 open": "O_APPEND The file is opened in append mode.
	#   Before each write(2), the file offset is positioned at the end of the file,
	#   as if with lseek(2)."
	#
	# * We can test it with the following command:
	#
	#   "strace -e open bash -c '>> test-file' 2>&1 | grep O_APPEND"
	#
	#   Example of output: "open("test-file", O_WRONLY|O_CREAT|O_APPEND, 0666) = 3".
	#
	# However, this causes problem with NFS, because this protocol doesn't support
	# atomic append operation. Extract from "man 2 open": "O_APPEND may lead to
	# corrupted files on NFS file systems if more than one process appends data to
	# a file at once. This is because NFS does not support appending to a file, so
	# the client kernel has to simulate it, which can't be done without a race
	# condition."
	#
	# Therefore, as many temporary files as processors will be used, then concatenated.
	
	tmpFileArray=()
	getNumberOfProcessors
	
	for ((i = 0; i < $numberOfProcessors; i++)); do
		tmpFileArray+=("$(mktemp -p "$tmpDir" 2>&-)")
	done
	
	for file in "${tmpFileArray[@]}"; do
		testTmpFileExists "$file"
	done
	
	numberOfSubshells=0
	
	for file in "${trashedFiles[@]}"; do
		if ((numberOfProcessors > 1)); then
			if ((numberOfSubshells >= numberOfProcessors)); then
				wait
				numberOfSubshells=0
			fi
			
			addFileProperties "${tmpFileArray[$numberOfSubshells]}" &
			((++numberOfSubshells))
		else
			addFileProperties "${tmpFileArray[0]}"
		fi
	done
	
	wait
	
	# Concatenate all temporary files.
	tmpFile=$tmpDir/all
	cat "${tmpFileArray[@]}" > "$tmpFile"
	testTmpFileExists "$tmpFile"
	
	totalSizeOfFilesNotDeleted=0
	filesToDelete=()
	everythingIsRead=false
	
	# Note: "mapfile" can't be used since this command doesn't have any option to use
	# a custom delimiter (only newlines are recognized).
	until "$everythingIsRead"; do
		# The null character must be used to handle filenames containing newlines.
		read -d $'\0' -r line || everythingIsRead=true
		
		# deletion date/file size/file path
		if [[ ! $line =~ ^([^/]+)/([^/]+)/(.+)$ ]]; then
			continue
		fi
		
		deletionDate=${BASH_REMATCH[1]}
		fileSize=${BASH_REMATCH[2]}
		filePath=${BASH_REMATCH[3]}
		
		((totalSizeOfFilesNotDeleted += fileSize))
		
		if ((totalSizeOfFilesNotDeleted <= trashSizeLimit)); then
			continue
		fi
		
		filesToDelete+=("$filePath")
	done < <(sort -rz "$tmpFile")
	
	rmTmpDir
	trap 0
fi

numberOfSubshells=0

for file in "${filesToDelete[@]}"; do
	if ((numberOfProcessors > 1)); then
		if ((numberOfSubshells >= numberOfProcessors)); then
			wait
			numberOfSubshells=0
		fi
		
		delete &
		((++numberOfSubshells))
	else
		delete
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

