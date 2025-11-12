#!/bin/bash
# Script de conversion CSV vers Tableau HTML

FICHIER_CSV=$1

echo "--- Convertisseur CSV vers HTML ---"

# --- 1. Vérification des Arguments ---
if [ -z "$FICHIER_CSV" ] || [ ! -f "$FICHIER_CSV" ]; then
    echo "ERREUR : Veuillez fournir un fichier CSV valide en argument."
    echo "Usage: $0 data.csv > rapport.html"
    exit 1
fi

# --- 2. Début du Fichier HTML ---
echo "<!DOCTYPE html>"
echo "<html>"
echo "<head><title>Rapport CSV</title>"
echo "<style>table, th, td { border: 1px solid black; border-collapse: collapse; padding: 8px; }</style>"
echo "</head>"
echo "<body>"
echo "<h1>Rapport généré à partir de $FICHIER_CSV</h1>"
echo "<table>"

# --- 3. La Logique AWK ---
# AWK est utilisé pour traiter le fichier ligne par ligne
# -F "," : Définit le séparateur de champ (Field Separator) comme la virgule.
# NR == 1 : Condition pour traiter la PREMIÈRE LIGNE (l'en-tête).
# else : Condition pour traiter TOUTES LES AUTRES LIGNES (les données).

awk -F "," -f corps.awk "$FICHIER_CSV"

# --- 4. Fin du Fichier HTML ---
echo "</table>"
echo "</body>"
echo "</html>"