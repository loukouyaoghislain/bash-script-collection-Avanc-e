#!/bin/bash
# Script de Reconnaissance Automatisée Simple

# --- 1. Définition des Variables et Configuration ---
CIBLE=$1
DATE_RAPPORT=$(date +"%Y%m%d_%H%M%S")
REPERTOIRE_RAPPORT=""

# Vérifier si les outils sont installés
command -v nmap >/dev/null 2>&1 || { echo >&2 "ERREUR: nmap n'est pas installé. Installation requise."; exit 1; }
command -v whois >/dev/null 2>&1 || { echo >&2 "ERREUR: whois n'est pas installé. Installation requise."; exit 1; }

echo "--- Outil de Reconnaissance (RECON) ---"

# ===============================================
# Fonctions
# ===============================================

# Fonction pour valider la cible et créer le répertoire
setup_target() {
    if [ -z "$CIBLE" ]; then
        echo "ERREUR: Veuillez spécifier une IP ou un nom de domaine."
        echo "Usage: $0 google.com"
        exit 1
    fi

    # Définir le répertoire de rapport (basé sur la cible)
    REPERTOIRE_RAPPORT="rapports_recon/${CIBLE}_${DATE_RAPPORT}"
    
    # Créer le répertoire et gérer les erreurs
    mkdir -p "$REPERTOIRE_RAPPORT" 2>/dev/null
    if [ $? -ne 0 ]; then
        echo "ERREUR: Impossible de créer le répertoire $REPERTOIRE_RAPPORT."
        exit 1
    fi

    echo "Cible: $CIBLE"
    echo "Rapport stocké dans: $REPERTOIRE_RAPPORT"
    echo "-------------------------------------"
}

# Fonction pour effectuer la recherche WHOIS
run_whois() {
    echo "[*] Exécution de la recherche WHOIS..."
    whois "$CIBLE" > "$REPERTOIRE_RAPPORT/whois_report.txt" 2>&1
    if [ $? -eq 0 ]; then
        echo "  [OK] Rapport WHOIS sauvegardé."
    else
        echo "  [FAIL] Échec de la recherche WHOIS."
    fi
}

# Fonction pour scanner les ports communs avec nmap
run_nmap_scan() {
    echo "[*] Lancement du scan NMAP (Ports communs)..."
    # -Pn: Traiter l'hôte comme étant en ligne
    # -sV: Détecter la version des services
    # -O: Détecter le système d'exploitation
    # -oN: Sauvegarder la sortie normale dans un fichier
    nmap -Pn -sV -O "$CIBLE" -oN "$REPERTOIRE_RAPPORT/nmap_scan_report.txt" >/dev/null 2>&1

    if [ $? -eq 0 ]; then
        echo "  [OK] Rapport NMAP sauvegardé."
    else
        echo "  [FAIL] Échec du scan NMAP."
    fi
}

# ===============================================
# Logique Principale
# ===============================================

setup_target  # 1. Valider et préparer le répertoire
run_whois     # 2. Exécuter WHOIS
run_nmap_scan # 3. Exécuter NMAP

echo "-------------------------------------"
echo "✅ Reconnaissance terminée."
echo "Consultez le dossier $REPERTOIRE_RAPPORT pour les résultats."