###########################
########## ABOUT ##########
###########################

# scari
# folder: vignettes
# descriptions and changelog

This README is for the vignettes subfolder, which contains workflows for my package scari.
Outputs from these vignettes are stored in "data" or "vignette-outputs".
Old versions of these vignettes are stored in scari/scari_sandbox (scari in this case is not the package root folder, but is one folder above that in OneDrive).

###########################
########## FILES ##########
###########################

----------scari.Rmd----------

## About

Example usage file. Contains examples of using create_risk_report() for the country of France. Updated version contains example usage of MaxEnt model outputs using create_MaxEnt_suitability_maps() and compute_MaxEnt_summar_statistics().

## Changelog

v0- initial version
v1- updates to section 3 to add example calculation of maxent models for other pests of interest.

----------supplement2_figures_tables.Rmd----------

## About

This file creates appendix S2 (tables and figures) and outputs it to a word document for further editing.

## Changelog

v0- creates v2 of appendix S2.

----------initialize_site_pkgdown.R----------

## About

This file is used to create the pkgdown website. It should run at the end of a run of the package.

----------010_initialize_pkg.Rmd----------

## About

Initializes renv, saves data objects for internal use, creates file paths, includes troubleshooting notes.

## Changelog

v0- initial version
v1- 2024-08-26
v2- 2024-10-16- changed to .Rmd, fixed renv errors with project
v3- 2025-07-04- added some descriptions to file
v4- 2026-07-30- fixed some bugs, emphasized gitcreds set



----------020_retrieve_bioclim_variables.Rmd----------

## About

This vignette downloads and tidies the bioclimatic covariates for our models. It also outlines the process for choosing the final set for our models via reducing co-linearity.

## Changelog

v0- initial version
v1
v2
v3- 2024-07-29- rework- updated SLF presence data and inclusion of other SSP scenarios- adds SSP126 and SSP585 to analyses
v4- 2024-10-01- cleaned and simplified workflow. Switched order in workflow to 020
v5- 2025-07-01- shifted workflow to utilize equal area projection EPSG:54017 (Behrmann), retired usage of access to cities variable for masking


----------030_retrieve_occurrence_records.Rmd----------

## About

retrieves SLF records from various databases and literature sources, harmonizes and compiles them

## Changelog

v0- initial version
v1
v2- 2024-01-05- retired use of spocc package and replaced with rgbif for GBIF workflow
v3- 2024-07-29- rework methods and data update- using new GBIF and lydeMapR data (up until 2023 and including TN and chicago)
v4- 2024-08-05- swapped workflow from scrubr (deprecated) to coordinateCleaner R package, removed Taiwan records based on new paper pre-print
v5- 2025-02-08- retired use of Humboldt and spThin packages. Replaced usage with GeoThinneR package. Changed spatial thinning method to thin using the bioclimatic grid cells rather than simple pairwise distances. Switched order in workflow to 030
v6- 2025-07-04- reran file with new datasets, transformed final dataset into Behrmann projection
v7- 2026-07-30- reran file with new datasets, used input directly from LydemapR package, rather than tinyslf csv upload (previous version from Joe Keller, July 7, 2025)- had to update lydemapr coords on 2026-07-30 using new package version (previously 3.0.3, now 4.1.0)



----------040_setup_global_MaxEnt_model.Rmd----------

## About

Preparations for running the global-scale model, including cropping rasters, choosing random background points, and plotting all data elements.

## Changelog

v0- initial version
v1- 2024-07-31- rework- updated SLF presence data and inclusion of other SSP scenarios- added cropping of other ssp scenario rasters
v2- 2025-07-07- rerun for v4 of model, transformed final dataset into Behrmann projection
v3- 2026-07-30- rerun for v5 of the model- contains new SLF data

----------050_run_global_MaxEnt_model.Rmd----------

## About

This vignette creates all data objects needed to run the global model. It trains the model and uses various functions to create suitability maps, summary statistics, etc.

## Changelog

v0- initial version- in sandbox/vignettes_old
v1- in sandbox/vignettes_old. creates v1 of the global model
v2- creates v2 of the global model- changed procedure for global model cross-validation from k-fold random selection to k-fold blocked selection (multiple papers said this was more rigorous)- added blockCV package usage- LATER: reverted to k-fold random CV because blocked CV did not work- creates
v3- 2024-07-31- rework- updated SLF presence data and inclusion of other SSP scenarios- creates v3 of the global model, fixed some methods for cross validation of model, added other SSP scenario predictions for model
v4- 2025-07-07- rerun for v4 of model, transformed final dataset into Behrmann projection
v5- 2026-07-30- rerun for v5 of the model- contains new SLF data


