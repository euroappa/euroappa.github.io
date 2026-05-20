-- EuroAPPA Prototype 2 (p2) 2026-05-07/2026-05-11
-- 
-- To generate the euroappa data products, run the following bash script
-- against after installing duckdb v1.2+: 
--
--   cat euroappa.sql | duckdb 
-- 
INSTALL spatial;
LOAD spatial;
  
CREATE TABLE IF NOT EXISTS interactions 
AS SELECT 
  ST_POINT(CAST(decimalLongitude as DOUBLE),CAST(decimalLatitude as DOUBLE)) as location, 
  CAST(decimalLatitude as DOUBLE) as decimalLatitude,
  CAST(decimalLongitude as DOUBLE) as decimalLongitude,
  sourceTaxonId as sourceVerbatimTaxonId,
  sourceTaxonName as sourceVerbatimTaxonName,
  sourceTaxonPathIds as sourceVerbatimTaxonPathIds,
  sourceTaxonPath as sourceVerbatimTaxonPath,
  '' as sourceTaxonNameRelation,
  '' as sourceTaxonId,
  '' as sourceTaxonName,
  '' as sourceTaxonAuthority, 
  '' as sourceTaxonRank, 
  '' as sourceTaxonFamilyId, 
  '' as sourceTaxonFamilyName,
  '' as sourceTaxonPathIds, 
  '' as sourceTaxonPath,
  interactionTypeId,
  interactionTypeName,
  targetTaxonId as targetVerbatimTaxonId,
  targetTaxonName as targetVerbatimTaxonName,
  targetTaxonPathIds as targetVerbatimTaxonPathIds,
  targetTaxonPath as targetVerbatimTaxonPath,
  '' as targetTaxonNameRelation,
  '' as targetTaxonId,
  '' as targetTaxonName,
  '' as targetTaxonAuthority, 
  '' as targetTaxonRank, 
  '' as targetTaxonFamilyId,
  '' as targetTaxonFamilyName,
  '' as targetTaxonPathIds,
  '' as targetTaxonPath,
  "http://rs.tdwg.org/dwc/terms/eventDate" as eventDate,
  referenceCitation, 
  citation, 
  namespace, 
  CONCAT('https://zenodo.org/search?q=%22', contentHash, '%22') AS datasetReviewUrl,
  lastSeenAt
FROM 
  'lib/interactions.parquet'
WHERE 
  interactionTypeName IN ('visitsFlowersOf', 'pollinates')
  AND
  ST_IsValid(location)
UNION SELECT
  ST_POINT(CAST(decimalLongitude as DOUBLE),CAST(decimalLatitude as DOUBLE)) as location, 
  CAST(decimalLatitude as DOUBLE) as decimalLatitude,
  CAST(decimalLongitude as DOUBLE) as decimalLongitude,
  sourceTaxonId as sourceVerbatimTaxonId,
  sourceTaxonName as sourceVerbatimTaxonName,
  sourceTaxonPathIds as sourceVerbatimTaxonPathIds,
  sourceTaxonPath as sourceVerbatimTaxonPath,
  '' as sourceTaxonNameRelation,
  '' as sourceTaxonId,
  '' as sourceTaxonName,
  '' as sourceTaxonAuthority, 
  '' as sourceTaxonRank, 
  '' as sourceTaxonFamilyId, 
  '' as sourceTaxonFamilyName,
  '' as sourceTaxonPathIds, 
  '' as sourceTaxonPath,
  interactionTypeId,
  interactionTypeName,
  targetTaxonId as targetVerbatimTaxonId,
  targetTaxonName as targetVerbatimTaxonName,
  targetTaxonPathIds as targetVerbatimTaxonPathIds,
  targetTaxonPath as targetVerbatimTaxonPath,
  '' as targetTaxonNameRelation,
  '' as targetTaxonId,
  '' as targetTaxonName,
  '' as targetTaxonAuthority, 
  '' as targetTaxonRank, 
  '' as targetTaxonFamilyId,
  '' as targetTaxonFamilyName,
  '' as targetTaxonPathIds,
  '' as targetTaxonPath,
  "http://rs.tdwg.org/dwc/terms/eventDate" as eventDate,
  referenceCitation, 
  citation, 
  namespace, 
  CONCAT('https://zenodo.org/search?q=%22', contentHash, '%22') AS datasetReviewUrl,
  lastSeenAt
FROM
  -- Poelen, J. H., & Global Biotic Interactions Community. (2026). Global Biotic Interactions (GloBI) Review Dataset Corpus hash://md5/9f9f111af19f657e31ce04b9d422eed4 hash://sha256/8467e21bf1194cbbcb201b3ee2bbee0e2d657a772b4e3ce62fc63afe9116c626 [Data set]. Zenodo. https://doi.org/10.5281/zenodo.20072186
  -- 'https://linker.bio/hash://md5/ba2109369961995e5583180d47a60d70'
  -- 'https://zenodo.org/records/20072186/files/interactions.parquet'
  'lib/interactions.parquet'
