INSTALL spatial;
LOAD spatial;
  
CREATE TABLE IF NOT EXISTS interactions 
AS SELECT 
  ST_POINT(decimalLongitude,decimalLatitude) as location, 
  decimalLatitude,
  decimalLongitude,
  sourceTaxonPathNames,
  sourceTaxonFamilyName,
  sourceTaxonName, 
  interactionTypeName,
  targetTaxonPathNames,
  targetTaxonFamilyName,
  targetTaxonName, 
  eventDate as eventDate,
  referenceCitation, 
  sourceCitation, 
  sourceNamespace, 
  sourceLastSeenAtUnixEpoch
FROM 
  'interactions.tsv.gz'
WHERE 
  interactionTypeName IN ('flowersVisitedBy','visitsFlowersOf', 'pollinates', 'pollinatedBy')
  AND
  ST_IsValid(location);


CREATE INDEX IF NOT EXISTS my_idx ON interactions USING RTREE (location);

COPY (
 SELECT interactions.*, countries.ISO3_CODE 
 FROM interactions
  JOIN (
    SELECT 
      geom AS country, 
      ISO3_CODE 
    FROM 
      'CNTR_RG_20M_2024_4326.gpkg' 
    WHERE 
      EU_STAT = 'T' 
      OR 
      ISO3_CODE IN ['GBR', 'NOR', 'CHE', 'UKR']
  ) AS countries
  ON ST_Within(interactions.location, countries.country)
) TO 'euroappa.gpkg'
WITH (FORMAT gdal, DRIVER 'GPKG', SRS 'EPSG:4326');
 
COPY (
  SELECT * from 'euroappa.gpkg'
) TO 'euroappa.parquet';
