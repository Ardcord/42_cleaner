#!/bin/bash

# Original script of ombhd
# Modified for 42 Linux by tvanbael

# Affichage du banner
clear
echo -e "\n"
echo -e "      █▀▀ █▀▀ █░░ █▀▀ ▄▀█ █▄░█"
echo -e "      █▄▄ █▄▄ █▄▄ ██▄ █▀█ █░▀█"
echo -e "\n"
sleep 2

# Help menu

if [ "$arg" == "-h" ] || [ "$arg" == "--help" ]; then
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

if [ "$arg" == "-o" ] || [ "$1" == "origin" ]; then
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
if [ "$arg" == "-u" ] || [ "$1" == "update" ]; then
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

function clean_glob {
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
    clean_glob "$HOME"/Library/*.42*
    clean_glob "$HOME"/*.42*
    clean_glob "$HOME"/.zcompdump*
    clean_glob "$HOME"/.cocoapods.42_cache_bak*

    # Corbeille
    clean_glob "$HOME"/.Trash/*

    # Caches généraux
    # Donnez des droits d'accès aux caches Homebrew, afin que le script puisse les supprimer
    chmod -R 777 "$HOME"/Library/Caches/Homebrew &>/dev/null
    clean_glob "$HOME"/Library/Caches/*
    clean_glob "$HOME"/Library/Application\ Support/Caches/*

    # Caches de Slack, VSCode, Discord et Chrome
    clean_glob "$HOME"/Library/Application\ Support/Slack/Service\ Worker/CacheStorage/*
    clean_glob "$HOME"/Library/Application\ Support/Slack/Cache/*
    clean_glob "$HOME"/Library/Application\ Support/discord/Cache/*
    clean_glob "$HOME"/Library/Application\ Support/discord/Code\ Cache/js*
    clean_glob "$HOME"/Library/Application\ Support/discord/Crashpad/completed/*
    clean_glob "$HOME"/Library/Application\ Support/Code/Cache/*
    clean_glob "$HOME"/Library/Application\ Support/Code/CachedData/*
    clean_glob "$HOME"/Library/Application\ Support/Code/Crashpad/completed/*
    clean_glob "$HOME"/Library/Application\ Support/Code/User/workspaceStorage/*
    clean_glob "$HOME"/Library/Application\ Support/Google/Chrome/Profile\ [0-9]/Service\ Worker/CacheStorage/*
    clean_glob "$HOME"/Library/Application\ Support/Google/Chrome/Default/Service\ Worker/CacheStorage/*
    clean_glob "$HOME"/Library/Application\ Support/Google/Chrome/Profile\ [0-9]/Application\ Cache/*
    clean_glob "$HOME"/Library/Application\ Support/Google/Chrome/Default/Application\ Cache/*
    clean_glob "$HOME"/Library/Application\ Support/Google/Chrome/Crashpad/completed/*

    # Fichiers .DS_Store
    find "$HOME"/Desktop -type f -name .DS_Store -exec /bin/rm -f {} \;

    # Fichiers temporaires téléchargés avec les navigateurs
    clean_glob "$HOME"/.mozilla/firefox/*/cache/*
    clean_glob "$HOME"/.vscode-server/bin/*/cache/*
    clean_glob "$HOME"/.vscode-server/extensions/*/cache/*

    # Fichiers liés à la piscine
    clean_glob "$HOME"/Desktop/Piscine\ Rules\ *.mp4
    clean_glob "$HOME"/Desktop/PLAY_ME.webloc
	clean_glob "$HOME"/.local/share/Trash/info/*
	clean_glob "$HOME"/.local/share/Trash/files/*


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
