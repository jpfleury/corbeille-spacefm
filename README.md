## Overview

Corbeille-SpaceFM ("Corbeille" is the French word for "Trash can") is a plugin that adds trash support to the file manager [SpaceFM](http://ignorantguru.github.com/spacefm/).

Corbeille-SpaceFM is compliant with the [FreeDesktop.org Trash specification](http://standards.freedesktop.org/trash-spec/trashspec-latest.html), so it's interoperable with other compliant implementations, which will be able to manage files moved to the trash by Corbeille-SpaceFM, and vice versa. Tests were conducted with Thunar, Nautilus, and Dolphin.

Corbeille-SpaceFM supports filenames containing any characters, including newlines.

It was also coded with speed in mind. It supports multi-core processing and can manage hundreds or thousands of files without significant delays. See the *Details* section below for benchmarks.

## Requirements

Special attention was given to keeping the requirements minimal. It's written in Bash and only uses a few external tools from the `coreutils` package (`ls`, `mv`, `rm`...), so it should work out-of-the-box for most users. If not, refer to the error message displayed when using a plugin command.

## Installation

The plugin is available in a few languages:

- [English](http://www.jpfleury.net/site/fichiers/corbeille-spacefm/Corbeille-en-source.spacefm-plugin.tar.gz)

- [French](http://www.jpfleury.net/site/fichiers/corbeille-spacefm/Corbeille-fr-source.spacefm-plugin.tar.gz)

- [Swedish](http://www.jpfleury.net/site/fichiers/corbeille-spacefm/Corbeille-sv-source.spacefm-plugin.tar.gz)

You can use the downloaded archive to install the plugin in SpaceFM. Instructions to install a plugin in SpaceFM are available in the SpaceFM manual. In short, you can:

- [install a plugin](http://ignorantguru.github.com/spacefm/spacefm-manual-en.html#plugins-install), so it will be root protected (root password needed) and available to all users in the SpaceFM menu *Plugins*, or

- [copy a plugin](http://ignorantguru.github.com/spacefm/spacefm-manual-en.html#plugins-copy), and paste it elsewhere (no root password needed).

### From source code

An archive of Corbeille-SpaceFM can be built from the source code:

- [Download the source code.](https://github.com/jpfleury/corbeille-spacefm/archive/master.zip)

- Extract the archive.

- Open a terminal in the extracted directory.

- In the terminal, run the following command:

		./script.sh archive $LANG

Possible values for `$LANG` are `en` (English), `fr` (French) and `sv` (Swedish). An archive will be created at the root of the directory. You can use it to install the plugin in SpaceFM.

## Uninstallation

See the instructions for [uninstalling a plugin](http://ignorantguru.github.com/spacefm/spacefm-manual-en.html#plugins-uninstall) in the SpaceFM manual.

## Usage

Corbeille-SpaceFM consists of 9 commands (available in the SpaceFM menu *Plugins | Trash* if installed with root protection). Note that **there is no confirmation dialog** before proceeding with the selected action.

- *Move to Trash*: you must select at least one file outside the trash directory for this command to be enabled. Selected files will be moved to the trash.

- *Restore*: you must select at least one file in the trash directory for this command to be enabled. Selected files will be moved back to their original location. If the original location already exists, the file won't be moved and an error will be displayed.

- *Delete Permanently*: you must select at least one file in the trash directory for this command to be enabled. Selected files will be deleted permanently, so they will no longer be recoverable from the trash.

- *Go to Trash*: this command is always enabled. It opens the trash directory in a new tab in the current SpaceFM window. Also, if top directory trashes are detected (for example, a trash on a removable device), each will be opened in a new tab.

- *Display Properties*: this command is always enabled. It opens a pop-up dialog displaying the number of files in the trash and the total size of the trash.

- *Empty Trash*: this command is always enabled. It's simply a convenient way to permanently delete all files in the trash. You can achieve the same result by selecting all files in the trash and choosing to delete them permanently.

- *Limit the Size of the Trash*: this command is always enabled. It allows you to reduce the trash to a specified size. Files are deleted in ascending order of their trashing date (older files are deleted first).

- *Delete Old Files*: this command is always enabled. It allows you to delete files that have been in the trash for a given number of days.

- *Delete Big Files*: this command is always enabled. It allows you to delete files in the trash whose size is greater than or equal to a specified threshold.

## Details

### Speed

Corbeille-SpaceFM was designed to be fast, even when handling a large number of files. Multi-core processing is supported, Bash built-in commands were favored whenever possible, and subprocesses inside loops were reduced to an absolute minimum.

Below are benchmarks comparing Corbeille-SpaceFM with Thunar, the default file manager of Xfce (I chose Thunar because Xfce is the desktop environment I use). Each command handled 1000 plain text files and was executed 5 times. The results are the average time in seconds.

The first benchmark was conducted on a laptop with an Intel Core 2 Duo T9300 processor and 4 GiB of RAM. SpaceFM 0.7.3 and Thunar 1.2.3 were used on Xubuntu 11.10. The results are:

|                        | Corbeille-SpaceFM | Thunar |
| ---------------------- | ----------------- | ------ |
| **Move to Trash**      | 3                 | 12     |
| **Delete Permanently** | 3                 | 12     |
| **Restore**            | 4                 | 15     |
| **Empty Trash**        | 1                 | 1      |

The second benchmark was on a netbook with an Intel Atom N450 and 2 GiB of RAM. SpaceFM 0.7.3 and Thunar 1.2.3 were used on Ubuntu 11.10. Results are:

|                        | Corbeille-SpaceFM | Thunar |
| ---------------------- | ----------------- | ------ |
| **Move to Trash**      | 15                | 41     |
| **Delete Permanently** | 14                | 44     |
| **Restore**            | 19                | 50     |
| **Empty Trash**        | 10                | 6      |

### Symbols used for file size

Corbeille-SpaceFM uses the conventional [binary prefix](http://en.wikipedia.org/wiki/Binary_prefix) system when displaying file sizes, i.e. powers of 2, along with the newer prefixes proposed to clearly distinguish binary prefixes from SI prefixes (based on powers of 10). For example, MiB is used for 1024 KiB, and 1 KiB refers to 1024 bytes.

### Trashable files

Files on the same device as the home trash are moved to this trash, i.e. `$XDG_DATA_HOME/Trash`. Most of the time, this will result in moving files to `/home/user/.local/share/Trash/files`.

Files on other devices are not handled by Corbeille-SpaceFM, as allowed by the specification. The reasons are that such trashing is complex and, in my humble opinion, not very ergonomic.

According to the specification, files on other devices may be moved to the home trash. However, consider these situations:

- Moving external files to the home trash would result in copying these files from their original location to the home trash device. It may be fine for a few files from a USB 2.0 removable device, but what about trashing 50 GiB, or trashing files located on network resources or on slow devices?

	The specification allows the use of exceptions, for example disabling trashing for network locations. However, it doesn't really solve the problem, and I think that moving files from one device to another should result from an explicit action taken by the user.

- Removable devices are sometimes mounted with different names, so a file trashed one day may not be restorable if the device was unmounted and mounted again in the meantime.

- A file trashed from a removable device won't be restorable if the device in question isn't mounted.

An implementation may choose instead to support trashing in top directories, i.e. directly at the root of a mounted file system. However, consider the following:

- Two locations are possible, `$topdir/.Trash/$uid` and `$topdir/.Trash-$uid`, so there are two locations to check, with the risk of two non-empty trashes on the same device for a single user.

- A lot of cases are very tricky: file systems without sticky bit support, without numeric user ID or without user ID at all, without permissions, etc. If there are too many exceptions, is it still useful?

- One can use a removable device on multiple systems with different user IDs, so each time with a different trash directory. Their own previously trashed files aren't accessible to them (except by using root privileges).

Also, I consulted bug reports in Launchpad about the trashing mechanism and found some interesting cases:

- The trashed files are located in a hidden directory, so they're not displayed by default in most file managers. There are bug reports regarding users who shared their device without knowing that their deleted files were located in a hidden directory. People with whom the device was shared had access to the trash, especially considering that the trash isn't a hidden directory on Windows.

- There are bug reports about users not being able to add files to their device while they had trashed contents. They didn't know that a hidden trash was present on their device and was still using disk space.

- There are bug reports about the fact that hidden trash directories are created automatically and never deleted, even when empty.

- There are bug reports about adding the ability to disable top directory trashing.

See for example this old (2005) bug report with 13 duplicates and 104 comments, [Shouldn't put .Trash-$USER on removable devices](https://bugs.launchpad.net/ubuntu/+source/nautilus/+bug/12893), or this other one (2004), [Ask to empty when unmounting media with items in trash](https://bugzilla.gnome.org/show_bug.cgi?id=138058), with 12 duplicates and 44 comments. Both are marked as fixed, but they're not. What we can observe is a lot of confusion from users and unclear implementations (or specifications).

Personally, I would add that some file managers display files from top directory trashes directly in the home trash without any differentiation between them and the local ones. One may empty the home trash without knowing that it will also empty trashes located on other devices. One may want to empty a top directory trash without emptying the home trash but find no way to accomplish this. One may also think that all files listed in the home trash are (logically) located on the home device, but after unmounting a removable device (and maybe sharing it), realize that some trashed files are no longer accessible (or, in other words, that the device still contains the trashed files). All of this is confusing.

I really think that the best way to handle trashing of files located on a different device is to let the user manage it manually. For example, one can manually move files to the home partition, then decide to move them to the home trash.

However, note that the Corbeille-SpaceFM command *Go to Trash* will display top directory trashes, if any, since the specification states:

> If an implementation does NOT provide such trashing, and does provide the user
> with some interface to view and/or undelete trashed files, it SHOULD make a
> “best effort” to show files trashed in top directories (by both methods) to
> the user, among other trashed files or in a clearly accessible separate way.

## Localization

Corbeille-SpaceFM is translatable:

- Right-click on any Corbeille-SpaceFM command name and choose *Command | Browse | Files*. Open the file `init.inc.sh`, located at the root of the directory. Strings to translate are located in the sections *Localization, 1 of 2* and *Localization, 2 of 2*.

- Right-click on any Corbeille-SpaceFM command name and choose *Command | Browse | Plugin*. Open the file `plugin`, located at the root of the directory. Strings to translate are in the following format:

		cstm_00000000-label=String to translate  
		cstm_00000000-desc=String to translate

Anyone interested can translate all strings and send me the result.

## Development

Git is used for revision control. [The repository can be browsed online or cloned.](https://github.com/jpfleury/corbeille-spacefm)

## License

Author: Jean-Philippe Fleury (<http://www.jpfleury.net/en/contact.php>)  
Copyright © 2012 Jean-Philippe Fleury

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program.  If not, see <http://www.gnu.org/licenses/>.
