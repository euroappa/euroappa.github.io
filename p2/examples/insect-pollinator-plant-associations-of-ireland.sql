SELECT DISTINCT 
  sourceTaxonFamilyName as pollinatorFamily, 
  sourceTaxonName as pollinatorName,
  targetTaxonFamilyName as plantFamily,
  targetTaxonName as plantName,
FROM 
  'https://euroappa.github.io/p2/dist/euroappa-nuts-2021-col.parquet'
WHERE
  sourceTaxonPathNames ~ '.*[^A-Z]Insecta[ ].*'
  AND sourceTaxonFamilyName NOT NULL 
  -- Ireland Statistical Regions https://en.wikipedia.org/wiki/NUTS_statistical_regions_of_Ireland
  -- NUTS Level 3 West: IE042 
  AND NUTS_ID = 'IE042'
GROUP BY sourceTaxonFamilyName, sourceTaxonName, targetTaxonFamilyName, targetTaxonName
ORDER BY sourceTaxonFamilyName, targetTaxonFamilyName, sourceTaxonName, targetTaxonName;