WHERE
  interactionTypeName IN ('flowersVisitedBy', 'pollinatedBy')
  AND
  ST_IsValid(location);


CREATE INDEX IF NOT EXISTS my_idx ON interactions USING RTREE (location);

COPY (
 SELECT 
  interactions.*
  , countries.CNTR_CODE
  , countries.NUTS_ID
  , countries.NUTS_NAME 
  , countries.LEVL_CODE 
 FROM interactions
  JOIN (
    SELECT 
      geom AS country, 
      CNTR_CODE,
      NUTS_ID,
      NUTS_NAME,
      LEVL_CODE
    FROM
       -- Territorial units for statistics (NUTS) 
       -- https://ec.europa.eu/eurostat/web/gisco/geodata/statistical-units/territorial-units-statistics
       -- 'https://gisco-services.ec.europa.eu/distribution/v2/nuts/gpkg/NUTS_RG_01M_2021_4326.gpkg'
       -- hash://md5/9e1146e52a2cb5e4a34153facaf50b0b
      'lib/NUTS_RG_01M_2021_4326.gpkg' 
    WHERE
      LEVL_CODE = 3
      AND
      CNTR_CODE IN ['AT','BE','BG','CH','CY','CZ','DE','DK','EE','EL','ES','FI','FR','HR','HU','IE','IT','LT','LU','LV','MT','NL','NO','PL','PT','RO','SE','SI','SK','UK']
  ) AS countries
  ON ST_Within(interactions.location, countries.country)
) TO 'dist/euroappa-nuts-2021.gpkg'
  WITH (FORMAT gdal, DRIVER 'GPKG', SRS 'EPSG:4326', OVERWRITE true);
  
COPY ( 
  SELECT * EXCLUDE(geom) 
  FROM 'dist/euroappa-nuts-2021.gpkg' 
) TO 'dist/euroappa-nuts-2021.parquet' 
  WITH (OVERWRITE true);

COPY ( 
  SELECT * EXCLUDE(geom) 
  FROM 'dist/euroappa-nuts-2021.gpkg' 
) TO 'dist/euroappa-nuts-2021.csv.gz' 
  WITH (OVERWRITE true);  
  
COPY ( 
  SELECT * 
  FROM 'dist/euroappa-nuts-2021.gpkg' 
) TO 'dist/euroappa-nuts-2021.fgb'
  WITH (FORMAT gdal, DRIVER 'FlatGeobuf', SRS 'EPSG:4326', OVERWRITE true); 

COPY (
 SELECT 
  interactions.*
   , countries.ISO3_CODE
   , countries.CNTR_ID
   , countries.NAME_ENGL
 FROM interactions
  JOIN (
    SELECT 
      Shape AS country, 
      ISO3_CODE,
      CNTR_ID,
      NAME_ENGL
    FROM
       -- Administrative Units: Countries
       -- https://ec.europa.eu/eurostat/web/gisco/geodata/administrative-units/countries
      -- 'https://gisco-services.ec.europa.eu/distribution/v2/nuts/gpkg/CNTR_RG_01M_2024_4326.gpkg'
      -- hash://md5/f1472535e38a026bd4df4228caf01f82
      'lib/CNTR_RG_01M_2024_4326.gpkg' 
    WHERE
      CNTR_ID IN ['AT','BE','BG','CH','CY','CZ','DE','DK','EE','EL','ES','FI','FR','HR','HU','IE','IT','LT','LU','LV','MT','NL','NO','PL','PT','RO','SE','SI','SK','UK']
  ) AS countries
  ON ST_Within(interactions.location, countries.country)
) TO 'dist/euroappa-cntr-2024.gpkg'
  WITH (FORMAT gdal, DRIVER 'GPKG', SRS 'EPSG:4326', OVERWRITE true);


COPY ( 
  SELECT * EXCLUDE(geom) 
  FROM 'dist/euroappa-cntr-2024.gpkg' 
) TO 'dist/euroappa-cntr-2024.parquet' 
  WITH (OVERWRITE true);

COPY ( 
  SELECT * EXCLUDE(geom) 
  FROM 'dist/euroappa-cntr-2024.gpkg' 
) TO 'dist/euroappa-cntr-2024.csv.gz' 
  WITH (OVERWRITE true);  

COPY ( 
  SELECT * 
  FROM 'dist/euroappa-cntr-2024.gpkg' 
) TO 'dist/euroappa-cntr-2024.fgb'
  WITH (FORMAT gdal, DRIVER 'FlatGeobuf', SRS 'EPSG:4326', OVERWRITE true); 
