
# scari 1.0.0

## Release notes

* includes the most up-to-date SLF occurrence data from GBIF and `lydemapr` package (July 2026)
* updated to R 4.6.1 and all packages updated as of July 30, 2026
* added additional and updated [published sources](https://github.com/ieco-lab/scari/blob/master/data-raw/slf_publishedOccurrenceRecords_papers.csv)
* big fixes to most functions

# scari 0.3.0

## Release Notes

* built on R 4.5.1
* uses `renv` for package management
  * updated all packages and specified usage of older versions where code breaks
* changed main map projections used for models to [Behrmann Equal Area, ESRI:54017](https://epsg.io/54017) 
  * re-wrote all vignettes to use this projection (it is in meters, not lat/lon)
* re-ran all models using new projection and updated SLF data from GBIF, `lydemapr`, and [published sources](https://github.com/ieco-lab/scari/blob/master/data-raw/slf_publishedOccurrenceRecords_papers.csv)
* added usage of `CoordinateCleaner` package
* streamlined vignette [150_create_risk_report_example_usage](https://github.com/ieco-lab/scari/blob/master/vignettes/150_create_risk_report_example_usage.Rmd) to be a simplified example of the function `create_risk_report()`
* created example vignette for `create_risk_report_USA()` function (will be used specifically for IVRs in the USA and is not yet deployed): [152_create_risk_report_USA](https://github.com/ieco-lab/scari/blob/master/vignettes/152_create_risk_report_USA.Rmd)

# scari 0.2.0

## Release Notes

* built on R 4.4.1
* retired used of `taxize`, `humboldt`, `rgdal`, and `rgeos`

# slfSpread 0.1.0

## Release Notes

* this is the initial release of the project, which was built on R 4.2.3 and which was used to generate all results for our paper
* this package utilizes outdated packages that rely on rgdal and rgeos, which will be retired in future versions 
* future updates will include:
  * retire usage of `taxize`, `humboldt`, `raster`, and `dsmextra`
  * update version of R to 4.4.1


