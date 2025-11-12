#!/bin/bash

# --- 1. Configuration des Extensions Temporaires ---
echo "--- Nettoyeur de Fichiers Temporaires ---"
echo "Recherche des extensions : .tmp, .bak, .log"

# --- 2. Demander le répertoire à analyser ---
read -p "Entrez le chemin du répertoire à nettoyer : " REPERTOIRE

# Vérifier si le répertoire existe
if [[ ! -d "$REPERTOIRE" ]]; then
    echo "ERREUR : Le chemin '$REPERTOIRE' n'est pas un répertoire valide ou n'existe pas."
    exit 1
fi

echo "Analyse en cours dans : $REPERTOIRE"
echo "------------------------------------------------"

# --- 3. Trouver et Lister les Fichiers --

echo "Fichiers potentiels à supprimer :"

# Stocker les résultats de find dans une variable pour les lister et les manipuler ensuite
FICHIERS_A_SUPPRIMER=$(find "$REPERTOIRE" -type f \( -name "*.tmp" -o -name "*.bak" -o -name "*.log" \))

if [[ -z "$FICHIERS_A_SUPPRIMER" ]]; then
    echo "✅ Aucun fichier temporaire trouvé dans '$REPERTOIRE'."
    exit 0
fi

echo "$FICHIERS_A_SUPPRIMER"
echo "------------------------------------------------"

# --- 4. Demander confirmation avant suppression ---
read -p "Voulez-vous VRAIMENT supprimer ces fichiers ? (o/N) : " CONFIRMATION

if [[ "$CONFIRMATION" == "o" || "$CONFIRMATION" == "O" ]]; then
    
    echo "Suppression en cours..."
    

   find "$REPERTOIRE" -type f \( -name "*.tmp" -o -name "*.bak" -o -name "*.log" \) -delete
    
    # Vérification du code de sortie pour le succès
    if [ $? -eq 0 ]; then
        echo "✅ Suppression terminée avec succès."
    else
        echo "❌ ERREUR lors de la suppression (vérifiez les permissions)."
    fi
    
else
    echo "Opération annulée par l'utilisateur."
    exit 1
fi
