
#!/bin/bash


# --- 1. Configuration et Variables ---
NUMERO_ACTUEL=1

echo "--- Outil de Renommage de Fichiers en Lot ---"

# --- 2. Demander les paramètres ---
read -p "Entrez le chemin du répertoire à traiter : " REPERTOIRE
if [[ ! -d "$REPERTOIRE" ]]; then
    echo "ERREUR : Le chemin '$REPERTOIRE' n'est pas un répertoire valide."
    exit 1
fi

read -p "Entrez le nouveau préfixe (ex: Rapport_) : " PREFIXE
read -p "Entrez le nombre de chiffres pour la séquence (ex: 3 pour 001) : " PADDING

# Vérification simple du padding
if ! [[ "$PADDING" =~ ^[1-9]$ ]]; then
    echo "ERREUR : Le nombre de chiffres doit être entre 1 et 9."
    exit 1
fi

echo ""
echo "Mode Simulation : Voici les renommages qui seront effectués (o/N) :"

# --- 3. Boucle et Logique de Renommage ---
# Utilisation d'un tableau pour stocker les noms de fichiers pour un traitement stable
FICHIERS=("$REPERTOIRE"/*)

for FICHIER_ORIGINAL in "${FICHIERS[@]}"; do
    
    # Vérifier si c'est un fichier régulier et non un répertoire
    if [[ -f "$FICHIER_ORIGINAL" ]]; then
        
        # 1. Extraire l'extension (avec la commande basename)
        # sed : prend l'extension à partir du dernier point
        EXTENSION=$(basename "$FICHIER_ORIGINAL" | sed 's/.*\.//')
        
        # 2. Créer le numéro séquentiel formaté
        # printf : outil clé pour formater la chaîne avec le padding
        NUM_FORMATTE=$(printf "%0*d" "$PADDING" "$NUMERO_ACTUEL")
        
        # 3. Construire le nouveau nom de fichier
        NOUVEAU_NOM="${PREFIXE}${NUM_FORMATTE}.${EXTENSION}"
        CHEMIN_NOUVEAU="${REPERTOIRE}/${NOUVEAU_NOM}"
        
        echo "[  PREVIEW ] $FICHIER_ORIGINAL -> $NOUVEAU_NOM"
        
        # Stocker les actions de renommage dans un tableau pour exécution future
        RENOMMAGES+=("$FICHIER_ORIGINAL:$CHEMIN_NOUVEAU")
        
        NUMERO_ACTUEL=$((NUMERO_ACTUEL + 1))
    fi
done

# --- 4. Confirmation et Exécution Réelle ---

if [[ ${#RENOMMAGES[@]} -eq 0 ]]; then
    echo "Aucun fichier trouvé pour le renommage."
    exit 0
fi

read -p "Confirmez-vous le renommage de ${#RENOMMAGES[@]} fichiers ? (o/N) : " CONFIRMATION

if [[ "$CONFIRMATION" =~ ^[oO]$ ]]; then
    echo ""
    echo "--- Exécution du Renommage ---"
    for ACTION in "${RENOMMAGES[@]}"; do
        # Utiliser IFS pour séparer l'ancien et le nouveau nom
        ANCIEN=$(echo "$ACTION" | cut -d ':' -f 1)
        NOUVEAU=$(echo "$ACTION" | cut -d ':' -f 2)
        
        # Renommer le fichier
        mv -i "$ANCIEN" "$NOUVEAU"
        echo "[ RENOMMÉ ] $(basename "$ANCIEN") -> $(basename "$NOUVEAU")"
    done
    echo "✅ Renommage terminé."
else
    echo "Opération annulée par l'utilisateur."
fi