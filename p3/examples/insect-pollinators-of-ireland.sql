SELECT DISTINCT 
  sourceTaxonFamilyName, 
  sourceTaxonName 
FROM 
  'https://github.com/euroappa/euroappa.github.io/releases/download/euroappa.p3/euroappa-nuts-2021-col.parquet'
WHERE
  sourceTaxonPath ~ '.*[^A-Z]Insecta[ ].*'
  AND sourceTaxonFamilyName NOT NULL 
  -- Ireland Statistical Regions https://en.wikipedia.org/wiki/NUTS_statistical_regions_of_Ireland
  -- NUTS Level 3 West: IE042 
  AND NUTS_ID = 'IE042'
GROUP BY sourceTaxonFamilyName, sourceTaxonName 
ORDER BY sourceTaxonFamilyName, sourceTaxonName;
