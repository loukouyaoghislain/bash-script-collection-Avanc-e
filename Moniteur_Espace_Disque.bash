#!/bin/bash


# Seuil de pourcentage d'utilisation au-delà duquel alerter
SEUIL_ALERTE=80

# Système de fichiers à vérifier (le répertoire racine)
FICHIER_SYSTEME="/"


echo "--- Moniteur d'Espace Disque ---"
echo "Seuil d'alerte défini : $SEUIL_ALERTE%"
echo ""

# 1. Obtenir l'utilisation du disque racine
# df -h : Affiche l'utilisation du disque de manière lisible
# grep $FICHIER_SYSTEME : Filtre la ligne correspondant au répertoire racine
# awk '{print $5}' : Isole le 5ème champ (le pourcentage d'utilisation)
# tr -d '%' : Supprime le symbole du pourcentage pour obtenir un nombre entier

UTILISATION_ACTUELLE=$( df -h | grep "$FICHIER_SYSTEME$"|awk '{print $5}'| tr -d "%")

# Vérifier si la commande a réussi et a retourné un nombre
if [ -z "$UTILISATION_ACTUELLE" ]; then
    echo "ERREUR : Impossible de lire l'utilisation du disque pour $FICHIER_SYSTEME."
    exit 1
fi

echo "Utilisation actuelle du disque $FICHIER_SYSTEME : $UTILISATION_ACTUELLE%"


if (( UTILISATION_ACTUELLE > SEUIL_ALERTE )); then

    echo "==================================================="
    echo " ALERTE : L'utilisation ($UTILISATION_ACTUELLE%) a dépassé le seuil de $SEUIL_ALERTE%."
    echo "Il est temps de libérer de l'espace !"
    echo "==================================================="
else

    echo " Statut OK : L'utilisation du disque est confortable ($UTILISATION_ACTUELLE%)."
fi

echo "-------------------------------------"


