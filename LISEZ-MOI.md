## Aperçu

Corbeille-SpaceFM est une extension ajoutant le support de la corbeille au gestionnaire de fichiers [SpaceFM](https://ignorantguru.github.io/spacefm/).

Corbeille-SpaceFM est conforme à la [spécification de freedesktop.org relative à la corbeille](https://specifications.freedesktop.org/trash-spec/latest/), et est donc interopérable avec d'autres implémentations conformes, qui pourront gérer les fichiers mis à la corbeille par Corbeille-SpaceFM, et vice versa. Des essais ont été effectués avec Thunar, Nautilus et Dolphin.

Corbeille-SpaceFM gère sans problème les noms de fichiers formés de n'importe quel caractère valide, par exemple des retours à la ligne.

Aussi, une attention particulière a été portée à la vitesse d'exécution. Corbeille-SpaceFM supporte les processeurs multicoeurs et peut manipuler des centaines ou des milliers de fichiers sans souffrir d'un ralentissement trop important. Voir la section *Précisions* ci-dessous pour des tests de performance.

## Dépendances

Un effort a été déployé pour requérir un minimum de dépendances. Corbeille-SpaceFM est écrit en Bash et fait seulement appel à quelques commandes externes provenant toutes du paquet `coreutils` (`ls`, `mv`, `rm`...); il devrait donc fonctionner pour tout le monde sans installation supplémentaire.

## Installation

L'extension est disponible dans quelques langues:

- [anglais](https://raw.githubusercontent.com/jpfleury/corbeille-spacefm/master/assets/Corbeille-en-source.spacefm-plugin.tar.gz)

- [français](https://raw.githubusercontent.com/jpfleury/corbeille-spacefm/master/assets/Corbeille-fr-source.spacefm-plugin.tar.gz)

- [suédois](https://raw.githubusercontent.com/jpfleury/corbeille-spacefm/master/assets/Corbeille-sv-source.spacefm-plugin.tar.gz)

L'archive téléchargée peut être directement utilisée par SpaceFM pour procéder à l'installation. La marche à suivre pour installer une extension dans SpaceFM est décrite dans le manuel du logiciel. En gros, il y a deux possibilités:

- [Installer une extension.](https://ignorantguru.github.io/spacefm/spacefm-manual-en.html#plugins-install) Les fichiers de l'extension sont protégés contre une modification inopportune puisqu'ils appartiennent au superutilisateur (le mot de passe du superutilisateur est nécessaire lors de l'installation), et l'extension est disponible pour tous les utilisateurs dans le menu *Plugins* de SpaceFM.

- [Copier une extension.](https://ignorantguru.github.io/spacefm/spacefm-manual-en.html#plugins-copy). Une fois copiée, l'extension peut être collée dans n'importe quel menu (aucun mot de passe superutilisateur requis)

### À partir du code source

Une archive de Corbeille-SpaceFM peut être construite à partir du code source:

- [Télécharger le code source.](https://github.com/jpfleury/corbeille-spacefm/archive/master.zip)

- Extraire l'archive.

- Ouvrir une console dans le dossier extrait.

- Dans la console, lancer la commande suivante:

		./script.sh archive $LANGUE

Les valeurs possibles pour `$LANGUE` sont `en` (anglais), `fr` (français) et `sv` (suédois). Une archive sera créée à la racine du dossier. Elle peut être directement utilisée par SpaceFM pour procéder à l'installation.

## Désinstallation

Voir les instructions pour [désinstaller une extension](https://ignorantguru.github.io/spacefm/spacefm-manual-en.html#plugins-uninstall) dans le manuel de SpaceFM.

## Utilisation

Corbeille-SpaceFM correspond à un ensemble de 9 commandes (disponibles dans le menu *Plugins | Corbeille* de SpaceFM si l'installation a été effectuée avec les droits d'administration). Prendre note qu'**il n'y a pas de fenêtre de confirmation** après qu'une commande est sélectionnée.

- *Mettre à la corbeille*: au moins un fichier en dehors de la corbeille doit être sélectionné pour que cette commande soit active. Les fichiers sélectionnés seront déplacés vers la corbeille.

	Suggestion: il peut être pratique de créer le raccourci clavier *Maj+Suppr* pour cette commande.

- *Restaurer*: au moins un fichier dans la corbeille doit être sélectionné pour que cette commande soit active. Les fichiers sélectionnés seront déplacés vers leur emplacement original. Si un fichier existe déjà à cet emplacement, aucun déplacement n'aura lieu et un message d'erreur sera affiché.

- *Supprimer définitivement*: au moins un fichier dans la corbeille doit être sélectionné pour que cette commande soit active. Les fichiers sélectionnés seront supprimés définitivement, donc ils ne pourront plus être restaurés à partir de la corbeille.

- *Aller à la corbeille*: cette commande est toujours active. Le dossier de la corbeille sera ouvert dans un nouvel onglet dans la fenêtre actuelle de SpaceFM. Aussi, si des corbeilles racine sont trouvées (par exemple, une corbeille à la racine d'un support amovible), elles seront ouvertes chacune dans un nouvel onglet.

- *Afficher les propriétés*: cette commande est toujours active. Une boîte de dialogue affichera le nombre de fichiers mis dans la corbeille ainsi que la taille totale de la corbeille.

- *Vider la corbeille*: cette commande est toujours active. Il s'agit d'un raccourci pour supprimer définitivement tous les fichiers de la corbeille. Le même résultat peut être obtenu en sélectionnant tous les fichiers de la corbeille et en choisissant de les supprimer définitivement.

- *Limiter la taille de la corbeille*: cette commande est toujours active. Elle permet de réduire la corbeille à une taille donnée. Les fichiers sont supprimés en ordre croissant de date de mise à la corbeille (les fichiers mis à la corbeille depuis le plus longtemps sont supprimés en premier).

- *Supprimer les anciens fichiers*: cette commande est toujours active. Elle permet de supprimer les fichiers mis à la corbeille depuis un nombre de jours donné.

- *Supprimer les fichiers volumineux*: cette commande est toujours active. Elle permet de supprimer les fichiers mis à la corbeille et dont la taille est supérieure ou égale à une taille donnée.

## Précisions

### Vitesse

Corbeille-SpaceFM a été pensé pour être rapide, même lorsque qu'un nombre important de fichiers doivent être manipulés. Les processeurs multicoeurs sont supportés, les commandes intégrées de Bash ont été privilégiées autant que possible et le nombre de sous-processus à l'intérieur de boucles a été réduit au minimum.

Des tests de performance ont été effectués pour comparer Corbeille-SpaceFM avec Thunar, le gestionnaire de fichiers par défaut de Xfce (Thunar a été choisi, car Xfce est le gestionnaire de bureau que j'utilise). Chaque commande du test manipulait 1000 fichiers texte et a été lancée 5 fois. Les résultats correspondent au temps moyen en secondes.

Le premier test a été effectué sur un portable ayant un processeur Intel Core 2 Duo T9300 et 4 Gio de mémoire vive. SpaceFM 0.7.3 et Thunar 1.2.3 ont été utilisés sous Xubuntu 11.10. Les résultats sont les suivants:

|                              | Corbeille-SpaceFM | Thunar |
| ---------------------------- | ----------------- | ------ |
| **Mettre à la corbeille**    | 3                 | 12     |
| **Supprimer définitivement** | 3                 | 12     |
| **Restaurer**                | 4                 | 15     |
| **Vider la corbeille**       | 1                 | 1      |

Le deuxième test a été effectué sur un miniportable ayant un processeur Intel Atom N450 et 2 Gio de mémoire vive. SpaceFM 0.7.3 et Thunar 1.2.3 ont été utilisés sous Ubuntu 11.10. Les résultats sont les suivants:

|                              | Corbeille-SpaceFM | Thunar |
| ---------------------------- | ----------------- | ------ |
| **Mettre à la corbeille**    | 15                | 41     |
| **Supprimer définitivement** | 14                | 44     |
| **Restaurer**                | 19                | 50     |
| **Vider la corbeille**       | 10                | 6      |

### Symboles utilisés pour la taille des fichiers

Pour la taille des fichiers, Corbeille-SpaceFM utilise la signification habituelle du [préfixe binaire](https://fr.wikipedia.org/wiki/Pr%C3%A9fixe_binaire), c'est-à-dire la puissance de 2, mais avec les nouveaux termes proposés pour différentier sans équivoque les préfixes binaires des préfixes du système international (en puissance de 10). Par exemple, Mio est utilisé pour 1024 Kio, et 1 Kio équivaut à 1024 octets.

### Fichiers pouvant être mis à la corbeille

Les fichiers présents sur la même partition que la corbeille de bureau sont déplacés vers cette corbeille, c'est-à-dire `$XDG_DATA_HOME/Trash`. La plupart du temps, cela signifie déplacer les fichiers vers `/home/user/.local/share/Trash/files`.

Les fichiers sur d'autres partitions ne sont pas gérés par Corbeille-SpaceFM, comme permis par la spécification. Les raisons sont qu'un tel système est complexe et, à mon humble avis, pas très ergonomique.

Selon la spécification, les fichiers d'autres partitions peuvent être mis à la corbeille de bureau. Cependant, tenons compte de ces situations:

- Déplacer des fichiers externes vers la corbeille de bureau résulterait en une copie de ces fichiers à partir de leur emplacement original vers la partition de la corbeille de bureau. Cette situation pourrait convenir pour quelques fichiers sur un support amovible en USB 2.0, mais pas nécessairement pour la mise à la corbeille de 50 Gio de données, ou de fichiers distants ou présents sur des périphériques lents.

	La spécification permet de faire l'usage d'exceptions, par exemple de désactiver la mise à la corbeille de fichiers distants. Cependant, cela ne permet pas vraiment de résoudre le problème, et je crois que le déplacement de fichiers d'une partition vers une autre devrait être le fait d'une action explicite entreprise par l'utilisateur.

- Les supports amovibles sont parfois montés chaque fois avec un nouveau nom. Ainsi, un fichier mis à la corbeille à un moment donné peut ne pas être restauré si le périphérique a été démonté et remonté depuis.

- Un fichier mis à la corbeille à partir d'un support amovible ne pourra pas être restauré si le périphérique en question n'est pas monté.

Une implémentation peut supporter plutôt la mise à la corbeille dans des dossiers racine, c'est-à-dire à la racine d'un système de fichiers monté. Cependant, prenons en compte ce qui suit:

- Deux emplacements sont possibles, `$topdir/.Trash/$uid` et `$topdir/.Trash-$uid`, donc deux emplacements doivent être vérifiés, avec le risque de se retrouver avec deux corbeilles non vides sur le même périphérique pour le même utilisateur.

- Plusieurs situations sont épineuses: systèmes de fichiers sans support du bit collant, sans identifiant utilisateur numérique ou tout simplement sans identifiant utilisateur, sans permissions, etc. S'il y a trop d'exceptions, est-ce encore utile?

- Il est possible d'utiliser un support amovible sous plusieurs systèmes avec différents identifiants utilisateur, donc chaque fois avec un dossier de corbeille différent. Dans ces conditions, nos propres fichiers mis précédemment à la corbeille ne nous sont pas accessibles (sauf à avoir les droits d'administration).

Aussi, j'ai consulté plusieurs rapports de bogue sur Launchpad au sujet de la mise à la corbeille. J'ai trouvé plusieurs situations intéressantes:

- Les fichiers mis à la corbeille sont situés dans un dossier caché, donc ils ne sont pas affichés par défaut dans la plupart des gestionnaires de fichiers. Il y a des rapports de bogue au sujet d'utilisateurs ayant partagé leur périphérique sans savoir que les fichiers supprimés se trouvaient dans un dossier caché. Ceux avec qui le périphérique avait été partagé pouvaient avoir accès à la corbeille, surtout en prenant en compte le fait que cette dernière ne constitue pas un dossier caché sous Windows.

- Il y a des rapports de bogue à propos d'utilisateurs incapables d'ajouter des fichiers sur leur périphérique alors qu'ils ont supprimé des données. Ils ne s'étaient pas rendu compte qu'une corbeille cachée était présente sur leur périphérique et prenait encore de la place.

- Il y a des rapports de bogue à propos du fait que des dossiers cachés de corbeille sont créés automatiquement sans jamais être supprimés, même lorsqu'ils sont vides.

- Il y a des rapports demandant l'ajout d'une option pour désactiver la mise à la corbeille dans les dossiers racine.

Voir par exemple ce vieux rapport (datant de 2005), [Shouldn't put .Trash-$USER on removable devices](https://bugs.launchpad.net/ubuntu/+source/nautilus/+bug/12893), ayant 13 doublons et 104 commentaires, ou cet autre rapport (2004), [Ask to empty when unmounting media with items in trash](https://bugzilla.gnome.org/show_bug.cgi?id=138058), ayant 12 doublons et 44 commentaires. Les deux sont marqués comme étant résolus, mais en réalité ce n'est pas le cas. Nous pouvons noter de la confusion de la part des utilisateurs ainsi que des implémentations pas très claires (ou bien est-ce la spécification qui n'est pas assez claire).

Personnellement, j'ajouterais que certains gestionnaires de fichiers affichent les fichiers des corbeilles racine directement dans la corbeille de bureau, et ce sans différentier ces fichiers de ceux locaux. Un utilisateur peut donc vider la corbeille de bureau sans se rendre compte qu'il vide également toutes les corbeilles situées sur d'autres partitions. Un utilisateur peut vouloir vider une corbeille racine sans vider la corbeille de bureau, toutefois sans trouver de moyen d'accomplir une telle action. Un utilisateur risque de penser que tous les fichiers listés dans la corbeille de bureau sont (en toute logique) situés sur la partition utilisateur, mais, après avoir démonté son support amovible (et potentiellement après l'avoir partagé), réaliser que certains fichiers mis à la corbeille ne sont plus accessibles (ou, autrement dit, que le périphérique contient encore les fichiers mis à la corbeille). Tout ceci est plutôt source de confusion.

Je crois vraiment que le meilleur moyen de gérer la mise à la corbeille de fichiers situés sur une partition différente de celle de la corbeille de bureau est de laisser l'utilisateur gérer le cas manuellement. Par exemple, il est possible de déplacer manuellement les fichiers vers la partition utilisateur pour ensuite les mettre à la corbeille de bureau.

Cependant, prendre note que la commande *Aller à la corbeille* de Corbeille-SpaceFM affiche, s'il y a lieu, les corbeilles racine, puisqu'il est écrit dans la spécification:

> If an implementation does NOT provide such trashing, and does provide the user
> with some interface to view and/or undelete trashed files, it SHOULD make a
> “best effort” to show files trashed in top directories (by both methods) to
> the user, among other trashed files or in a clearly accessible separate way.

## Traduction

Corbeille-SpaceFM peut être traduit:

- Cliquer droit sur une des commandes de Corbeille-SpaceFM et sélectionner *Command | Browse | Files*. Ouvrir le fichier `init.inc.sh`, situé à la racine du dossier. Les phrases à traduire se trouvent dans les sections *Localization, 1 of 2* et *Localization, 2 of 2*.

- Cliquer droit sur une des commandes de Corbeille-SpaceFM et sélectionner *Command | Browse | Plugin*. Ouvrir le fichier `plugin`, situé à la racine du dossier. Les phrases à traduire se présentent sous la forme suivante:

		cstm_00000000-label=Phrase à traduire
		cstm_00000000-desc=Phrase à traduire

Toute personne intéressée à effectuer une traduction peut donc traduire les phrases et m'envoyer le résultat.

## Développement

Le logiciel Git est utilisé pour la gestion de versions. [Le dépôt peut être consulté en ligne ou récupéré en local.](https://github.com/jpfleury/corbeille-spacefm)

## Licence

Auteur: Jean-Philippe Fleury (<https://github.com/jpfleury>)  
Copyright © Jean-Philippe Fleury, 2012.

Ce programme est un logiciel libre; vous pouvez le redistribuer ou le
modifier suivant les termes de la GNU General Public License telle que
publiée par la Free Software Foundation: soit la version 3 de cette
licence, soit (à votre gré) toute version ultérieure.

Ce programme est distribué dans l'espoir qu'il vous sera utile, mais SANS
AUCUNE GARANTIE: sans même la garantie implicite de COMMERCIALISABILITÉ
ni d'ADÉQUATION À UN OBJECTIF PARTICULIER. Consultez la Licence publique
générale GNU pour plus de détails.

Vous devriez avoir reçu une copie de la Licence publique générale GNU avec
ce programme; si ce n'est pas le cas, consultez
<http://www.gnu.org/licenses/>.