----------051_compute_MaxEnt_summary_statistics_workflow.Rmd----------

## About

This vignette contains an example workflow of the R function "compute_MaxEnt_summary_statistics.R", which uses the model objects from SDMtune to calculate summary statistics.

## Changelog

v0-
v1- 2024-08-27


----------060_setup_regional_MaxEnt_models.Rmd----------

## About

This vignette creates rasters, presence and background point datasets needed for the regional-scale models.

## Changelog

v0- initial version- in sandbox/vignettes_old- trained the invaded model on the entire easternUSA
v1- updated invaded model weighting to use new global model output, updated invaded model background selection to 355km buffer around presences- generated invaded background points v2 and regional_invaded_buffer layers
v2- reverted to eastern USA test area instead of 355km buffer
v3- did not weight easternUSA model. Moved section on weighting to supp materials
v4- added koeppen climate download and use for selecting background points
v5- added table indicating number of training points per model, added plot faceting
v6- 2024-08-02- rework- updated SLF presence data and inclusion of other SSP scenarios
v7- 2024-10-09- cleaned and simplified workflow
v8- 2025-07-14- rerun for new versions of models using Behrmann projection
v9- 2026-07-30- rerun for new versions of models (v9 invaded, v4 invaded asian, v5 native) using new data for 2025-2026


----------070_run_regional_invaded_MaxEnt_model.Rmd----------

## About

This vignette creates all data objects needed to run the regional_invaded model. It trains the model and uses various functions to create suitability maps, summary statistics, etc.

## Changelog

v0- initial version- in sandbox/vignettes_old
v1- in sandbox/vignettes_old
v2- creates the v2 of the regional_invaded_model in maxent/models. Removed gridSearch and used model settings from global instead.
v3- creates the v3 of the regional_invaded model in maxent/models. In sandbox/vignettes_old
v4- creates the v4 of the regional_invaded model in maxent/models. reverted to regional background method that uses entire eastern USA background area
v5
v6- 2024-08-02- rework- updated SLF presence data and inclusion of other SSP scenarios- changed validation (testing) region to Ri.Asia training region (see citation)- creates v7 of the regional_invaded model
v7- 2025-07-14- v8 of model-transformed final dataset into Behrmann projection
v8- 2026-07-23- v9 of model, added sections to load in suitability maps for display


----------080_run_regional_invaded_asian_MaxEnt_model.Rmd----------

## About

This vignette creates all data objects needed to run the regional_invaded_asian model. It trains the model and uses various functions to create suitability maps, summary statistics, etc.

## Changelog

v0- initial version
v1-
v2- 2024-08-08- rework- updated SLF presence data and inclusion of other SSP scenarios, creates v2 of the regional_invaded_asian model
v3- 2025-07-14- rework- v3 of model-transformed final dataset into Behrmann projection
v4- 2026-07-23- v4 of model, added sections to load in suitability maps for display


----------090_run_regional_native_MaxEnt_model.Rmd----------

## About

This vignette creates all data objects needed to run the regional_native model. It trains the model and uses various functions to create suitability maps, summary statistics, etc.

## Changelog

v0- initial version- in sandbox/vignettes_old
v1- in sandbox/vignettes_old
v2- creates the v1 of the regional_native_model in maxent/models. Removed gridSearch and used model settings from global instead.
v3
v4- 2024-08-08- rework- updated SLF presence data and inclusion of other SSP scenarios, creates v3 of the regional_native model
v5- 2025-07-14- rework- v4 of model-transformed final dataset into Behrmann projection
v6- 2026-07-30- creates v5 of model based on newer data



----------100_run_ExDet_MIC.Rmd----------

## About

This vignette runs the exdet and MIC analyses and saves their outputs. It also creates plots of the outputs.

## Changelog

v0- initial version- in sandbox/vignettes_old
v1- added ExDet and MIC for global model
v2- added grey area to each figure to represent bg area
v3- 2024-08-09- rework- updated SLF presence data and inclusion of other SSP scenarios
v4- 2024-10-18- changed plotting to re-load rasters so that vignette could be rendered without dsmextra package (will retire because its not available for R 4.4)
v5- 2025-07-28- rerun for model versions (global v4, invaded v8, invaded asian v3, native v4)
v6- 2026-08-06- rerun for model versions (global v5, invaded n america v9, invaded asiian v4, native v5)


