BEGIN {
    # La balise <tr> est ouverte ici pour la première ligne (les en-têtes)
}

NR == 1 {
    # ---------------------------------------------
    # Traitement de l\'en-tête (ligne 1)
    # ---------------------------------------------
    
    # Commencer la ligne du tableau
    print "  <tr>"
    
    # Boucle sur tous les champs de la ligne
    for (i=1; i<=NF; i++) {
        # Imprimer chaque champ comme un en-tête de colonne (<th>)
        # $i représente le champ actuel
        printf "    <th>%s</th>\n", $i
    }
    
    # Fermer la ligne du tableau
    print "  </tr>"
    
}

NR > 1 {
    # ---------------------------------------------
    # Traitement des Lignes de Données (ligne 2 et suivantes)
    # ---------------------------------------------
    
    # Commencer la ligne du tableau
    print "  <tr>"
    
    # Boucle sur tous les champs de la ligne
    for (i=1; i<=NF; i++) {
        # Imprimer chaque champ comme une donnée de tableau (<td>)
        printf "    <td>%s</td>\n", $i
    }
    
    # Fermer la ligne du tableau
    print "  </tr>"
}

END {
    # La balise </table> et la fin du document HTML sont gérées en dehors d\'AWK
}