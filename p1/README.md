2026-02-23

EuroAPPA prototype P1

## Requirements

P1.R1. generate list of pollinators for a specific geospatial/taxonomic range

P1.R2. generate a list of plant - pollinator interaction records for a specific geospatial/taxonomic range

P2.R3  allows for a way to provide feedback (not yet implemented) 

### Features

P1.F1. offers a bash script to generate euroappa data products [euroappa.gpkg](euroappa.gpkg), [euroappa.parquet](euroappa.parquet) from a recent snapshot of GloBI indexed interactions. 

P1.F2. offers data workflows and data products for generating of insect pollinators by country
 * [insect-pollinators-of-europe.sql](insect-pollinators-of-europe.sql) ```-[generated]->``` [insect-pollinators-of-europe.csv](insect-pollinators-of-europe.csv), 
 * [insect-pollinators-of-ireland.sql](insect-pollinators-of-ireland.sql) ```-[generated]->``` [insect-pollinators-of-ireland.csv](insect-pollinators-of-ireland.csv) 
 *  [insect-pollinators-of-netherlands.sql](insect-pollinators-of-netherlands.sql)) ```-[:generated]->``` [insect-pollinators-of-netherlands.csv](insect-pollinators-of-netherlands.csv)

P1.F3. offers data products containing country specific pollinator-plant association record datasets:
 * [insect-pollinator-plant-associations-of-europe.sql](insect-pollinator-plant-associations-of-europe.sql) ```-[:generated]``` -> [insect-pollinator-plant-associations-of-europe.csv](insect-pollinator-plant-associations-of-europe.csv)
 * [insect-pollinators-of-ireland.csv](insect-pollinators-associations-of-ireland.sql) ```-[:generated]->``` [insect-pollinators-of-ireland.csv](insect-pollinators-associations-of-ireland.csv)
 * [insect-pollinators-associations-of-netherlands.sql](insect-pollinators-associations-of-netherlands.sql) ```-[:generated]->``` [insect-pollinators-associations-of-netherlands.csv](insect-pollinators-associations-of-netherlands.csv))

P1.F4. allows for online queries through [```https://shell.duckdb.org/```](https://shell.duckdb.org) via top 10 most used programming language: SQL and [```euroappa.parquet```](euroappa.parquet) (< 20MiB). 

P1.F5. allows for spatial queries through QGIS and ```euroappa.gpkg``` (bigish dataset ~500MiB) data product.

P1.F6. data products (parquet files) are compatible with commercial data exploration platforms such as ArcGIS, MotherDuck, and have support for integration into R and Python.   

P1.F7. data products (csv files) are compatible with Excel and Google Sheet etc. 
