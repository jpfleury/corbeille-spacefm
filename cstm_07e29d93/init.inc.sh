########################################################################
##
## Localization, 1 of 2.
##
########################################################################

# English.
msgErrBashVersion="Bash >= 4.0 is required, but your version is %s."

# French.
if [[ ${LANG:0:2} == fr ]]; then
	msgErrBashVersion="Bash >= 4.0 est requis, mais votre version est %s."
fi

# Swedish.
if [[ ${LANG:0:2} == sv ]]; then
	msgErrBashVersion="Bash >= 4.0 krävs, men versionen är %s."
fi

########################################################################
##
## Requirements, 1 of 2.
##
########################################################################

# AFAIK, associative arrays, added in Bash 4.0 (published in February 2009), are
# the most recent Bash features used in these scripts.
if ((${BASH_VERSION:0:1} < 4)); then
	printf "$msgErrBashVersion\n\n" "$BASH_VERSION" >&2
	exit 1
fi

########################################################################
##
## Localization, 2 of 2.
##
########################################################################

declare -A msg

####################################
##
## English.
##
####################################

msg[ERR_COREUTILS]="Please install the package \"coreutils\" in order to use this script."

msg[ERR_CREATE_TMP]="Temporary files, needed to run the script, can't be created. No action was performed."

msg[ERR_CREATE_TRASHINFO]="The information file \"%s\" can't be created because of insufficient permissions (must be write and execute) on its parent directory."

msg[ERR_CREATE_TRASH]="The trash directory \"%s\" or its subdirectories \"files\" and \"info\" can't be created."

msg[ERR_DEVICE]="The file \"%s\" wasn't moved to the home trash directory because it's on a different device. Note that you can use the SpaceFM built-in command \"Delete\" to delete the file without previously trashing it."

msg[ERR_FILE_DOT]="Error with the file \"%s\": dot and dot-dot can't be used as filename."

msg[ERR_FM_VALUE]="The value entered isn't valid. It must be an integer greater than or equal to 0."

msg[ERR_LINK_TRASH]="The top directory trash \"%s\" is a symbolic link. You should investigate or report this to the system administrator."

msg[ERR_NO_FILE]="The file \"%s\" doesn't exist."

msg[ERR_NO_SELECTION]="Please select at least one file."

msg[ERR_NOT_IN_TRASH]="The file \"%s\" isn't on the trash."

msg[ERR_NO_TRASHINFO]="There's no information file associated with the file \"%s\". No action was performed."

msg[ERR_ORIGINAL_EXISTS]="The file \"%s\" can't be restored because its original location \"%s\" already exists."

msg[ERR_PERM_DIR]="The directory \"%s\" doesn't have sufficient permissions to be moved to the trash. Permissions required are read and write for empty directories, or read, write and execute for non empty directories."

msg[ERR_PERM_PARENT]="The file \"%s\" can't be moved to the trash because of insufficient permissions on its parent directory."

msg[ERR_PERM_TRASH]="Insufficient permissions (must be read, write and execute) on the subdirectories \"files\" and \"info\" of the trash \"%s\"."

msg[ERR_RESTORING]="An error occurred during the restoration of the file \"%s\" to its original location \"%s\". The file wasn't restored."

msg[ERR_RM_FILE]="An error occurred during the deletion of the file \"%s\". The deletion was aborted."

msg[ERR_RM_TRASHINFO]="An error occurred during the deletion of the information file \"%s\". You should try to delete it by hand."

msg[ERR_STICKY_BIT_TRASH]="The top directory trash \"%s\" doesn't have the sticky bit set. You should investigate or report this to the system administrator."

msg[ERR_TRASHINFO_FORMAT]="The information file \"%s\", associated with the file \"%s\", isn't well-formed. No action was performed."

msg[ERR_TRASHING]="An error occurred during the trashing of the file \"%s\". It wasn't moved to the trash."

msg[ERR_TRASHING_TRASH]="Error with the file \"%s\": you can't move to the trash the trash itself or an already trashed file."

msg[ERR_TRASH_PATH]="The trash path can't be determined."

msg[PROP_NUMBER]="Number of Files: %s"

msg[PROP_SIZE_B]="(%s B)"

msg[PROP_SIZE]="Total Size: %s %s"

