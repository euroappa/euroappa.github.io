2026-02-23

EuroAPPA prototype P1

## Requirements

P1.R1. generate list of pollinators for a specific geospatial/taxonomic range

P1.R2. generate a list of plant - pollinator interaction records for a specific geospatial/taxonomic range

P2.R3  allows for a way to provide feedback (not yet implemented) 

### Features

P1.F1. offers a bash script to generate euroappa data products [euroappa.gpkg](euroappa.gpkg), [euroappa.parquet](euroappa.parquet) from a recent snapshot of GloBI indexed interactions. 

P1.F2. offers a workflow to generate country specific lists of insect pollinators (e.g., [pollinators-of-europe.sql](pollinators-of-europe.sql), [pollinators-of-ireland.sql](pollinators-of-ireland.sql), [pollinators-of-netherlands.sql](pollinators-of-netherlands.sql))

P1.F3. offers data products containing country specific pollinator checklists (e.g., [insect-pollinators-of-europe.csv](insect-pollinators-of-europe.csv), [insect-pollinators-of-ireland.csv](insect-pollinators-of-ireland.csv), [insect-pollinators-of-netherlands.csv](insect-pollinators-of-netherlands.csv))

P1.F4. offers data products containing country specific pollinator checklists (e.g., [insect-pollinator-plant-associations-of-europe.csv](insect-pollinator-plant-associations-of-europe.csv), [insect-pollinators-of-ireland.csv](insect-pollinators-associations-of-ireland.csv), [insect-pollinators-associations-of-netherlands.csv](insect-pollinators-associations-of-netherlands.csv))

P1.F4. allows for online queries through https://shell.duckdb.org/ via scripts like

P1.F5. allows for spatial queries through QGIS and euroappa.gpkg data product.

P1.F6. data products (parquet files) are compatible with commercial data exploration platforms such as ArcGIS, MotherDuck, etc.  

P1.F7. data products (csv files) are compatible with 
