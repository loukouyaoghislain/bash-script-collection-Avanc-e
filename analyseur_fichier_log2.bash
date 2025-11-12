#!/bin/bash
read -r -p "veuillez entrer le chemin du fichier a analyser: " LOG_FILE
FICHIER_ERREUR="erreur_$(date +"%y%m%d_%H%M%S").log"
FICHIER_WARNING="warning_$(date +"%y%m%d_%H%M%S").log"
IGNORE_WARNING=false

if [[ -z "$LOG_FILE" ]];then 
    echo "veuillez specifier le chemin du fichier a analyser"
    echo "Utilisation: $0 /chemin/vers/mon_application.log"
    exit 1
fi


if [[ ! -f "$LOG_FILE" ]];then
    echo "le fichier $LOG_FILE n'existe pas ou n'est pas un fichier"
    exit 1
fi
if [[ "$2" == "--ignore-warning" ]];then 
    IGNORE_WARNING=true
    echo "les messages warning seront ignores dans le fichier de sortie"
    sleep 3
fi

echo "Debut de l'analyse du fichier $LOG_FILE"

sleep 3


NB_LIGNES_ERREUR=$(grep -iE 'ERROR' "$LOG_FILE" | wc -l)

NB_LIGNES_WARNING=$(grep -iE 'WARNING' "$LOG_FILE" | wc -l)

if [[ "$IGNORE_WARNING" = true ]];then 
    echo "filtrage uniquement des lignes ERREUR ==> dans le fichier de sortie "
    $(grep -iE 'ERROR' "$LOG_FILE">"$FICHIER_ERREUR")
else
    echo "filtrage uniquement des lignes ERREUR/WARNING ==> dans le fichier de sortie "
    $(grep -iE 'ERROR|WARNING' "$LOG_FILE">"$FICHIER_ERREUR")
    
fi

echo "======================rapport final de $LOG_FILE ========================"

    echo  "Total Nombre de ligne ERROR trouves est: $NB_LIGNES_ERREUR "
    echo "Total Nombre de ligne WARNING trouves est: $NB_LIGNES_WARNING"

TOTAL_LIGNES_CRITIQUES=$(wc -l<"$FICHIER_ERREUR")

if [[ "$TOTAL_LIGNES_CRITIQUES" -gt 0 ]];then 
        echo "ligne ecrite dans le ficher : $TOTAL_LIGNES_CRITIQUES"
        echo "fichier de sortie: $FICHIER_ERREUR"
else
        echo "aucune ligne critique n'a ete trouve pour enregistrement"
fi
echo "========================================================================="



