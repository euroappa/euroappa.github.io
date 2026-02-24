2026-02-23

EuroAPPA prototype

Requirements include:

R1. generate list of pollinators for a specific geospatial/taxonomic range

R2. generate a list of plant - pollinator interaction records for a specific geospatial/taxonomic range

Prototype Features

P1.F1. offers a bash script to generate euroappa data products [euroappa.gpkg](euroappa.gpkg), [euroappa.parquet](euroappa.parquet) from a recent snapshot of GloBI indexed interactions. 
P1.F2. offers a workflow to generate country specific lists of insect pollinators (e.g., [select-pollinators-of-europe.sql](select-pollinators-of-europe.sql), [select-pollinators-of-ireland.sql](select-pollinators-of-ireland.sql), [select-pollinators-of-netherlands.sql](select-pollinators-of-netherlands.sql))
P1.F3. offers data products containing country specific pollinator checklists (e.g., [pollinators-of-europe.csv](pollinators-of-europe.csv), [pollinators-of-ireland.csv](pollinators-of-ireland.csv), [pollinators-of-netherlands.csv](pollinators-of-netherlands.csv))
P1.F4. allows for online queries through https://shell.duckdb.org/ via scripts like
P1.F5. allows for spatial queries through QGIS and euroappa.gpkg data product.
P1.F6. allows for R  
