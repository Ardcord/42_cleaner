#!/bin/bash

# Original script of ombhd
# Modified for 42 Linux by tvanbael

# Affichage du banner
clear
echo -e "\n"
echo -e "      █▀▀ █▀▀ █░░ █▀▀ ▄▀█ █▄░█"
echo -e "      █▄▄ █▄▄ █▄▄ ██▄ █▀█ █░▀█"
echo -e "	      Linux by Tvanbael\n"
sleep 2

# Fonction pour vérifier et ajouter l'alias dans un fichier de configuration
check_and_add_alias() {
    local config_file="$1"
    local alias_line="alias cclean='zsh ~/Cleaner_42.sh'"
    local alias_nomad="alias cclean='bash -c "$(curl -fsSL https://raw.githubusercontent.com/Ardcord/42_cleaner/main/Cleaner_42.sh)"'"

    # Vérifier si le fichier de configuration existe
    if [ -f "$config_file" ]; then
        # Vérifier si l'alias existe dans le fichier
        if grep -q "$alias_line" "$config_file"; then
            echo ""
	elif grep -q "$alias_nonad" "$config_file"; then
 	    echo""
        else
            # Ajouter l'alias à la fin du fichier
            echo "" >> "$config_file"
            echo "" >> "$config_file"
            echo "# ███╗   ███╗███████╗███████╗     █████╗ ██╗     ██╗ █████╗ ███████╗" >> "$config_file"
            echo "# ████╗ ████║██╔════╝██╔════╝    ██╔══██╗██║     ██║██╔══██╗██╔════╝" >> "$config_file"
            echo "# ██╔████╔██║█████╗  ███████╗    ███████║██║     ██║███████║███████╗" >> "$config_file"
            echo "# ██║╚██╔╝██║██╔══╝  ╚════██║    ██╔══██║██║     ██║██╔══██║╚════██║" >> "$config_file"
            echo "# ██║ ╚═╝ ██║███████╗███████║    ██║  ██║███████╗██║██║  ██║███████║" >> "$config_file"
            echo "# ╚═╝     ╚═╝╚══════╝╚══════╝    ╚═╝  ╚═╝╚══════╝╚═╝╚═╝  ╚═╝╚══════╝" >> "$config_file"
            echo "####################################################################" >> "$config_file"
            echo "" >> "$config_file"
            echo "$alias_line" >> "$config_file"
            echo -e "\033[32mAlias created successfully \xE2\x9C\x85\033[0m"
        fi
    fi
}

# Appeler la fonction pour différents fichiers de configuration
check_and_add_alias "$HOME/.zshrc"
check_and_add_alias "$HOME/.bashrc"
# Ajoutez d'autres fichiers de configuration si nécessaire


# Help menu

if [ "$arg" == "-h" ] || [ "$arg" == "help" ] || [ "$arg" == "--help" ]; then
    echo -e "\nUsage: ./Cleaner_42.sh [options]\n"
    echo "Options:"
    echo "  -h, --help    Affiche ce message d'aide"
    echo "  -o, --origin  Restaure la version originale de CCLEAN depuis le GitHub [OMBHD]"
    echo "  -p, --print   Affiche les fichiers supprimés pendant le nettoyage"
    echo "  -u, --update  Met à jour CCLEAN vers la dernière version depuis GitHub"
    echo -e "\nExemples:"
    echo "./Cleaner_42.sh -p     # Exécute CCLEAN en affichant les fichiers supprimés"
    echo "./Cleaner_42.sh -o     # Restaure la version originale de CCLEAN depuis GitHub"
    echo "./Cleaner_42.sh -u     # Met à jour CCLEAN vers la dernière version depuis le GitHub [OMBHD]"
    exit 0
fi


# Restauration de la version originale

if [ "$arg" == "-o" ] || [ "$1" == "origin" ] || [ "$1" == "--origin" ]; then
    # Restauration de la version originale
    tmp_dir=".cclean_tmp_dir"
	if ! git clone --quiet https://github.com/ombhd/Cleaner_42.git "$HOME"/"$tmp_dir" &>/dev/null; then
        sleep 0.5
        echo -e "\033[31m\n -- Impossible de restaurer la version OMBHD CCLEAN ! :( --\033[0m"
        echo -e "\033[33m\n -- Rendez vous directement sur son github --\n\033[0m"
		echo -e "\033[33m\n --   -->  https://github.com/ombhd/  <--  --\n\033[0m"
        exit 1
    fi
	sleep 1
	cp -f "$HOME"/"$tmp_dir"/Cleaner_42.sh "$HOME" &>/dev/null
    /bin/rm -rf "$HOME"/"${tmp_dir:?}" &>/dev/null

    echo -e "\033[33m\n -- Version originale restaurée --\n\033[0m"
    exit 0
fi

# Mise à jour
if [ "$arg" == "-u" ] || [ "$1" == "update" ] || [ "$1" == "--update" ]; then
    tmp_dir=".cclean_tmp_dir"
    if ! git clone --quiet https://github.com/Ardcord/42_cleaner.git "$HOME"/"$tmp_dir" &>/dev/null; then
        sleep 0.5
        echo -e "\033[31m\n -- Impossible de mettre à jour CCLEAN ! :( --\033[0m"
        echo -e "\033[33m\n -- Peut-être devez-vous changer vos mauvaises habitudes XD --\n\033[0m"
        exit 1
    fi
    sleep 1
    if [ "" == "$(diff "$HOME"/Cleaner_42.sh "$HOME"/"$tmp_dir"/Cleaner_42.sh)" ]; then
        echo -e "\033[33m\n -- Vous avez déjà la dernière version de CCLEAN --\n\033[0m"
        /bin/rm -rf "$HOME"/"${tmp_dir:?}"
        exit 0
    fi
    cp -f "$HOME"/"$tmp_dir"/Cleaner_42.sh "$HOME" &>/dev/null
    /bin/rm -rf "$HOME"/"${tmp_dir:?}" &>/dev/null
    echo -e "\033[33m\n -- CCLEAN a été mis à jour avec succès --\n\033[0m"
    exit 0
fi

# Calcul de l'espace de stockage disponible actuel
Storage=$(du -sh "$HOME" | awk '{print $1}')
if [ "$Storage" == "0B" ]; then
    Storage="0"
fi
echo -e "\033[33m\n -- Espace de stockage disponible avant le nettoyage : || $Storage || --\033[0m"

echo -e "\033[31m\n -- Nettoyage en cours...\n\033[0m "

should_log=0
if [[ "$1" == "-p" || "$1" == "--print" ]]; then
    should_log=1
fi

function rm -rf {
    # Ne faites rien si le nombre d'arguments est zéro (glob non trouvé).
    if [ -z "$1" ]; then
        return 0
    fi

    if [ $should_log -eq 1 ]; then
        for arg in "$@"; do
            du -sh "$arg" 2>/dev/null
        done
    fi

    /bin/rm -rf "$@" &>/dev/null

    return 0
}

function clean {
    # Pour éviter d'afficher des lignes vides
    # ou d'appeler inutilement /bin/rm,
    # nous résolvons les globs non trouvés comme des chaînes vides.
    shopt -s nullglob

    echo -ne "\033[38;5;208m"

    # Caches 42
    rm -rf "$HOME"/Library/*.42*
    rm -rf "$HOME"/*.42*
    rm -rf "$HOME"/.zcompdump*
    rm -rf "$HOME"/.cocoapods.42_cache_bak*

    # Corbeille
    rm -rf "$HOME"/.Trash/
    rm -rf "$HOME"/.local/share/Trash/info/
    rm -rf "$HOME"/.local/share/Trash/files/*

    # Caches généraux
    # Donnez des droits d'accès aux caches Homebrew, afin que le script puisse les supprimer
    chmod -R 777 "$HOME"/Library/Caches/Homebrew &>/dev/null
    rm -rf "$HOME"/Library/Caches/*
    rm -rf "$HOME"/Library/Application\ Support/Caches/*

    # Caches de Slack, VSCode, Discord et Chrome
    rm -rf "$HOME"/Library/Application\ Support/Slack/Service\ Worker/CacheStorage/*
    rm -rf "$HOME"/Library/Application\ Support/Slack/Cache/*
    rm -rf "$HOME"/Library/Application\ Support/discord/Cache/*
    rm -rf "$HOME"/Library/Application\ Support/discord/Code\ Cache/js*
    rm -rf "$HOME"/Library/Application\ Support/discord/Crashpad/completed/*
    rm -rf "$HOME"/Library/Application\ Support/Code/Cache/*
    rm -rf "$HOME"/Library/Application\ Support/Code/CachedData/*
    rm -rf "$HOME"/Library/Application\ Support/Code/Crashpad/completed/*
    rm -rf "$HOME"/Library/Application\ Support/Code/User/workspaceStorage/*
    rm -rf "$HOME"/Library/Application\ Support/Google/Chrome/Profile\ [0-9]/Service\ Worker/CacheStorage/*
    rm -rf "$HOME"/Library/Application\ Support/Google/Chrome/Default/Service\ Worker/CacheStorage/*
    rm -rf "$HOME"/Library/Application\ Support/Google/Chrome/Profile\ [0-9]/Application\ Cache/*
    rm -rf "$HOME"/Library/Application\ Support/Google/Chrome/Default/Application\ Cache/*
    rm -rf "$HOME"/Library/Application\ Support/Google/Chrome/Crashpad/completed/*

    # Fichiers .DS_Store
    find "$HOME"/Desktop -type f -name .DS_Store -exec /bin/rm -f {} \;

    # Fichiers temporaires téléchargés avec les navigateurs
    rm -rf "$HOME"/.mozilla/firefox/*/cache/*
    rm -rf "$HOME"/.vscode-server/bin/*/cache/*
    rm -rf "$HOME"/.vscode-server/extensions/*/cache/*

    # Fichiers liés à la piscine
    rm -rf "$HOME"/Desktop/Piscine\ Rules\ *.mp4
    rm -rf "$HOME"/Desktop/PLAY_ME.webloc

    echo -ne "\033[0m"
}
clean

if [ $should_log -eq 1 ]; then
    echo
fi

# Calcul de l'espace de stockage disponible après le nettoyage
Storage=$(du -sh "$HOME" | awk '{print $1}')
if [ "$Storage" == "0B" ]; then
    Storage="0"
fi
sleep 1
echo -e "\033[32m -- Espace de stockage disponible après le nettoyage : || $Storage || --\n\033[0m"