msg[PROP_TITLE]="## Trash Properties ##"

msg[UNIT_0]="B"

msg[UNIT_1]="KiB"

msg[UNIT_2]="MiB"

msg[UNIT_3]="GiB"

msg[UNIT_4]="TiB"

msg[UNIT_5]="PiB"

msg[UNIT_6]="EiB"

msg[UNIT_7]="ZiB"

msg[UNIT_8]="YiB"

####################################
##
## French.
##
####################################
if [[ ${LANG:0:2} == fr ]]; then
	msg[ERR_COREUTILS]="Veuillez installer le paquet «coreutils» afin de pouvoir utiliser ce script."

	msg[ERR_CREATE_TMP]="Les fichiers temporaires, nécessaires au fonctionnement du script, n'ont pu être créés. Aucune action n'a été effectuée."

	msg[ERR_CREATE_TRASHINFO]="Le fichier d'information «%s» ne peut être créé en raison de permissions insuffisantes du dossier parent (qui doit être accessible en écriture et en exécution)."

	msg[ERR_CREATE_TRASH]="La corbeille «%s» ou ses sous-dossiers «files» et «info» ne peuvent être créés."

	msg[ERR_DEVICE]="Le fichier «%s» n'a pas été mis à la corbeille de bureau, car il se trouve sur une partition différente. Prendre note que la commande intégrée «Supprimer» de SpaceFM peut être utilisée pour supprimer le fichier sans préalablement le mettre à la corbeille."

	msg[ERR_FILE_DOT]="Erreur relative au fichier «%s»: «.» et «..» ne peuvent pas être utilisés comme nom de fichier."

	msg[ERR_FM_VALUE]="La valeur saisie n'est pas valide. Elle doit correspondre à un entier supérieur ou égal à 0."

	msg[ERR_LINK_TRASH]="La corbeille racine «%s» est un lien symbolique. Vous devriez vérifier cette situation de plus près ou la rapporter à l'administrateur système."

	msg[ERR_NO_FILE]="Le fichier «%s» n'existe pas."

	msg[ERR_NO_SELECTION]="Veuillez sélectionner au moins un fichier."

	msg[ERR_NOT_IN_TRASH]="Le fichier «%s» n'est pas dans la corbeille."

	msg[ERR_NO_TRASHINFO]="Aucun fichier d'information n'est associé au fichier «%s». Aucune action n'a été effectuée."

	msg[ERR_ORIGINAL_EXISTS]="Le fichier «%s» ne peut être restauré, car son emplacement original «%s» existe déjà."

	msg[ERR_PERM_DIR]="Le dossier «%s» n'a pas les permissions suffisantes pour être mis à la corbeille. Les permissions de lecture et d'écriture sont requises pour les dossiers vides, et les permissions de lecture, d'écriture et d'exécution le sont pour les dossiers non vides."

	msg[ERR_PERM_PARENT]="Le fichier «%s» ne peut être mis à la corbeille en raison de permissions insuffisantes du dossier parent."

	msg[ERR_PERM_TRASH]="Permissions insuffisantes (doivent correspondre à lecture, écriture et exécution) des sous-dossiers «files» et «info» de la corbeille «%s»."

	msg[ERR_RESTORING]="Une erreur s'est produite durant la restauration du fichier «%s» vers son emplacement original «%s». Le fichier n'a pas été restauré."

	msg[ERR_RM_FILE]="Une erreur s'est produite durant la suppression du fichier «%s». La suppression a été annulée."

	msg[ERR_RM_TRASHINFO]="Une erreur s'est produite durant la suppression du fichier d'information «%s». Vous devriez essayer de le supprimer à la main."

	msg[ERR_STICKY_BIT_TRASH]="La corbeille racine «%s» n'a pas le bit collant («sticky»). Vous devriez vérifier cette situation de plus près ou la rapporter à l'administrateur système."

	msg[ERR_TRASHINFO_FORMAT]="Le fichier d'information «%s», associé au fichier «%s», n'est pas bien formé. Aucune action n'a été effectuée."

	msg[ERR_TRASHING]="Une erreur s'est produite durant la mise à la corbeille du fichier «%s». Le fichier n'a pas été déplacé."

	msg[ERR_TRASHING_TRASH]="Erreur relative au fichier «%s»: vous ne pouvez pas mettre à la corbeille la corbeille elle-même ou un fichier s'y trouvant déjà."

	msg[ERR_TRASH_PATH]="Le chemin de la corbeille ne peut être déterminé."

	msg[PROP_NUMBER]="Nombre de fichiers: %s"

	msg[PROP_SIZE_B]="(%s o)"

	msg[PROP_SIZE]="Taille totale: %s %s"

	msg[PROP_TITLE]="## Propriétés de la corbeille ##"

	msg[UNIT_0]="o"

	msg[UNIT_1]="Kio"

	msg[UNIT_2]="Mio"

	msg[UNIT_3]="Gio"

	msg[UNIT_4]="Tio"

	msg[UNIT_5]="Pio"

	msg[UNIT_6]="Eio"

	msg[UNIT_7]="Zio"

	msg[UNIT_8]="Yio"
