#!/bin/bash

set -e

################################################################################
## @title Functions
################################################################################

create_tmp_dir() {
	local dir=$1
	
	mkdir -pv "$dir"
	
	# shellcheck disable=SC2064
	trap "rm -rfv \"$dir\"" EXIT HUP INT QUIT TERM
}

################################################################################
## @title Variables
################################################################################

# All commands use a file named "init.inc.sh". This file could be placed in the top
# plugin directory ($fm_plugin_dir). However, one may copy a command and paste
# it elsewhere. In that case, the file "init.inc.sh" would no longer be usable.
# Therefore, the file is copied into each command directory.

prefix=cstm_

# Script containing the "init.inc.sh" file used as a reference (the one modified
# to be copied later).
reference_script=07e29d93

# All other scripts also use "init.inc.sh".
other_scripts=(
	5f2da32b
	4dd8d781
	5547e7e2
	33004b48
	4797e2c9
	14ae0ba2
	649b55e5
	7397b1e3
)

all_scripts=(
	"$reference_script"
	"${other_scripts[@]}"
)

# Empty directories (for the plugin itself and for separators).
empty_dir=(
	73def2cb
	34fb861a
	59ec5ff8
	49454e21
)

########################################
## @subtitle Arguments
########################################

action=$1
language=$2
version=$3

################################################################################
## @title Script
################################################################################

# Generate an archive from the source code. This archive can be used to install
# the plugin in SpaceFM.
if [[ $action == archive ]]; then
	if [[ $language != en && $language != fr && $language != sv ]]; then
		echo "Please pass a valid language parameter." 1>&2
		
		exit 1
	fi
	
	tmp_dir=corbeille-tmp
	create_tmp_dir "$tmp_dir"
	
	for script in "${all_scripts[@]}"; do
		cp -rv "${prefix}${script}" "$tmp_dir"
		cp -v "${prefix}${reference_script}/init.inc.sh" "${tmp_dir}/${prefix}${script}"
		cp -v README.md "${tmp_dir}/${prefix}${script}"
	done
	
	for dir in "${empty_dir[@]}"; do
		mkdir -v "${tmp_dir}/${prefix}${dir}"
	done
	
	cp -v plugin "$tmp_dir"
	
	if [[ -f sed-$language-patterns.txt ]]; then
		sed -i -f "sed-$language-patterns.txt" "$tmp_dir/plugin"
	fi
	
	cp -v COPYING "$tmp_dir"
	cp -v LISEZ-MOI.md "$tmp_dir"
	cp -v README.md "$tmp_dir"
	
	if [[ -z $version ]]; then
		version=source
	fi
	
	tar -zcvf "Corbeille-$language-$version.spacefm-plugin.tar.gz" -C "$tmp_dir" .

# Update the Corbeille-SpaceFM git repository from the contents of an archive
# exported by SpaceFM. The archive is expected to be in French, located
# on the desktop, and named "Corbeille.spacefm-plugin.tar.gz".
elif [[ $action == git ]]; then
	desktop_path=$(xdg-user-dir DESKTOP)
	archive_path=$desktop_path/Corbeille.spacefm-plugin.tar.gz
	
	if [[ ! -f $archive_path ]]; then
		echo "Please provide a valid path to the plugin archive." 1>&2
		
		exit 1
	fi
	
	tmp_dir=${archive_path%.*.*}
	create_tmp_dir "$tmp_dir"
	tar -zxvf "$archive_path" -C "$tmp_dir"
	
	for script in "${all_scripts[@]}"; do
		mkdir -pv "${prefix}${script}"
		cp -v "${tmp_dir}/${prefix}${script}/exec.sh" "${prefix}${script}"
	done
	
	# Just one file "init.inc.sh" in the repository.
	cp -v "${tmp_dir}/${prefix}${reference_script}/init.inc.sh" "${prefix}${reference_script}"
	
	cp -v "$tmp_dir/plugin" .

# Update the file "init.inc.sh" for all commands of the plugin used in SpaceFM.
elif [[ $action == init ]]; then
	path_spacefm_scripts=$HOME/.config/spacefm/scripts
	
	for script in "${other_scripts[@]}"; do
		cp -v "${path_spacefm_scripts}/${prefix}${reference_script}/init.inc.sh" "${path_spacefm_scripts}/${prefix}${script}"
	done

else
	echo "Invalid action: $action" 1>&2
	
	exit 1
fi
