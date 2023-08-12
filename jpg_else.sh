#!/bin/bash

# Vérifier que les deux arguments sont fournis
if [ $# -ne 2 ]; then
    echo "Usage: $0 <chemin_dossier_source> <chemin_dossier_destination>"
    exit 1
fi

chemin_dossier_source="$1"
chemin_dossier_destination="$2"

# Liste blanche des extensions d'images courantes
extensions_images=("jpg" "jpeg" "png" "gif" "bmp" "tiff" "raw")

# Vérifier si le dossier source existe
if [ ! -d "$chemin_dossier_source" ]; then
    echo "Le dossier source n'existe pas."
    exit 1
fi

# Vérifier si le dossier de destination existe
if [ ! -d "$chemin_dossier_destination" ]; then
    echo "Le dossier destination n'existe pas. Création en cours..."
    mkdir -p "$chemin_dossier_destination"
fi

# Fonction pour vérifier si un fichier est une image
est_image() {
    # Vérifier le type de fichier en utilisant la commande "file"
    type_fichier=$(file -b --mime-type "$1")

    # Vérifier si le type de fichier correspond à une extension d'image valide
    for ext in "${extensions_images[@]}"; do
        if [[ "$type_fichier" == *"$ext" ]]; then
            return 0
        fi
    done

    # Si le type de fichier ne correspond à aucune extension d'image valide, retourner 1
    return 1
}

# Fonction pour déplacer les fichiers non images vers le dossier de destination
deplacer_fichier_non_image() {
    fichier="$1"
    destination="$2"
    mv "$fichier" "$destination"
}

# Parcourir les fichiers du dossier source et ses sous-dossiers
while IFS= read -r -d '' fichier; do
    if est_image "$fichier"; then
        echo "$fichier est une image. Le laisser dans le dossier source."
    else
        echo "$fichier n'est pas une image. Le déplacer vers le dossier de destination."
        deplacer_fichier_non_image "$fichier" "$chemin_dossier_destination"
    fi
done < <(find "$chemin_dossier_source" -type f -print0)

echo "Tri des fichiers terminé !"

