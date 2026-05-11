INSTALL spatial;
LOAD spatial;
INSTALL h3 FROM community;
LOAD h3;

COPY (
  SELECT 
    ST_GeomFromText(h3_cell_to_boundary_wkt(h3_cell)) AS cell_boundary, 
    number_of_records 
  FROM (
    SELECT 
      h3_latlng_to_cell(ST_Y(geom), ST_X(geom), 4) AS h3_cell,
      LOG(1+COUNT(*)) AS number_of_records
    FROM 
      'euroappa-nuts-2021.gpkg'
    GROUP BY 
      h3_cell
  ) 
) TO 'euroappa-nuts-2021-h3-level-4.gpkg'
WITH (FORMAT gdal, DRIVER 'GPKG', SRS 'EPSG:4326', OVERWRITE true);

COPY (
  SELECT 
    ST_GeomFromText(h3_cell_to_boundary_wkt(h3_cell)) AS cell_boundary, 
    number_of_records 
  FROM (
    SELECT 
      h3_latlng_to_cell(ST_Y(geom), ST_X(geom), 4) AS h3_cell,
      LOG(1+COUNT(*)) AS number_of_records
    FROM 
      'euroappa-cntr-2024.gpkg'
    GROUP BY 
      h3_cell
  ) 
) TO 'euroappa-cntr-2024-h3-level-4.gpkg'
WITH (FORMAT gdal, DRIVER 'GPKG', SRS 'EPSG:4326', OVERWRITE true);

INSTALL spatial;
LOAD spatial;
INSTALL h3 FROM community;
LOAD h3;

COPY (
  SELECT 
    ST_GeomFromText(h3_cell_to_boundary_wkt(h3_cell)) AS cell_boundary, 
    number_of_records 
  FROM (
    SELECT 
      h3_latlng_to_cell(ST_Y(geom), ST_X(geom), 6) AS h3_cell,
      LOG(1+COUNT(*)) AS number_of_records
    FROM 
      'euroappa-nuts-2021.gpkg'
    GROUP BY 
      h3_cell
  ) 
) TO 'euroappa-nuts-2021-h3-level-6.gpkg'
WITH (FORMAT gdal, DRIVER 'GPKG', SRS 'EPSG:4326', OVERWRITE true);

COPY (
  SELECT 
    ST_GeomFromText(h3_cell_to_boundary_wkt(h3_cell)) AS cell_boundary, 
    number_of_records 
  FROM (
    SELECT 
      h3_latlng_to_cell(ST_Y(geom), ST_X(geom), 6) AS h3_cell,
      LOG(1+COUNT(*)) AS number_of_records
    FROM 
      'euroappa-cntr-2024.gpkg'
    GROUP BY 
      h3_cell
  ) 
) TO 'euroappa-cntr-2024-h3-level-6.gpkg'
WITH (FORMAT gdal, DRIVER 'GPKG', SRS 'EPSG:4326', OVERWRITE true);
