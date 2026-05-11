2026-05-11

# EuroAPPA prototype P2.

TLDR; This prototypes offers integrated data products like ```euroappa-nuts-2021-gbif.csv`` and ```euroappa-cntr-2024-col.csv``` containing geospatially aligned plant-pollinator records as interpreted from selected versioned taxonomic resources. For a more detailed description, see below.

See [https://github.com/euroappa/euroappa.github.io](https://github.com/euroappa/euroappa.github.io/tree/main/p1) for associated files. Also, for other examples using these methods (e.g. duckdb, QGIS) see [https://www.globalbioticinteractions.org/2026/01/22/euroappa/](https://www.globalbioticinteractions.org/2026/01/22/euroappa/) . 

## Changes

Where P1 used verbatim taxonomic names and provided decimal coordinates, P2 applies specific taxonomic perspectives (i.e., GBIF taxonomic backbone [1], Catalogue of Life [2] as versioned in Nomer's Corpus of Taxonomic Resources [3]) and specific geospatial units (i.e., administrative country boundaries [4], statistical zones[5]). 

## Requirements

As part of our [https://en.wikipedia.org/wiki/Requirements_management](requirements management) process.

Note that there's a difference between functional (e.g., generate a list of pollinators) and non-functional (e.g., solution should outlive the lifetime of the project, web accessible, data is versioned) requirements. 

### Functional Requirements

P2.FR1. generate a list of plant - pollinator interaction records for a specific geospatial/taxonomic range

P2.FR2. generate list of pollinators for a specific geospatial/taxonomic range

P2.FR3  allows for a way to provide feedback (not yet implemented) 


## Features

A [feature](https://en.wikipedia.org/wiki/Software_feature) is "a prominent or distinctive user-visible aspect, quality, or characteristic of a software system or systems", as defined by Kang et al. 1990. A feature implements one or more requirements.

P2.F1. offers a [bash script](bin/make.sh) to implement an automated workflow to generate euroappa data products. These data products are deposited in Zenodo and were derived a versioned copy of the GloBI Data Review Corpus [6] and selected taxonomic and geospatial databases. 

highlevel workflow:

```
 interaction data + taxonomic alignment + geospatial alignment = EuroAPPA P2 data products


P2.F2. offers data workflows and data products for generating of insect pollinators by country using SQL and [DuckDB](https://duckdb.org) 
 * [insect-pollinators-of-europe.sql](insect-pollinators-of-europe.sql) ```-[generated]->``` [insect-pollinators-of-europe.csv](insect-pollinators-of-europe.csv), 
 * [insect-pollinators-of-ireland.sql](insect-pollinators-of-ireland.sql) ```-[generated]->``` [insect-pollinators-of-ireland.csv](insect-pollinators-of-ireland.csv) 
 *  [insect-pollinators-of-netherlands.sql](insect-pollinators-of-netherlands.sql)) ```-[:generated]->``` [insect-pollinators-of-netherlands.csv](insect-pollinators-of-netherlands.csv)

Example query:
```
SELECT DISTINCT 
  sourceTaxonFamilyName, 
  sourceTaxonName 
FROM 
  'euroappa-nuts-2021-col.parquet'
WHERE
  sourceTaxonPathNames ~ '.*[^A-Z]Insecta[ ].*'
  AND sourceTaxonFamilyName NOT NULL
  -- Ireland Statistical Regions https://en.wikipedia.org/wiki/NUTS_statistical_regions_of_Ireland
  -- NUTS Level 3 West: IE042 
  AND NUTS_ID = 'IE042'
GROUP BY sourceTaxonFamilyName, sourceTaxonName 
ORDER BY sourceTaxonFamilyName, sourceTaxonName;
```

first 5 records:

| sourceTaxonFamilyName | sourceTaxonName |
| --- | --- |
| Andrenidae | Andrena |
| Andrenidae | Andrena carantonica |
| Andrenidae | Andrena cineraria |
| Andrenidae | Andrena fucata |
| Andrenidae | Andrena haemorrhoa |

