SELECT DISTINCT 
  sourceTaxonFamilyName as pollinatorFamily, 
  sourceTaxonName as pollinatorName,
  targetTaxonFamilyName as plantFamily,
  targetTaxonName as plantName,
FROM 
  'euroappa.parquet'
WHERE
  sourceTaxonPathNames ~ '.*[^A-Z]Insecta[ ].*'
  AND sourceTaxonFamilyName NOT NULL 
GROUP BY sourceTaxonFamilyName, sourceTaxonName, targetTaxonFamilyName, targetTaxonName
ORDER BY sourceTaxonFamilyName, sourceTaxonName, targetTaxonFamilyName, targetTaxonName;
