SELECT DISTINCT 
  sourceTaxonFamilyName as pollinatorFamily, 
  sourceTaxonName as pollinatorName,
  targetTaxonFamilyName as plantFamily,
  targetTaxonName as plantName,
FROM 
  'https://github.com/euroappa/euroappa.github.io/releases/download/euroappa.p3/euroappa-nuts-2021-col.parquet'
WHERE
  sourceTaxonPath ~ '.*[^A-Z]Insecta[ ].*'
  AND sourceTaxonFamilyName NOT NULL 
  -- Norway Statistical Regions https://en.wikipedia.org/wiki/NUTS_statistical_regions_of_Norway
  -- NUTS Level 3 Vestland: NO0A2
  AND NUTS_ID = 'NO0A2'
GROUP BY sourceTaxonFamilyName, sourceTaxonName, targetTaxonFamilyName, targetTaxonName
ORDER BY sourceTaxonFamilyName, targetTaxonFamilyName, sourceTaxonName, targetTaxonName;
