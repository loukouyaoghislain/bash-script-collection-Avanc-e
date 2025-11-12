#!/bin/bash

# --- 1. Configuration et Variables ---
FICHIER_LOG=$1
MOTS_CLES=("ERROR" "FAIL" "REFUSED" "FATAL" "LOUKOU")
TOTAL_ERREURS=0

echo "--- Analyseur de Journal d'Erreurs ---"

# --- 2. Vérification des Arguments et du Fichier ---
if [ -z "$FICHIER_LOG" ]; then
    echo "ERREUR : Veuillez fournir le chemin du fichier journal en argument."
    echo "Usage: $0 /var/log/syslog"
    exit 1
fi

if [ ! -f "$FICHIER_LOG" ]; then
    echo "ERREUR : Le fichier journal '$FICHIER_LOG' n'existe pas ou n'est pas accessible."
    exit 1
fi

echo "Analyse du fichier : $FICHIER_LOG"
echo "Recherche des mots-clés : ${MOTS_CLES[*]}"
echo "--------------------------------------------------------"

# --- 3. Fonction d'Analyse ---
analyse_log() {
    local MOT_CLE=$1
    
    # Compter les occurrences du mot-clé (ignoré la casse : -i)
    # wc -l compte le nombre de lignes retournées par grep
    NB_OCCURRENCES=$(grep -i -c "$MOT_CLE" "$FICHIER_LOG")
    
    if [ "$NB_OCCURRENCES" -gt 0 ]; then
        echo " [ERREUR: $MOT_CLE] : $NB_OCCURRENCES occurrences."
    fi
    
    # Ajouter au total général
    TOTAL_ERREURS=$((TOTAL_ERREURS + $NB_OCCURRENCES))
}

# --- 4. Boucle Principale ---
for CLE in "${MOTS_CLES[@]}"; do
    analyse_log "$CLE"
done

# --- 5. Rapport Final ---

echo "--------------------------------------------------------"
echo "Synthèse de l'Analyse :"

if [ "$TOTAL_ERREURS" -eq 0 ]; then
    echo "✅ Aucun mot-clé d'erreur critique trouvé."
else
    echo "⚠️ ALERTE : Total des lignes d'erreurs/échecs trouvées : $TOTAL_ERREURS"
    echo ""
    
    # Optionnel : Afficher les 10 dernières erreurs (avec grep)
    read -r -p "voulez voir les erreurs: (o/n): " VOLONTE
    echo ""

    if [[ "$VOLONTE" =~ ^[oO] ]];then
        grep -i -E "$(IFS="|"; echo "${MOTS_CLES[*]}")" "$FICHIER_LOG" | tail -n 10
    else
        exit 1
    fi
  
fi