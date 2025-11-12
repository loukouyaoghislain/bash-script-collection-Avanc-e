#!/bin/bash

# --- 1. Définir l'extension à chercher ---
EXTENSION+=("$2")
REPERTOIRE="$1"
FICHIERS_TROUVES=0
LIGNES_TOTALES=0

#echo "Recherche des fichiers *.$EXTENSION"


# --- 2. Demander le répertoire à analyser ---
#read -p "Entrez le chemin du répertoire à analyser (ex: . ou /home/user/scripts) : " REPERTOIRE
echo "NOTCE D'UTILISATION DU SCRIPT : 
      le script prend deux argument :
                                    1er:le repertoire ou se trouve les scripts/veuillez entrer le chemin 
                                    absolut
                                    2eme :les extensions voulues (ex: " py sh bash js ")
"

# Vérifier si le répertoire existe et est un répertoire
if [[ ! -d "$REPERTOIRE" ]]; then
    echo "ERREUR : Le chemin '$REPERTOIRE' n'est pas un répertoire valide ou n'existe pas."
    exit 1
fi

if (( ${#EXTENSION[@]} == 0 )); then
    echo "aucune extensiion entree"
    exit 1
fi

echo "Analyse en cours dans : $REPERTOIRE"

# --- 3. Boucle et Comptage ---
# Utilisation de find pour chercher tous les fichiers correspondants de manière récursive
# Le while read lit la sortie de find ligne par ligne.

for extension in ${EXTENSION[@]};do
    while read -r FICHIER; do
      
       FICHIERS=$(basename +"$FICHIER")
        LIGNES_FICHIER=$(wc -l < "$FICHIER")
        LIGNES_TOTALES=$(($LIGNES_TOTALES + LIGNES_FICHIER))
        FICHIERS_TROUVES=$(($FICHIERS_TROUVES + 1))
        echo "  -> $FICHIERS : $LIGNES_FICHIER lignes"
        
    done < <(find "$REPERTOIRE" -type f -name "*.$extension") 
done

echo "============================================"

if (( FICHIERS_TROUVES > 0 )); then
    echo " Résultat de l'analyse :"
    echo "Nombre de fichiers *.$EXTENSION trouvés : $FICHIERS_TROUVES"
    echo "Total des lignes de code : $LIGNES_TOTALES"
else
    echo " Aucun fichier *.$EXTENSION trouvé dans '$REPERTOIRE'."
fi
echo "$fichierexiste"
echo "============================================"