# CCLEAN (Cleaner_42)

Ce script Bash vous permet de nettoyer divers fichiers et caches inutiles sur votre système Linux (Ubuntu) sans nécessiter de droits administrateurs. Il a été initialement développé par [ombhd](https://github.com/ombhd) et adapté pour Linux (Ubuntu) par [tvanbael](https://github.com/tvanbael).


## Fonctionnalités

- Nettoyage des caches 42
- Vidage de la corbeille
- Suppression des fichiers `.DS_Store`
- Nettoyage des caches de Slack, VSCode, Discord, Chrome, Mozilla, et d'autres applications
- Mise à jour du script
- Affichage de l'espace de stockage disponible avant et après le nettoyage


## Utilisation

1. Clonez ce référentiel :

   ```bash
   git clone https://github.com/Ardcord/42_cleaner.git
   ```

2. Allez dans le répertoire du script :

    ```bash
    cd 42_cleaner
    ```

3. Donnez la permission d'exécution au script :

    ```bash
    chmod +x Cleaner_42.sh
    ```

4. Exécutez le script :

    ```bash
    ./Cleaner_42.sh
    ```

Le script devrais vous crée automatiquement l'alias dans votre .zshrc
Dans le cas contraire vous pouvez aussi rajouter l'Alias a votre .zshrc avec cette commande :

   ```bash
   grep -q "alias cclean=\"zsh ~/Cleaner_42.sh\"" ~/.zshrc || echo "alias cclean=\"zsh ~/Cleaner_42.sh\"" >> ~/.zshrc
   ```
   

## Options

  - Utilisez l'option '-p' ou '--print' pour afficher les fichiers supprimés.

    ```bash
    ./Cleaner_42.sh -p
    ```

  - Utilisez l'option 'update' pour mettre à jour le script.

    ```bash
    ./Cleaner_42.sh update
    ```


## Restaurer la Version Originale

Si vous souhaitez restaurer la version originale du script de `ombhd`, vous pouvez utiliser l'option `-r` ou `--origin` :

   ```bash
   ./Cleaner_42.sh origin
   ```
Cela restaurera la version originale du script à partir du référentiel GitHub de ombhd et la copiera dans votre répertoire personnel.

Notez que cela écrasera les modifications locales que vous avez apportées au script. Si vous avez effectué des modifications personnelles, assurez-vous de les sauvegarder ailleurs avant d'utiliser cette option.

Si vous préférez, vous pouvez également accéder directement au profil GitHub de [ombhd](https://github.com/ombhd) pour obtenir la version originale.


## Avertissement

Ce script est destiné à être utilisé sur votre propre système et peut supprimer des fichiers de manière irréversible. Assurez-vous de comprendre ce que fait le script avant de l'exécuter.


**Auteur** : [ombhd](https://github.com/ombhd) (Auteur original)

Adapté pour Linux (Ubuntu) par : tvanbael