fi

####################################
##
## Swedish.
##
####################################
if [[ ${LANG:0:2} == sv ]]; then
	msg[ERR_COREUTILS]="Vänligen installera paketet \"coreutils\" för att använda detta script."

	msg[ERR_CREATE_TMP]="Temporära filer, som behövs för att köra skriptet, kan inte skapas. Ingen åtgärd utfördes."

	msg[ERR_CREATE_TRASHINFO]="Informationsfilen \"%s\" kan inte skapas på grund av otillräcklig behörighet (måste vara skriv och exekverbar) på dess överordnade katalog."

	msg[ERR_CREATE_TRASH]="Papperskorgskatalog \"%s\" eller dess underkataloger \"files\" och \"info\" kan inte skapas."

	msg[ERR_DEVICE]="Filen \"%s\" flyttades inte till hem papperskorgen eftersom det är på en annan enhet. Observera att du kan använda SpaceFM inbyggda kommandot \"Delete\" för att ta bort filen utan att lägga den i papperskorgen."

	msg[ERR_FILE_DOT]="Fel med filen \"%s\": punkt och punkt-punkt kan inte användas som filnamn."

	msg[ERR_FM_VALUE]="Det angivna värdet är inte giltigt. Det måste vara ett heltal större än eller lika med 0."

	msg[ERR_LINK_TRASH]="Den översta katalogen papperskorgen \"%s\" är en symbolisk länk. Du bör undersöka eller anmäla detta till systemadministratören."

	msg[ERR_NO_FILE]="Filen \"%s\" finns inte."

	msg[ERR_NO_SELECTION]="Välj minst en fil."

	msg[ERR_NOT_IN_TRASH]="Filen \"%s\" finns inte i papperskorgen."

	msg[ERR_NO_TRASHINFO]="Det finns ingen informationsfil associerad med filen \"%s\". Ingen åtgärd utfördes."

	msg[ERR_ORIGINAL_EXISTS]="Filen \"%s\" kan inte återställas eftersom dess ursprungliga plats \"%s\" redan finns."

	msg[ERR_PERM_DIR]="Katalogen \"%s\" har inte tillräcklig behörighet för att flyttas till papperskorgen. Behörigheter som krävs är läs och skriv för tomma kataloger, eller läsa, skriv och kör för icke tomma kataloger."

	msg[ERR_PERM_PARENT]="Filen \"%s\" kan inte flyttas till papperskorgen på grund av otillräcklig behörighet på sin överordnade katalog."

	msg[ERR_PERM_TRASH]="Otillräckliga behörigheter (måste vara läs, skriv och körbar) i underkatalogerna \"files\" och \"info\" i papperskorgen \"%s\"."

	msg[ERR_RESTORING]="Ett fel uppstod under återställningen av filen \"%s\" till sin ursprungliga plats \"%s\". Filen återställdes inte."

	msg[ERR_RM_FILE]="Ett fel uppstod vid radering av filen \"%s\". Borttagingen avbröts."

	msg[ERR_RM_TRASHINFO]="Ett fel uppstod vid radering av informationsfilen \"%s\". Du bör försöka att ta bort den för hand."

	msg[ERR_STICKY_BIT_TRASH]="Den översta katalogen papperskorgen \"%s\" har inte den sticky biten satt. Du bör undersöka eller anmäla detta till systemadministratören."

	msg[ERR_TRASHINFO_FORMAT]="Informationsfilen \"%s\", associerad med filen \"%s\", inte välformad. Ingen åtgärd utfördes."

	msg[ERR_TRASHING]="Ett fel inträffade under kassering av filen \"%s\". Den flyttades inte till papperskorgen."

	msg[ERR_TRASHING_TRASH]="Fel med filen \"%s\": du kan inte flytta papperskorgen till papperskorgen själv eller en redan kastad fil."

	msg[ERR_TRASH_PATH]="Papperskorgens sökvägen kan inte fastställas."

	msg[PROP_NUMBER]="Antal filer: %s"

	msg[PROP_SIZE_B]="(%s B)"

	msg[PROP_SIZE]="Total storlek: %s %s"

	msg[PROP_TITLE]="## Egenskaper papperskorgen ##"

	msg[UNIT_0]="B"

	msg[UNIT_1]="KiB"

	msg[UNIT_2]="MiB"

	msg[UNIT_3]="GiB"

	msg[UNIT_4]="TiB"

	msg[UNIT_5]="PiB"

	msg[UNIT_6]="EiB"

	msg[UNIT_7]="ZiB"

	msg[UNIT_8]="YiB"