----------110_ensemble_regional_models.Rmd----------

## About

This vignette takes steps to ensemble the predictions of each regional model into an ensemble. Ensembling is done per time period and ssp scenario. The three ssp scenarios are also ensembled into a final mean / modal prediction. First, rasters are weighted using the AUC and exdet per model and a weighted mean is taken. Next, rasters and MTSS / MTP thresholds are ensembled. MICs are also ensembled. Finally, we analyze the percent contribution of each model to the ensemble.

## Changelog

v0- initial version- in sandbox/vignettes_old
v1-
v2- added section to ensemble ExDet and MIC rasters, bar chart showing % cont to regional ensemble
v3- 2024-08-09- rework- updated SLF presence data and inclusion of other SSP scenarios
v4- 2025-07-28- rerun for model versions (global v4, invaded v8, invaded asian v3, native v4)
v5- 2026-08-06- rerun for model versions (global v5, invaded n america v9, invaded asiian v4, native v5)



----------120_create_suitability_plots.Rmd----------

## About

This vignette intersects the global and regional_ensemble model predictions into categorized suitability maps based on the MTSS threshold.

## Changelog

v0-
v1-
v2- 2024-08-09- rework- updated SLF presence data and inclusion of other SSP scenarios
v3-
v4- 2025-07-31- rerun for model versions (global v4, invaded v8, invaded asian v3, native v4)





----------130_create_suitability_xy_plots_viticulture.Rmd----------

## About

This vignette begins data analysis for our MaxEnt by creating suitability scatter plots for locations of viticultural regions.

## Changelog

v0- initial version- in sandbox/vignettes_old
v1- using function to transform scatter plot axes
v2-
v3- 2024-08-14- rework- updated SLF presence data and inclusion of other SSP scenarios
v4- 2025-08-04- rerun for model versions (global v4, invaded v8, invaded asian v3, native v4)
    2026-10-27- no new version, but retrieved code from v3 or v2 to create unweighted version of viticultural xy scatter




----------131_create_suitability_xy_plots_SLF.Rmd----------

## About

This vignette begins data analysis for our MaxEnt by creating suitability scatter plots for SLF point datasets.

## Changelog

v0- initial version- in sandbox/vignettes_old
v1- using function to transform scatter plot axes
v2
v3- re-created workflow according to vig 130_v2
v4- 2024-08-14- rework- updated SLF presence data and inclusion of other SSP scenarios
v5- 2025-08-05- rerun for model versions (global v4, invaded v8, invaded asian v3, native v4)



----------140_assess_response_curves.Rmd----------

## About

This vignette plots the response curve outputs from SDMtune as ggplots and adds all ensemble curves to the same plot.

## changelog

v0- initial version
v1- 2024-08-16- rework- updated SLF presence data and inclusion of other SSP scenarios
v2- 2025-08-05- rerun for model versions (global v4, invaded v8, invaded asian v3, native v4)


----------141_assess_AUC_confusion_matrix.Rmd----------

## About

This vignette plots the ROC curve for all models, as well as calculates a table of the sensitivity, specificity, commission and omission error (a confusion matrix of each model) to assess fit.

## changelog

v0- initial version
v1- 2025-08-06- rerun for model versions (global v4, invaded v8, invaded asian v3, native v4)


----------142_assess_var_imp.Rmd----------

## About

This vignette plots the variable importance for each model

## changelog

v0- initial version
v1- 2025-08-07- rerun for model versions (global v4, invaded v8, invaded asian v3, native v4)



----------150_create_risk_report_countries_provinces.Rmd----------

## About

This vignette contains example usage for the function "generate_risk_report.R", which creates a risk report for the SLF based on model outputs.

## changelog

v0- initial version
v1- 2024-08-16- rework- updated SLF presence data and inclusion of other SSP scenarios
v2- 2025-08-05- rerun for model versions (global v4, invaded v8, invaded asian v3, native v4)



----------160_generate_format_figures.Rmd----------

## About

This vignette formats risk tables from vignettes 130 and 131 by adding colors and headers.

## changelog

v0- initial version
v1- 2024-08-14- rework- updated SLF presence data and inclusion of other SSP scenarios
v2- changeed name from format_risk_tables to generate_format_figures- combined with generate_extra_plots (161)


