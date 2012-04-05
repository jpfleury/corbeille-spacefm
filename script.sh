#!/bin/bash

set -e

########################################################################
##
## Functions.
##
########################################################################

createTmpDir()
{
	mkdir -v "$1"
	trap "rm -rfv "$1"" 0 1 2 3 15
}

########################################################################
##
## Variables.
##
########################################################################

# All commands use a file "init.inc.sh". This file could be put in the top
# plugin directory ($fm_plugin_dir). However, one may copy a command to paste
# it elsewhere. In this case, the file "init.inc.sh" would no longer be usable.
# Therefore, the file is copied in each command directory.

prefix=cstm_

# Script containing the file "init.inc.sh" used as reference (the one modified
# to be copied later).
referenceScript=07e29d93

# All other scripts also using "init.inc.sh".
otherScripts=(5f2da32b 4dd8d781 5547e7e2 33004b48 4797e2c9 14ae0ba2 649b55e5 7397b1e3)

allScripts=("$referenceScript" "${otherScripts[@]}")

# Empty directories (for the plugin itself and for separators).
emptyDir=(73def2cb 34fb861a 59ec5ff8 49454e21)

########################################################################
##
## Main script code.
##
########################################################################

# Generate an archive from the source code. This archive can be used in SpaceFM
# to install the plugin.
if [[ $1 == archive ]]; then
	if [[ $2 != @(en|fr) ]]; then
		echo "Please pass a valid language parameter."
		exit 1
	fi
	
	tmpDir=corbeille-tmp
	createTmpDir "$tmpDir"
	
	for script in "${allScripts[@]}"; do
		cp -rv "$prefix$script" "$tmpDir"
		cp -v "$prefix$referenceScript/init.inc.sh" "$tmpDir/$prefix$script"
	done
	
	for dir in "${emptyDir[@]}"; do
		mkdir -v "$tmpDir/$prefix$dir"
	done
	
	cp plugin "$tmpDir"
	
	if [[ -f sed-$2-patterns.txt ]]; then
		sed -i -f "sed-$2-patterns.txt" "$tmpDir/plugin"
	fi
	
	cp -rv doc/* "$tmpDir"
	
	if [[ -n $3 ]]; then
		version=$3
	else
		version=source
	fi
	
	tar -zcvf "Corbeille-$2-$version.spacefm-plugin.tar.gz" -C "$tmpDir" .

# Update the Corbeille-SpaceFM git repository from the contents of an archive
# exported by SpaceFM. It's expected that the archive will be in French, located
# on the desktop and named "Corbeille.spacefm-plugin.tar.gz".
elif [[ $1 == git ]]; then
	desktopPath=$(xdg-user-dir DESKTOP)
	archivePath=$desktopPath/Corbeille.spacefm-plugin.tar.gz
	
	if [[ ! -e $archivePath ]]; then
		echo "Please provide a valid path to the plugin archive."
		exit 1
	fi
	
	tmpDir=${archivePath%.*.*}
	createTmpDir "$tmpDir"
	tar -zxvf "$archivePath" -C "$tmpDir"
	
	for script in "${allScripts[@]}"; do
		mkdir -pv "$prefix$script"
		cp -v "$tmpDir/$prefix$script/exec.sh" "$prefix$script"
	done
	
	# Just one file "init.inc.sh" in the repository.
	cp -v "$tmpDir/$prefix$referenceScript/init.inc.sh" "$prefix$referenceScript"
	
	cp -v "$tmpDir/plugin" .

# Update the file "init.inc.sh" for all commands of the plugin used in SpaceFM.
elif [[ $1 == init ]]; then
	path=$HOME/.config/spacefm/scripts
	
	for script in "${otherScripts[@]}"; do
		cp -v "$path/$prefix$referenceScript/init.inc.sh" "$path/$prefix$script"
	done
fi

