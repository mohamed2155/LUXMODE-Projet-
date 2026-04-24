SELECT 
    p.product_id,
    p.description AS produit,
    p.famille,
    SUM(v.chiffre_affaires) AS total_ca
FROM 
    fact_ventes v
JOIN 
    dim_produits p ON v.product_id = p.product_id
GROUP BY 
    p.product_id, p.description, p.famille
ORDER BY 
    total_ca DESC
LIMIT 10;

SELECT 
    c.nom AS client,
    c.type,
    ROUND(SUM(v.chiffre_affaires - (p.cout_unitaire * v.quantite_vendue)), 2) AS marge_brute_totale
FROM fact_ventes v
JOIN dim_clients c ON v.client_id = c.client_id
JOIN dim_produits p ON v.product_id = p.product_id
GROUP BY c.nom, c.type
ORDER BY marge_brute_totale DESC
LIMIT 5;

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

SELECT 
    t.mode_transport,
    SUM(t.empreinte_carbone_kg) AS total_co2,
    SUM(p.poids_kg * t.quantite) AS poids_total_transporte_kg,
    ROUND(SUM(t.empreinte_carbone_kg) / NULLIF(SUM(p.poids_kg * t.quantite), 0), 4) AS ratio_co2_par_kg
FROM fact_transports t
JOIN dim_produits p ON t.product_id = p.product_id
GROUP BY t.mode_transport
ORDER BY ratio_co2_par_kg DESC;

SELECT 
    site_production,
    ROUND(AVG(taux_rebut_pct) * 100, 2) AS taux_rebut_moyen_pourcentage,
    SUM(quantite_produite) AS volume_total_produit
FROM fact_production
GROUP BY site_production
ORDER BY taux_rebut_moyen_pourcentage DESC;