P2.F3. offers data products containing country specific pollinator-plant association record datasets:
 * [insect-pollinator-plant-associations-of-europe.sql](insect-pollinator-plant-associations-of-europe.sql) ```-[:generated]``` -> [insect-pollinator-plant-associations-of-europe.csv](insect-pollinator-plant-associations-of-europe.csv)
 * [insect-pollinators-of-ireland.sql](insect-pollinators-associations-of-ireland.sql) ```-[:generated]->``` [insect-pollinators-of-ireland.csv](insect-pollinators-associations-of-ireland.csv)
 * [insect-pollinators-associations-of-netherlands.sql](insect-pollinators-associations-of-netherlands.sql) ```-[:generated]->``` [insect-pollinators-associations-of-netherlands.csv](insect-pollinators-associations-of-netherlands.csv))

Example query:

```
SELECT DISTINCT 
  sourceTaxonFamilyName as pollinatorFamily, 
  sourceTaxonName as pollinatorName,
  targetTaxonFamilyName as plantFamily,
  targetTaxonName as plantName,
FROM 
  'euroappa.parquet'
WHERE
  sourceTaxonPathNames ~ '.*[^A-Z]Insecta[ ].*'
  AND sourceTaxonFamilyName NOT NULL 
  AND targetTaxonFamilyName NOT NULL 
  -- country code for Ireland according to https://en.wikipedia.org/wiki/ISO_3166-1_alpha-3
  AND ISO3_CODE = 'IRL'
GROUP BY sourceTaxonFamilyName, sourceTaxonName, targetTaxonFamilyName, targetTaxonName
ORDER BY sourceTaxonFamilyName, targetTaxonFamilyName, sourceTaxonName, targetTaxonName;
```

first 5 records:

| pollinatorFamily | pollinatorName | plantFamily | plantName |
| --- | --- | --- | --- |
| Andrenidae | Andrena haemorrhoa | Adoxaceae | Viburnum tinus |
| Andrenidae | Andrena carantonica | Asteraceae | Taraxacum |
| Andrenidae | Andrena haemorrhoa | Asteraceae | Taraxacum |
| Andrenidae | Andrena lapponica | Asteraceae | Taraxacum |
| Andrenidae | Andrena | Brassicaceae | Brassica napus |