fi

########################################################################
##
## Requirements, 2 of 2.
##
########################################################################

# External commands used.
if ! type cat date df du mkdir mktemp mv rm sort stat > /dev/null 2>&1; then
	printf "${msg[ERR_COREUTILS]}\n\n" >&2
	exit 1
fi

########################################################################
##
## Variables and files.
##
########################################################################

# Trash directory.

if [[ -n $XDG_DATA_HOME ]]; then
	trash=$XDG_DATA_HOME/Trash
elif [[ -n $HOME ]]; then
	trash=$HOME/.local/share/Trash
else
	printf "${msg[ERR_TRASH_PATH]}\n\n" >&2
	exit 1
fi

if ! mkdir -m 700 -p "$trash"{,/files,/info} 2>&-; then
	printf "${msg[ERR_CREATE_TRASH]}\n\n" "$trash" >&2
	exit 1
fi

if ! [[ -r $trash/files && -w $trash/files && -x $trash/files ]] || \
   ! [[ -r $trash/info && -w $trash/info && -x $trash/info ]]; then
	printf "${msg[ERR_PERM_TRASH]}\n\n" "$trash" >&2
	exit 1
fi

########################################################################
##
## Shared functions.
##
########################################################################

getFileSize()
{
	if [[ -d $1 && ! -L $1 ]]; then
		# Example of output: "86024	/home/user/.local/share/Trash/files".
		fileSize=$(du -bs "$1")
		fileSize=${fileSize%%[[:space:]]*}
	else
		fileSize=$(stat -c %s "$1")
	fi
}

getNumberOfProcessors()
{
	numberOfProcessors=0
	cpuinfoFile=/proc/cpuinfo
	
	if [[ -e $cpuinfoFile ]]; then
		# In order to read the last line, even if it doesn't end with a newline.
		everythingIsRead=false
	
		until "$everythingIsRead"; do
			read -r line || everythingIsRead=true
		
			if [[ $line == processor[[:space:]]* ]]; then
				((++numberOfProcessors))
			fi
		done < "$cpuinfoFile"
	fi
	
	if [[ $numberOfProcessors == 0 ]]; then
		numberOfProcessors=1
	fi
}

getTrashDevice()
{
	trashDevice=$(stat -c %D "$trash")
}

getTrashedFiles()
{
	shopt -s nullglob dotglob
	trashedFiles=("$trash"/files/*)
	shopt -u nullglob dotglob
}

getTrashinfoFilePath()
{
	trashinfoFilePath=$trash/info/${file##*/}.trashinfo
}

