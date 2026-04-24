SELECT 
    e.nom AS entrepot,
    p.description AS produit,
    s.quantite_disponible,
    s.couverture_semaines
FROM fact_stocks s
JOIN dim_produits p ON s.product_id = p.product_id
JOIN dim_entrepots e ON s.entrepot_id = e.entrepot_id
WHERE s.couverture_semaines < 2 
  AND s.quantite_disponible > 0
ORDER BY e.nom, s.couverture_semaines ASC;