P2.F4. allows for online queries through [```https://shell.duckdb.org/```](https://shell.duckdb.org) via top 10 most used programming language: SQL and [```euroappa.parquet```](euroappa.parquet) (< 20MiB). Example queries include [listing the first five interactions associated with bee family Apidae](https://shell.duckdb.org/#queries=v0,SELECT-sourceTaxonFamilyName%2CsourceTaxonName%2CinteractionTypeName%2CtargetTaxonFamilyName%2CtargetTaxonName%0AFROM-'https%3A%2F%2Feuroappa.github.io%2Fp1%2Feuroappa.parquet'-%0AWHERE-sourceTaxonFamilyName-%3D-'Apidae'%0ALIMIT-5~).  

[![Screenshot of DuckDB Web Shell in Action](duckdb-shell-2026-02-24.png)](https://shell.duckdb.org/#queries=v0,SELECT-sourceTaxonFamilyName%2CsourceTaxonName%2CinteractionTypeName%2CtargetTaxonFamilyName%2CtargetTaxonName%0AFROM-'https%3A%2F%2Feuroappa.github.io%2Fp1%2Feuroappa.parquet'-WHERE-sourceTaxonFamilyName-%3D-'Apidae'-LIMIT-5;~)

P2.F5. allows for spatial queries through QGIS and ```euroappa-nuts-2021-col.gpkg``` and related (bigish dataset ~500MiB) data products.

P2.F6. data products (parquet files) are compatible with commercial data exploration platforms such as ArcGIS, MotherDuck, and have support for integration into R and Python.   

P2.F7. data products (csv files) are compatible with Excel and Google Sheet etc. 


## Data Products

 data corpus | geospatial scheme | taxonomic scheme | products | 
 --- | --- | --- | ---
 GloBI 2026 | NUTS 2021 | GBIF Taxonomic Backbone | euroappa-nuts-2021-gbif.csv / .tsv / .gpkg / .parquet
 GloBI 2026 | CNTR 2025 | GBIF Taxonomic Backbone | euroappa-cntr-2024-gbif.csv / .tsv / .gpkg / .parquet
 GloBI 2026 | NUTS 2021 | Catalogue of Life | euroappa-nuts-2021-col.csv / .tsv / .gpkg / .parquet
 GloBI 2026 | CNTR 2025 | Catalogue of Life | euroappa-cntr-2024-col.csv / .tsv / .gpkg / .parquet

## Data Schemas 

### NUTS Associated Schemas

As generated from 

```
duckdb \
 -markdown \
 -c "describe 'dist/euroappa-nuts-2021-col.parquet';"
```

|       column_name       | column_type | null | key  | default | extra |
|-------------------------|-------------|------|------|---------|-------|
| decimalLatitude         | DOUBLE      | YES  | NULL | NULL    | NULL  |
| decimalLongitude        | DOUBLE      | YES  | NULL | NULL    | NULL  |
| sourceTaxonId           | VARCHAR     | YES  | NULL | NULL    | NULL  |
| sourceTaxonName         | VARCHAR     | YES  | NULL | NULL    | NULL  |
| sourceTaxonAuthorship   | VARCHAR     | YES  | NULL | NULL    | NULL  |
| sourceTaxonFamilyId     | VARCHAR     | YES  | NULL | NULL    | NULL  |
| sourceTaxonFamilyName   | VARCHAR     | YES  | NULL | NULL    | NULL  |
| sourceTaxonPathIds      | VARCHAR     | YES  | NULL | NULL    | NULL  |
| sourceTaxonPathNames    | VARCHAR     | YES  | NULL | NULL    | NULL  |
| sourceTaxonNameRelation | VARCHAR     | YES  | NULL | NULL    | NULL  |
| interactionTypeName     | VARCHAR     | YES  | NULL | NULL    | NULL  |
| targetTaxonId           | VARCHAR     | YES  | NULL | NULL    | NULL  |
| targetTaxonName         | VARCHAR     | YES  | NULL | NULL    | NULL  |
| targetTaxonAuthorship   | VARCHAR     | YES  | NULL | NULL    | NULL  |
| targetTaxonFamilyId     | VARCHAR     | YES  | NULL | NULL    | NULL  |
| targetTaxonFamilyName   | VARCHAR     | YES  | NULL | NULL    | NULL  |
| targetTaxonPathIds      | VARCHAR     | YES  | NULL | NULL    | NULL  |
| targetTaxonPathNames    | VARCHAR     | YES  | NULL | NULL    | NULL  |
| targetTaxonNameRelation | VARCHAR     | YES  | NULL | NULL    | NULL  |
| eventDate               | TIMESTAMP   | YES  | NULL | NULL    | NULL  |
| referenceCitation       | VARCHAR     | YES  | NULL | NULL    | NULL  |
| citation                | VARCHAR     | YES  | NULL | NULL    | NULL  |
| namespace               | VARCHAR     | YES  | NULL | NULL    | NULL  |
| lastSeenAt              | TIMESTAMP   | YES  | NULL | NULL    | NULL  |
| CNTR_CODE               | VARCHAR     | YES  | NULL | NULL    | NULL  |
| NUTS_ID                 | VARCHAR     | YES  | NULL | NULL    | NULL  |
| NUTS_NAME               | VARCHAR     | YES  | NULL | NULL    | NULL  |
| LEVL_CODE               | BIGINT      | YES  | NULL | NULL    | NULL  |

with an example record from NUTS ID PT200 (Região Autónoma dos Açores) shown below as generated via

```
duckdb \
 -csv \
 -c "select * from 'dist/euroappa-nuts-2021-col.parquet' WHERE NUTS_ID = 'PT200' limit 1;" \
  | mlr --icsv --oxtab cat
```

yielding

```
decimalLatitude         38.6747398333
decimalLongitude        -27.2511157778
sourceTaxonId           COL:4YRBX
sourceTaxonName         Sphaerophoria scripta
sourceTaxonAuthorship    (Linnaeus, 1758)
sourceTaxonFamilyId     COL:GVS
sourceTaxonFamilyName   Syrphidae
sourceTaxonPathIds      COL:CS5HF   COL:N   COL:RT   COL:L2655   COL:H6   COL:D2P   COL:GVS   COL:87CNM   COL:87CZ8   COL:BY4GV   COL:BY4GW   COL:4YRBX
sourceTaxonPathNames    Eukaryota   Animalia   Arthropoda   Hexapoda   Insecta   Diptera   Syrphidae   Syrphinae   Syrphini   Sphaerophoria   Sphaerophoria (Sphaerophoria)   Sphaerophoria scripta
sourceTaxonNameRelation HAS_ACCEPTED_NAME
interactionTypeName     visitsFlowersOf
targetTaxonId           COL:622TP
targetTaxonName         Asteraceae
targetTaxonAuthorship    Dumort.
targetTaxonFamilyId     COL:622TP
targetTaxonFamilyName   Asteraceae
targetTaxonPathIds      COL:CS5HF   COL:P   COL:CMQ8S   COL:TP   COL:MG   COL:ST   COL:622TP
targetTaxonPathNames    Eukaryota   Plantae   Pteridobiotina   Tracheophyta   Magnoliopsida   Asterales   Asteraceae
targetTaxonNameRelation HAS_ACCEPTED_NAME
eventDate               2025-06-11 15:20:24
referenceCitation       https://www.inaturalist.org/observations/289117707
citation                http://iNaturalist.org is a place where you can record what you see in nature, meet other nature lovers, and learn about the natural world.
namespace               globalbioticinteractions/inaturalist
lastSeenAt              2026-05-06 15:48:15.203
CNTR_CODE               PT
NUTS_ID                 PT200
NUTS_NAME               Região Autónoma dos Açores
LEVL_CODE               3
```

## CNTR Associated Schemas 

As generated from 

```
duckdb \
 -markdown \
 -c "describe 'dist/euroappa-cntr-2024-col.parquet';"
```

|       column_name       | column_type | null | key  | default | extra |
|-------------------------|-------------|------|------|---------|-------|
| decimalLatitude         | DOUBLE      | YES  | NULL | NULL    | NULL  |
| decimalLongitude        | DOUBLE      | YES  | NULL | NULL    | NULL  |
| sourceTaxonId           | VARCHAR     | YES  | NULL | NULL    | NULL  |
| sourceTaxonName         | VARCHAR     | YES  | NULL | NULL    | NULL  |
| sourceTaxonAuthorship   | VARCHAR     | YES  | NULL | NULL    | NULL  |
| sourceTaxonFamilyId     | VARCHAR     | YES  | NULL | NULL    | NULL  |
| sourceTaxonFamilyName   | VARCHAR     | YES  | NULL | NULL    | NULL  |
| sourceTaxonPathIds      | VARCHAR     | YES  | NULL | NULL    | NULL  |
| sourceTaxonPathNames    | VARCHAR     | YES  | NULL | NULL    | NULL  |
| sourceTaxonNameRelation | VARCHAR     | YES  | NULL | NULL    | NULL  |
| interactionTypeName     | VARCHAR     | YES  | NULL | NULL    | NULL  |
| targetTaxonId           | VARCHAR     | YES  | NULL | NULL    | NULL  |
| targetTaxonName         | VARCHAR     | YES  | NULL | NULL    | NULL  |
| targetTaxonAuthorship   | VARCHAR     | YES  | NULL | NULL    | NULL  |
| targetTaxonFamilyId     | VARCHAR     | YES  | NULL | NULL    | NULL  |
| targetTaxonFamilyName   | VARCHAR     | YES  | NULL | NULL    | NULL  |
| targetTaxonPathIds      | VARCHAR     | YES  | NULL | NULL    | NULL  |
| targetTaxonPathNames    | VARCHAR     | YES  | NULL | NULL    | NULL  |
| targetTaxonNameRelation | VARCHAR     | YES  | NULL | NULL    | NULL  |
| eventDate               | TIMESTAMP   | YES  | NULL | NULL    | NULL  |
| referenceCitation       | VARCHAR     | YES  | NULL | NULL    | NULL  |
| citation                | VARCHAR     | YES  | NULL | NULL    | NULL  |
| namespace               | VARCHAR     | YES  | NULL | NULL    | NULL  |
| lastSeenAt              | TIMESTAMP   | YES  | NULL | NULL    | NULL  |
| ISO3_CODE               | VARCHAR     | YES  | NULL | NULL    | NULL  |
| CNTR_ID                 | VARCHAR     | YES  | NULL | NULL    | NULL  |
| NAME_ENGL               | VARCHAR     | YES  | NULL | NULL    | NULL  |

With example record generated via 

```
duckdb \
 -csv \
 -c "SELECT * from 'dist/euroappa-cntr-2024-col.parquet' WHERE ISO3_CODE = 'IRL' limit 1;" \
  | mlr --icsv --oxtab cat
```

yielding

```
decimalLatitude         53.13666534423828
decimalLongitude        -9.114999771118164
sourceTaxonId           COL:MFLX
sourceTaxonName         Bombus jonellus
sourceTaxonAuthority    (Kirby, 1802)
sourceTaxonFamilyId     COL:6KD
sourceTaxonFamilyName   Apidae
sourceTaxonPathIds      COL:CS5HF   COL:N   COL:RT   COL:L2655   COL:H6   COL:HYM   COL:KZPW7   COL:KZMNP   COL:625GP   COL:6KD   COL:J5V   COL:KN5   COL:62H8K   COL:MFLX
sourceTaxonPathNames    Eukaryota   Animalia   Arthropoda   Hexapoda   Insecta   Hymenoptera   Apocrita   Aculeata   Apoidea   Apidae   Apinae   Bombini   Bombus   Bombus jonellus
sourceTaxonNameRelation HAS_ACCEPTED_NAME
interactionTypeName     pollinates
targetTaxonId           COL:768LJ
targetTaxonName         Pedicularis sylvatica
targetTaxonAuthority    L.
targetTaxonFamilyId     COL:DQG
targetTaxonFamilyName   Orobanchaceae
targetTaxonPathIds      COL:CS5HF   COL:P   COL:CMQ8S   COL:TP   COL:MG   COL:3F4   COL:DQG   COL:KVNJK   COL:6JYZ   COL:768LJ
targetTaxonPathNames    Eukaryota   Plantae   Pteridobiotina   Tracheophyta   Magnoliopsida   Lamiales   Orobanchaceae   Pedicularideae   Pedicularis   Pedicularis sylvatica
targetTaxonNameRelation HAS_ACCEPTED_NAME
eventDate               2017-06-02 00:00:00
referenceCitation       doi:10.1111/1365-2664.13990
citation                Lanuza et al. (2025), EuPPollNet: A European Database of Plant-Pollinator Networks. Global Ecol Biogeogr, 34: e70000. https://doi.org/10.1111/geb.70000
namespace               JoseBSL/EuPPollNet
lastSeenAt              2026-05-06 22:50:55.128
ISO3_CODE               IRL
CNTR_ID                 IE
NAME_ENGL               Ireland
```

## References