getTrashinfoValue()
{
	firstLineRead=false
	everythingIsRead=false
	
	until "$everythingIsRead"; do
		read -r line || everythingIsRead=true
		
		if ! "$firstLineRead"; then
			# From the specification: "Its first line must be [Trash Info]."
			if [[ $line != *([[:space:]])'[Trash Info]'*([[:space:]]) ]]; then
				printf "${msg[ERR_TRASHINFO_FORMAT]}\n\n" "$trashinfoFilePath" "$file" >&2
				continue 2
			fi
			
			firstLineRead=true
			continue
		fi
		
		# Ensure that we're not entering in another group header
		# (we're already in the group header "[Trash Info]").
		if [[ $line == *([[:space:]])[* ]]; then
			break
		fi
		
		if [[ $line =~ ^"$1"\ *=\ *(.*) ]]; then
			if [[ $1 == "Path" ]]; then
				restoredFile=${BASH_REMATCH[1]}
			elif [[ $1 == "DeletionDate" ]]; then
				deletionDate=${BASH_REMATCH[1]}
			fi
			
			break
		fi
	done < "$trashinfoFilePath"
}

getTrashSize()
{
	getFileSize "$trash/files"
	trashSize=$fileSize
	
	# The size of the directory itself is subtracted in order to have a more
	# intuitive displayed size. For example, say the directory itself has a
	# size of 86016 and the trash is empty. The script would present to the
	# user a non-null size for 0 trashed files.
	((trashSize -= $(stat -c %s "$trash/files")))
}

# Note that if a directory doesn't have read permissions,
# the function can't test if it contains files.
isNotEmpty()
{
	if [[ -d $1 && -r $1 ]]; then
		shopt -s nullglob dotglob
		files=("$1"/*)
		shopt -u nullglob dotglob
		
		if ((${#files[@]} > 0)); then
			return 0
		fi
	fi
	
	return 1
}

rmFileInTrash()
{
	if ! rm -rf "$file" 2>&-; then
		printf "${msg[ERR_RM_FILE]}\n\n" "$file" >&2
		continue
	fi
	
	if ! rm -f "$trashinfoFilePath" 2>&-; then
		printf "${msg[ERR_RM_TRASHINFO]}\n\n" "$trashinfoFilePath" >&2
		continue
	fi
}

testDeletionDateIsWellFormed()
{
	# Example: "2012-03-24T03:25:21".
	if [[ ! $deletionDate =~ ^[0-9]{4}(-[0-9]{2}){2}T[0-9]{2}(:[0-9]{2}){2}$ ]]; then
		printf "${msg[ERR_TRASHINFO_FORMAT]}\n\n" "$trashinfoFilePath" "$file" >&2
		continue
	fi
}

testFileExists()
{
	if ! [[ -e $file || -L $file ]]; then
		printf "${msg[ERR_NO_FILE]}\n\n" "$file" >&2
		continue
	fi
}

testFmFilenameIsNotEmpty()
{
	if [[ -z $fm_filename ]]; then
		printf "${msg[ERR_NO_SELECTION]}\n\n" >&2
		exit 1
	fi
}

testFmValueIsNonNegativeInteger()
{
	if [[ -z $fm_value || ! $fm_value =~ ^(0|[1-9]+[0-9]*)$ ]]; then
		printf "${msg[ERR_FM_VALUE]}\n\n" >&2
		exit 1
	fi
	
	if ((${#fm_value} > 9)); then
		fm_value=${fm_value:0:9}
	fi
	
	# It should be more than enough.
	maxValue=200000000
	
	if ((fm_value > maxValue)); then
		fm_value=$maxValue
	fi
}

testIsNotFileDot()
{
	# Theoretically, SpaceFM won't pass files dot or dot-dot as arguments,
	# but just in case, we explicitly forbid it because it could have important
	# consequences. Also, see this extract from "man 1posix rm":
	#
	#	"If either of the files dot or dot-dot are specified as the basename
	#	portion of an operand (that is, the final pathname component), rm shall
	#	write a diagnostic message to standard error and do nothing more with
	#	such operands."
	if [[ ${file##*/} == . || ${file##*/} == .. ]]; then
		printf "${msg[ERR_FILE_DOT]}\n\n" "$file" >&2
		continue
	fi
}

testIsTrashed()
{
	if [[ $file != $trash/files/+([^/]) ]]; then
		printf "${msg[ERR_NOT_IN_TRASH]}\n\n" "$file" >&2
		continue
	fi
}

testTrashinfoFileExists()
{
	# From the specification: "If an info file corresponding to a file/directory
	# in $trash/files is not available, this is an emergency case, and MUST be
	# clearly presented as such to the user or to the system administrator".
	if [[ ! -e $trashinfoFilePath ]]; then
		printf "${msg[ERR_NO_TRASHINFO]}\n\n" "$file" >&2
		continue
	fi
}

