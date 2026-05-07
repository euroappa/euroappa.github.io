-- EuroAPPA Prototype 2 (p2) 2026-05-07
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
  sourceTaxonId,
  sourceTaxonName,
  '' as sourceTaxonFamilyId, 
  '' as sourceTaxonFamilyName,
  interactionTypeName,
  targetTaxonId,
  targetTaxonName, 
  '' as targetTaxonFamilyId,
  '' as targetTaxonFamilyName,
  "http://rs.tdwg.org/dwc/terms/eventDate" as eventDate,
  referenceCitation, 
  citation, 
  namespace, 
  lastSeenAt
FROM 
  'interactions.parquet'
WHERE 
  interactionTypeName IN ('visitsFlowersOf', 'pollinates')
  AND
  ST_IsValid(location)
UNION
  SELECT
  ST_POINT(CAST(decimalLongitude as DOUBLE),CAST(decimalLatitude as DOUBLE)) as location,
  decimalLatitude,
  decimalLongitude,
  targetTaxonId as sourceTaxonId,
  targetTaxonName as sourceTaxonName,
  '' as sourceTaxonFamilyId, 
  '' as sourceTaxonFamilyName,
  CASE 
   WHEN interactionTypeName = 'flowersVisitedBy' THEN 'visitsFlowersOf'
   WHEN interactionTypeName = 'pollinatedBy' THEN 'pollinates' 
  END as interactionTypeName,
  sourceTaxonId as targetTaxonId,
  sourceTaxonName as targetTaxonName,
  '' as targetTaxonFamilyId, 
  '' as targetTaxonFamilyName,
  "http://rs.tdwg.org/dwc/terms/eventDate" as eventDate,
  referenceCitation,
  citation,
  namespace,
  lastSeenAt
FROM
  -- Poelen, J. H., & Global Biotic Interactions Community. (2026). Global Biotic Interactions (GloBI) Review Dataset Corpus hash://md5/9f9f111af19f657e31ce04b9d422eed4 hash://sha256/8467e21bf1194cbbcb201b3ee2bbee0e2d657a772b4e3ce62fc63afe9116c626 [Data set]. Zenodo. https://doi.org/10.5281/zenodo.20072186
  -- 'https://linker.bio/hash://md5/ba2109369961995e5583180d47a60d70'
  -- 'https://zenodo.org/records/20072186/files/interactions.parquet'
  'interactions.parquet'
WHERE
  interactionTypeName IN ('flowersVisitedBy', 'pollinatedBy')
  AND
  ST_IsValid(location);


CREATE INDEX IF NOT EXISTS my_idx ON interactions USING RTREE (location);

COPY (
 SELECT 
  interactions.*
  , countries.ISO3_CODE
  , countries.NUTS_ID
  , countries.NUTS_NAME 
  , countries.LEVL_CODE 
 FROM interactions
  JOIN (
    SELECT 
      Shape AS country, 
      ISO3_CODE,
      NUTS_ID,
      NUTS_NAME,
      LEVL_CODE
    FROM
       -- Territorial units for statistics (NUTS) 
       -- https://ec.europa.eu/eurostat/web/gisco/geodata/statistical-units/territorial-units-statistics
      -- 'https://gisco-services.ec.europa.eu/distribution/v2/nuts/gpkg/NUTS_RG_01M_2024_4326.gpkg'
      -- hash://md5/92d74dd2a16d8d8082fc8625f5bb7ac2
      'NUTS_RG_01M_2024_4326.gpkg' 
    WHERE
      LEVL_CODE = 3
      AND ( 
        EU_STAT = 'T' 
        OR 
        ISO3_CODE IN ['GBR', 'NOR', 'CHE', 'UKR']
      )
  ) AS countries
  ON ST_Within(interactions.location, countries.country)
) TO 'euroappa.gpkg'
  WITH (FORMAT gdal, DRIVER 'GPKG', SRS 'EPSG:4326', OVERWRITE true);

COPY ( 
  SELECT * EXCLUDE(geom) 
  FROM 'euroappa.gpkg' 
) TO 'euroappa.parquet' 
  WITH (OVERWRITE true);

COPY ( 
  SELECT * EXCLUDE(geom) 
  FROM 'euroappa.gpkg' 
) TO 'euroappa.csv.gz' 
  WITH (OVERWRITE true);  
