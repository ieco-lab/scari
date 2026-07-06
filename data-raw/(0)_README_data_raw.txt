###########################
########## ABOUT ##########
###########################

# scari
# folder: data-raw and all sub-folders
# descriptions and changelog

###########################
########## FILES ##########
###########################

# data-raw (raw downloads or data received from collaborators)

----------slf_lyde_raw_coords_DATE----------

## About

the raw SLF coordinates pulled from the lydemapR package

## Changelog

2024-07-29-
2025-07-07- taken from a version of tinySLF, included data from up until June 2025- inaturalist data ommitted
2026-06-23- data up until the end of 2025, download included about 1.2 million records


----------slf_publishedOccurrenceRecords_----------

## About

Contains occurrence records for SLF taken from a list of literature sources (see slf_publishedOccurrenceRecords_papers)

## Changelog

v1-
v2-
v3-
2026-06-24 (v4)- The key column was updated to create a key for papers which did not specify one. I created a unique key using a the following convention: Author last name (1st 3 letters), year of publication, and a number to represent the sample. new papers added: Kamiyama 2026, Liu 2024

----------slf_gbif_raw_coords_DATE----------

## About

original species occurrence data retrieval from gbif

## Changelog

2023-08-24- does not include any points from N America
2026-06-23- included about 60,000 records- countries inclided- China, Japan, South Korea, North Korea, India, Vietnam, Bangladesh, USA

----------slf_gbif_DATE----------

## About

the raw query data for the original gbif pull (raw_coords).
This contains all of the raw information describing the gbif pull and all of the data that were pulled from gbif using the spocc package.

----------US_FIPS_Codes----------

## About

This contains FIPS codes lists (per county), downloaded from the US census bureau




# CHELSA

----------_bookmark.duck----------

The data folder bookmarks from the CHELSA data server.
This can be used to download the files in bulk from a particular directory.

----------_URLs.txt----------

These files contain the URLs that are given if you choose to download the directory by file.
Each URL immediately downloads the associated CHELSA raster file when put in a browser.





# data-old

----------slfSpread_jumps_locations_----------

see metadata for variable info

### changelog

v3- reran script when it was improved by Nadege, some data points were cut



----------tinyslf_presences_cleaned----------

records pulled from a pre-publication version of the lydemapR package dataset.
these data were cleaned and rarefied (spatial thinning).



----------tinyslf_absences----------

the corresponding SLF absence data from tinyslf_presences_cleaned


