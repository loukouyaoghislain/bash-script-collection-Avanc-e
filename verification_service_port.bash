#!/bin/bash

echo "--- Vérificateur de Services Locaux ---"
echo ""

declare -A SERVICES
SERVICES=(
    [22]="SSH (Secure Shell)"
    [80]="HTTP (Serveur Web)"
    [443]="HTTPS (Serveur Web Sécurisé)"
    [3306]="MySQL/MariaDB"
    [5432]="PostgreSQL"
)

check_port_status() {
    local PORT=$1
    local NOM_SERVICE=$2
    
    if  ss -tuln | grep -q ":$PORT" ; then
        echo " OK: $NOM_SERVICE (Port $PORT) est en écoute."
    else
        echo " ÉCHEC: $NOM_SERVICE (Port $PORT) est fermé ou inactif."
    fi
}
echo "Statut des services critiques :"
echo "--------------------------------------------------------"

# Parcourir les clés (les numéros de port) du tableau
for PORT in "${!SERVICES[@]}"; do
    check_port_status "$PORT" "${SERVICES[$PORT]}"
done

echo "--------------------------------------------------------"
echo "Analyse terminée."