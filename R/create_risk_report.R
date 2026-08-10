#'Creates a localized report on the risk of establishment of Lycorma delicatula
#'
#'@description This function creates a report at the country or state/province level
#'for the risk of establishment of Lycorma delicatula. The report covers the major
#'data outputs from this R package analysis, including present and future risk maps,
#'range shift maps, risk plots and risk tables.
#'
#'@param locality.iso The [alpha-3 ISO code](https://www.iso.org/obp/ui/#search)
#'corresponding to the country of interest. If the desired locality is a state
#'or province, please still enter the ISO code and supply the name of that
#'province in `locality.name`.
#'
#'@param locality.name The name of the country, state or province for which to
#'generate the report. This is optional if the report is for a country, but
#'required if the report is for a state/province. Avoid special characters,
#'but please include those used used in the ethnic naming (ex: Côte d'Ivoire).
#'
#'@param locality.type One of "country" or "state_province". If you do
#'not know the state or province you are looking for, you might create a report
#'at the country level and then look at the return for the name of the state/province
#'included.
#'
#'@param focal.species Character, default is "L_delicatula". The name of the species
#'for which the report is generated.
#'
#'@param crs Character. The crs (coordinate reference system) of the projection
#'used in building the input species data. Should be in the format of an EPSG or
#'ESRI code (ex: EPSG:4326). Default is "ESRI:54017", the Behrmann Equal Area projection.
#'NOTE: If changing, ensure that other input data share the same crs.
#'
#'@param period.present Character. The time period included by the historical climate data.
#'This is used to name the output files. Default is period of 1981-2010.
#'
#'@param period.projected Character. The time period included by climate data projected
#'under climate change. This is used to name the output files. Default is period of 2041-2070.
#'
#'@param model.projected Character. The CMIP6 model used for projections of future
#'climate conditions. This is used to name the output files. Default is "GFDL-ESM4".
#'
#'@param ssp.projected Character string. The ssp scenarios used for projections of future
#'climate conditions. This is used to name the output files. Separate names with underscores.
#'Default is "ssp_126_370_585".
#'
#'@param save.report Logical. Should the report be saved to file? File location
#'specified by `mypath`. Note, this requires the use of Google Chrome.
#'
#'@param mypath Character. Only required if saving the report to file.
#'A file path to the sub directory where the model output will be stored.
#'Should be used with the [file.path()] function (i.e. with '/' instead of '\\').
#'If this sub directory does not already exist and should be created by the
#'function, set `create.dir` = TRUE. This will create a folder from the last
#'part of the filepath in `mypath`.
#'
#'@param raster.path Character. A file path to the directory containing the rasters
#'necessary to build this function. This folder should contain ONLY the three rasters
#'used for this function. See details for the rasters that should be included
#'with this data input and for the default path.
#'
#'@param create.dir Logical. Should the last element of `mypath` create a sub
#'directory for the report? If TRUE, the main folder will be created for
#'the model output. If FALSE (ie, the sub directory already exists), no directory
#'will be created.
#'
#'@param map.style List. This is used to apply ggplot aesthetics
#'to the mapped outputs. If specified, the given value should be a list of
#'ggplot aesthetic options. If not, the built-in default list will be used
#'(see details). See examples for usage.
#'
#'@param buffer.dist Numeric. The distance (in meters) from each IVR coordinate
#'at which to draw buffers zones on risk maps. Should be the same distance that
#'was used to calculate the predicted suitability for each IVR region.
#'See `predict.xy.suitability.R` for details. If not specified, buffers are not
#'drawn and suitability prediction method is assumed to be simple (point-wise).
#'
#'@details
#'
#'Requires the following packages: 'cli', 'common', 'formattable', 'ggnewscale', 'ggspatial', 'here', 'kableExtra','rnaturalearth', 'rnaturalearthdata', 'rnaturalearthhires', 'scari', 'sf', 'tidyverse', 'terra', 'webshot', and 'webshot2'.
#'**NOTE** This function requires the use of Google Chrome if save.report = TRUE
#'
#'Note that this function performs downloads from
#'[naturalearthdata.com](https://www.naturalearthdata.com/), if the data do not
#'already exist in `root/data-raw`.The function will automatically create
#'subfolders in `root/data-raw` containing the downloaded shapefiles.
#'
#'This function depends on certain files that have been distributed with this
#'package, which will be imported from `root/R/sysdata.rda` when the function
#'is run. The code to create `sysdata.rda` can be found in
#'`root/vignettes/160_generate_risk_report.Rmd`.
#'
#'Here is a list of the files included in `sysdata.rda`:
#'
#'* global_model_summary.rds                                            | created in vignette 050
#'* ensemble_thresh_values.rds                                          | created in vignette 110
#'
#'* wineries_esri54017_tidied.rds                                       | created in vignette 130
#'* regional_ensemble_wineries_1981-2010_xy_pred_suit.rds               | created in vignette 130
#'* regional_ensemble_wineries_2041-2070_GFDL_ssp_mean_xy_pred_suit.rds | created in vignette 130
#'* global_wineries_1981-2010_xy_pred_suit.rds                          | created in vignette 130
#'* global_wineries_2041-2070_GFDL_ssp_mean_xy_pred_suit.rds            | created in vignette 130
#'
#'Additionally, 3 rasters are used to create maps. These rasters are located in
#'`root/vignette-outputs/rasters`, These are the files:
#'
#'* slf_binarized_summed_1981-2010.asc                                  | created in vignette 120
#'* slf_binarized_summed_2041-2070_ssp_mean_GFDL.asc                    | created in vignette 120
#'* slf_range_shift_summed.asc                                          | created in vignette 120
#'
#'Additionally, `root/vignette-outputs/rasters` is the default path for the `raster.path()` argument.
#'
#'@return
#'
#'returns a report in list format. If save.report = TRUE, will also save the
#'report to file at destination specified by `mypath`. The outputs returned to
#'the global env in a list object include:
#'
#'* viticultural_regions_list - a list of known important wine regions within the locality with predicted suitability values and levels.
#'* risk_maps - a present and future map of risk for L delicatula establishment. The CMIP6 predictions are based on the mean of the three ssp scenarios
#'* viticultural_risk_plot = a quantified assessment of the risk for L delicatula establishment for known wine regions within the locality. This plot depicts the intersection of our two modeled scales.
#'* viticultural_risk_table = a risk table quantifying the level of risk to vineyards according to the quadrant plot
#'* range_shift_map = a map of potential range expansion for L delicatula under climate change
#'
#'Some maps may be formatted strangely because of a country's outlying territories.
#'You may need to further crop the plot using `xlim()` and `ylim()` (see examples).
#'
#'Use caution, this function will overwrite previous files output for the same locality.
#'
#'@examples
#'
#'# EXAMPLE USAGE---------------------------------------------------------------
#'
#'```R
#'scari::create_risk_report(
#' locality.iso = "aus",
#' locality.name = "australia",
#' locality.type = "country",
#' mypath = file.path(here::here(), "vignette-outputs", "reports", "Australia"),
#' create.dir = FALSE,
#' save.report = FALSE,
#' buffer.dist = 20000 # this is only used for buffered predictions, default is NA for simple predictions.
#')
#'
#'```
#'
#'# ARGUMENT USAGE--------------------------------------------------------------
#'
#'map_style <- list(
#' xlab("longitude"),
#' ylab("latitude"),
#' theme_classic()
#')
#'
#'# The output is in list format, so it should be called using this notation:
#'
#'```R
#'
#'# find viticultural regions in locality
#'viticultural_regions <- slf_risk_report[[2]]
#'
#'# alternatively, call elements by name:
#'risk_map_future <- slf_risk_report[["risk_maps"]][["future_risk_map"]]
#'
#'# sometimes a plot is off-center because the shapefile includes an outlying territory
#'# you can edit this directly in the ggplot object and save over the report output
#'
#'map_present <- slf_risk_report[["risk_maps"]][["present_risk_map"]] +
#'xlim(-10, 5) +
#'ylim(35, 44)
#'
#'# If you need to save the report Rdata object and use those figures elsewhere:
#'
#'readr::write_rds(slf_risk_report, file = file.path(here::here(), "vignette-outputs", "reports", "slf_risk_report.rds"))
#'
#'```
#'
#'@export
create_risk_report <- function(locality.iso, locality.name = locality.iso, locality.type, focal.species = "L_delicatula", crs = "ESRI:54017", period.present = "1981-2010", period.projected = "2041-2070", model.projected = "GFDL-ESM4", ssp.projected = "ssp_126_370_585", save.report = FALSE, mypath = NA, raster.path = file.path(here::here(), "vignette-outputs", "rasters"), create.dir = FALSE, map.style = NA, buffer.dist = NA) {

  # Error checks----------------------------------------------------------------

  if (is.character(locality.iso) == FALSE) {
    cli::cli_alert_info("Parameter 'locality.iso' must be of type character")
    stop()

  }

  if (is.character(locality.name) == FALSE) {
    cli::cli_abort("Parameter 'locality.name' must be of type character")
    stop()
  }


  if (is.character(locality.type) == FALSE) {
    cli::cli_abort("Parameter 'locality.type' must be of type character")
    stop()
  }

  if (is.character(crs) == FALSE) {
    cli::cli_abort("Parameter 'crs' must be of type character")
    stop()
  }

  if (is.character(period.present) == FALSE) {
    cli::cli_abort("Parameter 'period.present' must be of type character")
    stop()
  }

  if (is.character(period.projected) == FALSE) {
    cli::cli_abort("Parameter 'period.projected' must be of type character")
    stop()
  }

  if (is.character(model.projected) == FALSE) {
    cli::cli_abort("Parameter 'model.projected' must be of type character")
    stop()
  }

  if (is.character(ssp.projected) == FALSE) {
    cli::cli_abort("Parameter 'ssp.projected' must be of type character")
    stop()
  }

  if (!is.na(mypath) & is.character(mypath) == FALSE) {
    cli::cli_abort("Parameter 'mypath' must be of type character")
    stop()
  }

  if (is.character(raster.path) == FALSE) {
    cli::cli_abort("Parameter 'raster.path' must be of type character")
    stop()
  }


  # other errors
  if (is.logical(save.report) == FALSE) {
    cli::cli_abort("Parameter 'save.report' must be of type logical")
    stop()
  }

  if (stringr::str_length(locality.iso) != 3) {
    cli::cli_abort("Parameter 'locality.iso' must consist of the alpha-3 country code.")
    stop()
  }



  ## Create sub directory for files---------------------------------------------

  if (create.dir == FALSE) {

    # print message
    cli::cli_alert_info("proceeding without creating report output subdirectory folder")

  } else if (create.dir == TRUE) {

    # check if directory exists
    if(dir.exists(mypath) == FALSE) {

      cli::cli_alert_danger(paste0("Report output will not be saved because directory does not exist:\n", mypath))
    }

    # create sub directory from ending of mypath object
    dir.create(path = file.path(mypath))
    # print message
    cli::cli_alert_info(paste0("sub directory for files created at:\n", mypath))

  } else {
    cli::cli_abort("'create.dir' must be of type 'logical'")
    stop()

  }



  # Data and argument import----------------------------------------------------

  # dataset generated in vignette 160
  load(file.path(here::here(), "R", "sysdata.rda"))

  # import rasters
  binarized_hist <- terra::rast(file.path(raster.path, "slf_binarized_summed_1981-2010.asc"))
  binarized_future <- terra::rast(file.path(raster.path, "slf_binarized_summed_2041-2070_ssp_mean_GFDL.asc"))
  range_shift <- terra::rast(file.path(raster.path, "slf_range_shift_summed_ssp_mean_GFDL.asc"))

  # map.style
  # if it is not changed from NA, import default style
  if (is.na(map.style)) {

    map_style <- list(
      xlab(ifelse(terra::is.lonlat(terra::crs(binarized_hist)) == TRUE, "longitude", "UTM_eastings")), # if raster is in lonlat, label as lon/lat, otherwise UTM
      ylab(ifelse(terra::is.lonlat(terra::crs(binarized_hist)) == TRUE, "latitude", "UTM_northings")), # if raster is in lonlat, label as lon/lat, otherwise UTM
      # aesthetics
      theme_classic(),
      theme(
        # legend
        legend.position = "bottom",
        legend.key = element_rect(color = "black")
      ),
      guides(fill = guide_legend(nrow = 1, byrow = TRUE)),
      # scales
      scale_x_continuous(expand = c(0, 0)),
      scale_y_continuous(expand = c(0, 0))
    )

    # if it is changed to a list, import the given list
  } else if (is.list(map_style) == TRUE) {
    map_style <- map.style

    # otherwise, warn that given values must be a list
  } else {
    cli::cli_abort("parameter 'map.style' must be of type 'list'")
    stop()

  }

  # locality.iso
  locality_iso_internal <- locality.iso %>%
    toupper() %>%
    gsub(pattern = " ", replacement = "")

  # locality.name
  locality_name_internal <- locality.name %>%
    tolower() %>%
    gsub(pattern = " ", replacement = "_") %>%
    gsub(pattern = "-", replacement = "_") %>%
    gsub(pattern = ".", replacement = "", fixed = TRUE)



  # plotting objects and styles-------------------------------------------------

  # scatter plots
  # axis breaks
  breaks <- c(0.0, 0.2, 0.4, 0.6, 0.8, 1.0)
  # axis labels
  labels <- c(0, 2, 4, 6, 8, 10)

  risk_levels <- c("extreme", "high", "moderate", "low")

  # import shapefiles (locality)------------------------------------------------

  # update packages
  rnaturalearth::check_rnaturalearthdata()
  rnaturalearth::check_rnaturalearthhires()

  # import countries, first checking if the file already exists
  if(file.exists(file.path(here::here(), "data-raw", "ne_countries", "ne_10m_admin_0_countries.shp")) == TRUE) {

    countries_sf <- rnaturalearth::ne_load(
      scale = 10,
      type = "admin_0_countries",
      category = "cultural",
      destdir = file.path(here::here(), "data-raw", "ne_countries"),
      returnclass = "sf"
    )

    cli::cli_alert_info(paste0("Importing shapefiles from: ", file.path(here::here(), "data-raw")))

    # if it doesnt exist, create directories and download it
  } else if (file.exists(file.path(here::here(), "data-raw", "ne_countries", "ne_10m_admin_0_countries.shp")) == FALSE) {

    # create directories for shapefiles
    dir.create(path = file.path(here::here(), "data-raw", "ne_countries"))

    # retrieve data
    countries_sf <- rnaturalearth::ne_download(
      scale = 10, # highest resolution
      type = "admin_0_countries", # countries
      category = "cultural",
      destdir = file.path(here::here(), "data-raw", "ne_countries"),
      load = TRUE, # load into environment
      returnclass = "sf" # shapefile
    )

  }


  # import states and provinces
  if(file.exists(file.path(here::here(), "data-raw", "ne_states_provinces", "ne_10m_admin_1_states_provinces.shp")) == TRUE) {

    states_provinces_sf <- rnaturalearth::ne_load(
      scale = 10,
      type = "admin_1_states_provinces",
      category = "cultural",
      destdir = file.path(here::here(), "data-raw", "ne_states_provinces"),
      returnclass = "sf"
    )

    # if it doesnt exist, download it
  } else if (file.exists(file.path(here::here(), "data-raw", "ne_states_provinces", "ne_10m_admin_1_states_provinces.shp")) == FALSE) {

    # create directory for file
    dir.create(path = file.path(here::here(), "data-raw", "ne_states_provinces"))

    # download
    states_provinces_sf <- rnaturalearth::ne_download(
      scale = 10, # highest resolution
      type = "admin_1_states_provinces", # states and provinces
      category = "cultural",
      destdir = file.path(here::here(), "data-raw", "ne_states_provinces"),
      load = TRUE, # load into environment
      returnclass = "sf" # shape file
    )

  }

  # tidy shape files-------------------------------------------------------------

  # convert to proper crs
  countries_sf <- sf::st_transform(countries_sf, crs = crs)
  states_provinces_sf <- sf::st_transform(states_provinces_sf, crs = crs)

  # harmonize naming
  countries_sf <- countries_sf %>%
    dplyr::mutate(
      NAME_LONG = tolower(NAME_LONG),
      NAME_LONG = gsub(NAME_LONG, pattern = " |-", replacement = "_", fixed = TRUE),
      NAME_LONG = gsub(NAME_LONG, pattern = "/|.", replacement = "", fixed = TRUE),
      # alpha-3 iso used to isolate sf
      ADM0_A3 = toupper(ADM0_A3),
      ADM0_A3 = gsub(ADM0_A3, pattern = " ", replacement = ""),
      # also tidy abbreviations
      ABBREV = toupper(ABBREV),
      ABBREV = gsub(ABBREV, pattern = "/", replacement = ""),
      ABBREV = gsub(ABBREV, pattern = "-", replacement = "_"),
      ABBREV = gsub(ABBREV, pattern = ".", replacement = "", fixed = TRUE)
    )

  states_provinces_sf <- states_provinces_sf %>%
    dplyr::mutate(
      # names of states
      name = tolower(name),
      name = gsub(name, pattern = " |-", replacement = "_", fixed = TRUE), # replace these with an underscore
      name = gsub(name, pattern = "/|.", replacement = "", fixed = TRUE), # remove these
      name = gsub(name, pattern = ")|(", replacement = "", fixed = TRUE), # remove these
      name = gsub(name, pattern = "wine|region|state|province|and|surrounding|area|of|villiage|continental|grapes|territory|disputed|community|both|in|lima|since|including", replacement = ""), # a specific instance of some regions being referred to as "wine regions"
      # alpha-3 iso used to isolate sf
      adm0_a3 = toupper(adm0_a3),
      adm0_a3 = gsub(adm0_a3, pattern = " ", replacement = "")
    )


  # tidy IVR dataset------------------------------------------------------------

  IVR_locations <- IVR_locations %>%
    dplyr::mutate(
      # country
      Country = tolower(Country),
      Country = gsub(Country, pattern = " |-", replacement = "_", fixed = TRUE), # replace these with an underscore
      Country = gsub(Country, pattern = "/|.", replacement = "", fixed = TRUE), # remove these
      Country = gsub(Country, pattern = ")|(", replacement = "", fixed = TRUE) # remove these

    )

  # now remove specific words
  IVR_locations <- IVR_locations %>%
    dplyr::mutate(
      # subregion
      Region = tolower(Region),
      Region = gsub(Region, pattern = "/|.", replacement = "", fixed = TRUE), # remove these
      Region = gsub(Region, pattern = ")|(", replacement = "", fixed = TRUE), # remove these
      Region = gsub(Region, pattern = "–", replacement = "", fixed = TRUE),
      # specific words- mention of wine regions, states or provinces, other words
      Region = gsub(Region, pattern = "wine|region|state|province|and|surrounding|area|of|villiage|continental|grapes|territory|disputed|community|both|in|lima|since|including", replacement = ""), # a specific instance of some regions being referred to as "wine regions"
      Region = gsub(Region, pattern = "[0-9]+", replacement = "", fixed = TRUE), # remove all numbers
      Region = gsub("\\b([[:alpha:]]+)\\b(?:[_[:space:]-]+\\1\\b)+", "\\1", Region, ignore.case = TRUE) # remove all duplicates of words separated by some character
    )

  # add join cols
  IVR_locations <- IVR_locations %>%
    dplyr::mutate(
      join_col_x = round(x, 4),
      join_col_y = round(y, 4) # rounding to the 1000s (1km) place to prevent overly sensitive exclusions for UTM data
    )

  # check for existence of locality name in shapefiles--------------------------

  # data existence check
  # the check if the locality is a country
  if(locality.type == "country") {

    country.name.check <- countries_sf %>%
      dplyr::filter(ADM0_A3 == locality_iso_internal)

      # if at least 1 record, success
    if(nrow(country.name.check) > 0) {
      cli::cli_alert_success("Data exist for locality")

      # if no records, warn
    } else if(nrow(country.name.check) == 0) {
      cli::cli_abort("Data do not exist for locality. Check spelling or try another locality.")
      stop()

    }

    # the check if the locality is a state or province
  } else if(locality.type == "state_province") {
    state.name.check <- states_provinces_sf %>%
      dplyr::filter(name %in% locality_name_internal)

    # if at least 1 record, success
    if(nrow(state.name.check) > 0) {
      cli::cli_alert_success("Data exist for locality")

      # if no records, warn
    } else if(nrow(state.name.check) == 0) {
      cli::cli_abort("Data do not exist for locality. Check spelling or try another locality.")
      stop()

    }

  } else {
    cli::cli_abort("'locality.type' must be one of: 'country' | 'state_province'")
    stop()
  }




  # isolate data for that locality into locality_sf-----------------------------

  # if a country, import country sf
  if(locality.type == "country") {
    locality_sf <- countries_sf %>%
      dplyr::filter(ADM0_A3 == locality_iso_internal, na.rm = TRUE)

    # if the locality is a country, I will also map the provinces on top
    locality_sf_plot_layer <- states_provinces_sf %>%
      dplyr::filter(adm0_a3 == locality_iso_internal, na.rm = TRUE)

    # if a state, import state sf
  } else if(locality.type == "state_province") {
    locality_sf <- states_provinces_sf %>%
      dplyr::filter(name == locality_name_internal, na.rm = TRUE)

  }


  # begin function--------------------------------------------------------------

  ## isolate IVRs for locality--------------------------------------------------

  # create spatvector of locality_sf (this will be used to mask the maps as well)
  locality_sv <- terra::vect(locality_sf)

  # convert to vector
  IVR_locations_masked <- terra::vect(x = IVR_locations, geom = c("x", "y"), crs = crs) %>%
    # crop by extent area of interest
    terra::mask(., mask = locality_sv)

  # separate a copy of this for joining later
  IVR_locations_join_cols <- terra::as.data.frame(IVR_locations_masked)

  # convert to geom, which gets coordinates of a spatVector
  IVR_locations_masked <- IVR_locations_masked %>%
    terra::geom()

  # convert back to data frame
  IVR_locations_plot_layer <- terra::as.data.frame(IVR_locations_masked) %>%
    dplyr::select(-c(geom, part, hole))


  # add join cols for later
  IVR_locations_plot_layer <- cbind(IVR_locations_plot_layer, IVR_locations_join_cols) %>%
    dplyr::select(x, y, join_col_x, join_col_y)

  # will not need this object again
  rm(IVR_locations_masked)


  ## create polygon of buffer zones around IVRs---------------------------------

  # if no buffer zones, just use point-wise predictions
  if (is.na(buffer.dist)) {
    # alert
    cli::cli_alert_info("Suitability prediction type for IVR regions: simple")



    # if buffer zones, use buffer style predictions
  } else if (!is.na(buffer.dist) & is.numeric(buffer.dist)) {
    # alert
    cli::cli_alert_info(paste0("Suitability prediction type for IVR regions: buffer of ", buffer.dist, "m around points"))

    # convert IVR points to spatvector
    IVR_buffers_sv <- terra::vect(
      x = IVR_locations_plot_layer,
      crs = crs,
      geom = c("x", "y")
    )
    # use sv to create buffers
    IVR_buffers_sv <- terra::buffer(
      x = IVR_buffers_sv,
      width = buffer.dist
    )
    # mask buffers using locality sv
    IVR_buffers_sv <- terra::mask(
      x = IVR_buffers_sv,
      mask = locality_sv
    )

    # convert to sf object for plotting
    IVR_buffers_plot_layer <- sf::st_as_sf(IVR_buffers_sv, remove = FALSE)

    # otherwise, stop
  } else {

    cli::cli_abort("Parameter 'buffer.dist' must be of type numeric")
    stop()

  }


  ## plot binarized rasters-----------------------------------------------------

  # first, I will mask these rasters using the locality_sf
  # use the version locality_sv instead for masking

  binarized_hist <- terra::mask(
    x = binarized_hist,
    mask = locality_sv
  )

  binarized_future <- terra::mask(
    x = binarized_future,
    mask = locality_sv
  )



  # rename values
  names(binarized_hist) <- "global_regional_binarized"
  names(binarized_future) <- "global_regional_binarized"

  # convert to df for plotting
  binarized_hist_df <- terra::as.data.frame(binarized_hist, xy = TRUE)
  binarized_future_df <- terra::as.data.frame(binarized_future, xy = TRUE)


  # binarized maps
  # the possible values of the scale and their order
  breaks.obj <- c(5, 9, 6, 10) # I manually ordered these
  # labels for the values
  labels.obj <- c("low", "moderate", "high", "extreme")
  # vector of colors to classify scale
  values.obj <- c("azure4", "gold", "darkorange", "darkred")


  ### present plot

  # plot with state_province layer if plotting at country level
  if(locality.type == "country") {

  binarized_hist_plot <- ggplot() +
    map_style +
    # data layer
    geom_raster(data = binarized_hist_df, aes(x = x, y = y, fill = as.factor(global_regional_binarized))) +
    # add province layer
    geom_sf(data = locality_sf_plot_layer, fill = NA, color = "black", linewidth = 0.3) +
    # fill scale 1
    scale_discrete_manual(
      name = "projected risk",
      values = values.obj,
      breaks = breaks.obj,
      labels = labels.obj,
      aesthetics = "fill",
      guide = guide_colorsteps(frame.colour = "black", ticks.colour = "black", barwidth = 20)
    ) +
    # new scale
    ggnewscale::new_scale_fill()

  # whether or not to plot buffer layer
  if (!is.na(buffer.dist) && nrow(IVR_buffers_plot_layer) > 0) {

    binarized_hist_plot <- binarized_hist_plot +
      # underlying buffer layer
      geom_sf(data = IVR_buffers_plot_layer, aes(fill = "viticultural\narea"), color = "black", alpha = 0.35)

    # otherwise, plot without buffers
  } else if (is.na(buffer.dist)) {
    binarized_hist_plot <- binarized_hist_plot

  }

  binarized_hist_plot <- binarized_hist_plot +
    # points
    geom_point(data = IVR_locations_plot_layer, aes(x = x, y = y, fill = "viticultural\narea"), size = 2.5, shape = 21) +
    # scale bar
    ggspatial::annotation_scale(
      plot_unit = "m", # the unit of the map
      location = "bl",
      width_hint = 0.2,
      text_cex = 0.6,
      pad_x = unit(0.3, "in"),
      pad_y = unit(0.2, "in"),
      style = "bar",                        # classic black-and-white bar
      bar_cols = c("black", "white")        # alternating colors
    ) +
    # fill scale for points
    scale_fill_manual(name = "", values = c("viticultural\narea" = "orchid1")) +
    # aesthetics
    guides(fill = guide_legend(ncol = 1, byrow = TRUE, override.aes = list(size = 3))) +
    # other stuff
    labs(
      title = "Present projected risk of Lycorma delicatula establishment",
      subtitle = paste0(stringr::str_to_title(locality_name_internal), " | ", period.present),
      caption = ifelse(!is.na(buffer.dist), paste0(buffer.dist, "m buffer used for suitability of viticultural areas"), "")
    ) +
    coord_sf(
      datum = crs,
      crs = crs
    )




  # otherwise, plot without a state_province layer
  } else if(locality.type == "state_province") {

    binarized_hist_plot <- ggplot() +
      map_style +
      # data layer
      geom_raster(data = binarized_hist_df, aes(x = x, y = y, fill = as.factor(global_regional_binarized))) +
      # add province layer
      geom_sf(data = locality_sf, fill = NA, color = "black", linewidth = 0.3) +
      # fill scale raster
      scale_discrete_manual(
        name = "projected risk",
        values = values.obj,
        breaks = breaks.obj,
        labels = labels.obj,
        aesthetics = "fill",
        guide = guide_colorsteps(frame.colour = "black", ticks.colour = "black", barwidth = 20)
      ) +
      # new scale
      ggnewscale::new_scale_fill()

    # whether or not to plot buffer layer
    if (!is.na(buffer.dist) && nrow(IVR_buffers_plot_layer) > 0) {

      binarized_hist_plot <- binarized_hist_plot +
        # underlying buffer layer
        geom_sf(data = IVR_buffers_plot_layer, aes(fill = "viticultural\narea"), color = "black", alpha = 0.35)

      # dont plot
    } else if (is.na(buffer.dist)) {
      binarized_hist_plot <- binarized_hist_plot

    }

    binarized_hist_plot <- binarized_hist_plot +
      # IVRs
      geom_point(data = IVR_locations_plot_layer, aes(x = x, y = y, fill = "viticultural\narea"), size = 2.5, shape = 21) +
      # scale bar
      ggspatial::annotation_scale(
        plot_unit = "m", # the unit of the map
        location = "bl",
        width_hint = 0.2,
        text_cex = 0.6,
        pad_x = unit(0.3, "in"),
        pad_y = unit(0.2, "in"),
        style = "bar",                        # classic black-and-white bar
        bar_cols = c("black", "white")        # alternating colors
      ) +
      # fill scale for points
      scale_fill_manual(name = "", values = c("viticultural\narea" = "orchid1")) +
      # aesthetics
      guides(fill = guide_legend(ncol = 1, byrow = TRUE, override.aes = list(size = 3))) +
      # other stuff
      labs(
        title = "Present projected risk of Lycorma delicatula establishment",
        subtitle = paste0(stringr::str_to_title(locality_name_internal), " | ", period.present),
        caption = ifelse(!is.na(buffer.dist), paste0(buffer.dist, "m buffer used for suitability of viticultural areas"), "")
      ) +
      coord_sf(
        datum = crs,
        crs = crs
      )

  }




  ### CMIP6 mean projection

  # plot with state_province layer if plotting at country level
  if(locality.type == "country") {

    binarized_future_plot <- ggplot() +
      map_style +
      # data layer
      geom_raster(data = binarized_future_df, aes(x = x, y = y, fill = as.factor(global_regional_binarized))) +
      # add province layer
      geom_sf(data = locality_sf_plot_layer, fill = NA, color = "black", linewidth = 0.3) +
      # fill scale raster
      scale_discrete_manual(
        name = "projected risk",
        values = values.obj,
        breaks = breaks.obj,
        labels = labels.obj,
        aesthetics = "fill",
        guide = guide_colorsteps(frame.colour = "black", ticks.colour = "black", barwidth = 20)
      ) +
      # new scale
      ggnewscale::new_scale_fill()

    # whether or not to plot buffer layer
    if (!is.na(buffer.dist) && nrow(IVR_buffers_plot_layer) > 0) {

      binarized_future_plot <- binarized_future_plot +
        # underlying buffer layer
        geom_sf(data = IVR_buffers_plot_layer, aes(fill = "viticultural\narea"), color = "black", alpha = 0.35)

    } else if (is.na(buffer.dist)) {
      binarized_future_plot <- binarized_future_plot

    }

    binarized_future_plot <- binarized_future_plot +
      # IVRs
      geom_point(data = IVR_locations_plot_layer, aes(x = x, y = y, fill = "viticultural\narea"), size = 2.5, shape = 21) +
      # scale bar
      ggspatial::annotation_scale(
        plot_unit = "m", # the unit of the map
        location = "bl",
        width_hint = 0.2,
        text_cex = 0.6,
        pad_x = unit(0.3, "in"),
        pad_y = unit(0.2, "in"),
        style = "bar",                        # classic black-and-white bar
        bar_cols = c("black", "white")        # alternating colors
      ) +
      # fill scale for points
      scale_fill_manual(name = "", values = c("viticultural\narea" = "purple3")) +
      # aesthetics
      guides(fill = guide_legend(ncol = 1, byrow = TRUE, override.aes = list(size = 3))) +
      # other stuff
      labs(
        title = "Projected risk of Lycorma delicatula establishment under climate change",
        subtitle = paste(stringr::str_to_title(locality_name_internal), "|", period.projected, "| mean of", ssp.projected, "|", model.projected),
        caption = ifelse(!is.na(buffer.dist), paste0(buffer.dist, "m buffer used for suitability of viticultural areas"), "")
      ) +
      coord_sf(
        datum = crs,
        crs = crs
      )




    # otherwise, plot without a state_province layer
  } else if(locality.type == "state_province") {

    binarized_future_plot <- ggplot() +
      map_style +
      # data layer
      geom_raster(data = binarized_future_df, aes(x = x, y = y, fill = as.factor(global_regional_binarized))) +
      # add province layer
      geom_sf(data = locality_sf, fill = NA, color = "black", linewidth = 0.3) +
      # fill scale raster
      scale_discrete_manual(
        name = "projected risk",
        values = values.obj,
        breaks = breaks.obj,
        labels = labels.obj,
        aesthetics = "fill",
        guide = guide_colorsteps(frame.colour = "black", ticks.colour = "black", barwidth = 20)
      ) +
      # new scale
      ggnewscale::new_scale_fill()


    # whether or not to plot buffer layer
    if (!is.na(buffer.dist) && nrow(IVR_buffers_plot_layer) > 0) {

      binarized_future_plot <- binarized_future_plot +
        # underlying buffer layer
        geom_sf(data = IVR_buffers_plot_layer, aes(fill = "viticultural\narea"), color = "black", alpha = 0.35)

    } else if (is.na(buffer.dist)) {
      binarized_future_plot <- binarized_future_plot

    }


    binarized_future_plot <- binarized_future_plot +
      # IVRs
      geom_point(data = IVR_locations_plot_layer, aes(x = x, y = y, fill = "viticultural\narea"), size = 2.5, shape = 21) +
      # scale bar
      ggspatial::annotation_scale(
        plot_unit = "m", # the unit of the map
        location = "bl",
        width_hint = 0.2,
        text_cex = 0.6,
        pad_x = unit(0.3, "in"),
        pad_y = unit(0.2, "in"),
        style = "bar",                        # classic black-and-white bar
        bar_cols = c("black", "white")        # alternating colors
      ) +
      # fill scale for points
      scale_fill_manual(name = "", values = c("viticultural\narea" = "purple3")) +
      # aesthetics
      guides(fill = guide_legend(ncol = 1, byrow = TRUE, override.aes = list(size = 3))) +
      # other stuff
      labs(
        title = "Projected risk of Lycorma delicatula establishment under climate change",
        subtitle = paste(stringr::str_to_title(locality_name_internal), "|", period.projected, "| mean of", ssp.projected, "|", model.projected),
        caption = ifelse(!is.na(buffer.dist), paste0(buffer.dist, "m buffer used for suitability of viticultural areas"), "")
      ) +
      coord_sf(
        datum = crs,
        crs = crs
      )

  }



  # success message
  cli::cli_alert_success("Risk maps plotted")

  ## plot lead/trailing edge map------------------------------------------------

  # first, mask rasters
    range_shift <- terra::mask(
      x = range_shift,
      mask = locality_sv
    )



  # rename values
  names(range_shift) <- "range_shift_summed"
  # convert to df
  range_shift_df <- terra::as.data.frame(range_shift, xy = TRUE)


  # now, create vectors of values used to manually edit the scale of the plot
  # the possible values of the scale and their order
  breaks.obj2 <- c(5, 10, 6, 9) # i manually ordered these
  # labels for the values
  labels.obj2 <- c("unsuitable area\nretained", "suitabile area\nretained", "contraction\nof suitable area", "expansion\nof suitable area")
  # vector of colors to classify scale
  values.obj2 <- c("azure4", "azure", "darkblue", "darkgreen")



  # if the locality is a country
  if(locality.type == "country") {

  range_shift_plot <- ggplot() +
    map_style +
    # data layer
    geom_raster(data = range_shift_df, aes(x = x, y = y, fill = as.factor(range_shift_summed))) +
    # add province layer
    geom_sf(data = locality_sf_plot_layer, fill = NA, color = "black", linewidth = 0.3) +
    # fill scale
    scale_discrete_manual(
      name = "suitability for\nL delicatula",
      values = values.obj2,
      breaks = breaks.obj2,
      labels = labels.obj2,
      aesthetics = "fill",
      guide = guide_colorsteps(frame.colour = "black", ticks.colour = "black", barwidth = 20)
    ) +
    # new fill scale
    ggnewscale::new_scale_fill() +
    # IVR regions
    geom_point(data = IVR_locations_plot_layer, aes(x = x, y = y, fill = "viticultural\narea"), size = 2.5, shape = 21) +
    # scale bar
    ggspatial::annotation_scale(
      plot_unit = "m", # the unit of the map
      location = "bl",
      width_hint = 0.2,
      text_cex = 0.6,
      pad_x = unit(0.3, "in"),
      pad_y = unit(0.2, "in"),
      style = "bar",                        # classic black-and-white bar
      bar_cols = c("black", "white")        # alternating colors
    ) +
    # fill scale for points
    scale_fill_manual(name = "", values = c("viticultural\narea" = "purple3")) +
    # aesthetics
    guides(fill = guide_legend(ncol = 2, byrow = TRUE, override.aes = list(size = 3))) +
    # other stuff
    labs(
      title = "Projected areas suitable for Lycorma delicatula range expansion",
      subtitle = paste0(stringr::str_to_title(locality_name_internal), " | ", period.present, " and ", period.projected)
    ) +
    theme(legend.title = element_text(hjust = 1)) +
    coord_sf(
      datum = crs,
      crs = crs
    )


  # otherwise, plot without a state_province layer
  } else if(locality.type == "state_province") {

    range_shift_plot <- ggplot() +
      map_style +
      # data layer
      geom_raster(data = range_shift_df, aes(x = x, y = y, fill = as.factor(range_shift_summed))) +
      # add province layer
      geom_sf(data = locality_sf, fill = NA, color = "black", linewidth = 0.3) +
      # fill scale
      scale_discrete_manual(
        name = stringr::str_wrap("suitability for L delicatula"),
        values = values.obj2,
        breaks = breaks.obj2,
        labels = labels.obj2,
        aesthetics = "fill",
        guide = guide_colorsteps(frame.colour = "black", ticks.colour = "black", barwidth = 20)
      ) +
      # new fill scale
      ggnewscale::new_scale_fill() +
      # IVR regions
      geom_point(data = IVR_locations_plot_layer, aes(x = x, y = y, fill = "viticultural\narea"), size = 2.5, shape = 21) +
      # scale bar
      ggspatial::annotation_scale(
        plot_unit = "m", # the unit of the map
        location = "bl",
        width_hint = 0.2,
        text_cex = 0.6,
        pad_x = unit(0.3, "in"),
        pad_y = unit(0.2, "in"),
        style = "bar",                        # classic black-and-white bar
        bar_cols = c("black", "white")        # alternating colors
      ) +
      # fill scale for points
      scale_fill_manual(name = "", values = c("viticultural\narea" = "purple3")) +
      # aesthetics
      guides(fill = guide_legend(ncol = 2, byrow = TRUE, override.aes = list(size = 3))) +
      # other stuff
      labs(
        title = "Projected areas suitable for Lycorma delicatula range expansion",
        subtitle = paste0(stringr::str_to_title(locality_name_internal), " | ", period.present, " and ", period.projected)
      ) +
      theme(legend.title = element_text(hjust = 1)) +
      coord_sf(
        datum = crs,
        crs = crs
      )

  }

  # success message
  cli::cli_alert_success("Range shift map plotted")




  ## return IVR_locations selected for locality---------------------------------

  # filter out locations that match plot layer
  IVR_locations_locality <-  dplyr::semi_join(IVR_locations, IVR_locations_plot_layer, by = c("join_col_x", "join_col_y"))



  ## plot scatter plot of IVRs--------------------------------------------------

  ### tidy data-----------------------------------------------------------------

  # add join cols
  xy_global_hist <- xy_global_hist %>%
    dplyr::mutate(
      join_col_x = round(x, 4),
      join_col_y = round(y, 4) # rounding to the 1000s (1km) place to prevent overly sensitive exclusions for UTM data
    ) %>%
    dplyr::select(-c(x, y)) %>%
    dplyr::relocate(join_col_x, join_col_y, .after = ID)


  xy_global_future <- xy_global_future %>%
    dplyr::mutate(
      join_col_x = round(x, 4),
      join_col_y = round(y, 4) # rounding to the 1000s (1km) place to prevent overly sensitive exclusions for UTM data
    ) %>%
    dplyr::select(-c(x, y)) %>%
    dplyr::relocate(join_col_x, join_col_y, .after = ID)


  xy_regional_ensemble_hist <- xy_regional_ensemble_hist %>%
    dplyr::mutate(
      join_col_x = round(x, 4),
      join_col_y = round(y, 4) # rounding to the 1000s (1km) place to prevent overly sensitive exclusions for UTM data
    ) %>%
    dplyr::select(-c(x, y)) %>%
    dplyr::relocate(join_col_x, join_col_y, .after = ID)


  xy_regional_ensemble_future <- xy_regional_ensemble_future %>%
    dplyr::mutate(
      join_col_x = round(x, 4),
      join_col_y = round(y, 4) # rounding to the 1000s (1km) place to prevent overly sensitive exclusions for UTM data
    ) %>%
    dplyr::select(-c(x, y)) %>%
    dplyr::relocate(join_col_x, join_col_y, .after = ID)


  ### rescale data--------------------------------------------------------------

  # apply internal function rescale_cloglog_suitability
  xy_global_hist_rescaled <- scari::rescale_cloglog_suitability(
    xy.predicted = xy_global_hist,
    thresh = "MTSS",
    exponential.file = threshold_exponential_values,
    summary.file = summary_global,
    rescale.name = "xy_global_hist",
    rescale.thresholds = TRUE
  )
  # separate data from thresholds
  xy_global_hist_rescaled_thresholds <- xy_global_hist_rescaled[[2]]
  xy_global_hist_rescaled <- xy_global_hist_rescaled[[1]]


  xy_global_future_rescaled <- scari::rescale_cloglog_suitability(
    xy.predicted = xy_global_future,
    thresh = "MTSS",  # the global model only has 1 MTSS thresh
    exponential.file = threshold_exponential_values,
    summary.file = summary_global,
    rescale.name = "xy_global_future",
    rescale.thresholds = TRUE
  )

  xy_global_future_rescaled_thresholds <- xy_global_future_rescaled[[2]]
  xy_global_future_rescaled <- xy_global_future_rescaled[[1]]



  xy_regional_ensemble_hist_rescaled <- scari::rescale_cloglog_suitability(
    xy.predicted = xy_regional_ensemble_hist,
    thresh = "MTSS",
    exponential.file = threshold_exponential_values,
    summary.file = summary_regional_ensemble,
    rescale.name = "xy_regional_ensemble_hist",
    rescale.thresholds = TRUE
  )

  xy_regional_ensemble_hist_rescaled_thresholds <- xy_regional_ensemble_hist_rescaled[[2]]
  xy_regional_ensemble_hist_rescaled <- xy_regional_ensemble_hist_rescaled[[1]]



  xy_regional_ensemble_future_rescaled <- suppressWarnings(
    scari::rescale_cloglog_suitability(
      xy.predicted = xy_regional_ensemble_future,
      thresh = "MTSS.CC", # the way the thresholds are calculated for the regional_ensemble model means that the threshold will be slightly different for climate change
      exponential.file = threshold_exponential_values,
      summary.file = summary_regional_ensemble,
      rescale.name = "xy_regional_ensemble_future",
      rescale.thresholds = TRUE
    )
  )

  xy_regional_ensemble_future_rescaled_thresholds <- xy_regional_ensemble_future_rescaled[[2]]
  xy_regional_ensemble_future_rescaled <- xy_regional_ensemble_future_rescaled[[1]]


  ### join datasets--------------------------------------------------------------

  # join datasets for plotting
  xy_joined_rescaled <-  dplyr::full_join(xy_global_hist_rescaled, xy_regional_ensemble_hist_rescaled, by = c("ID", "join_col_x", "join_col_y")) %>%
    # join CC datasets
    dplyr::full_join(., xy_global_future_rescaled, by = c("ID", "join_col_x", "join_col_y")) %>%
    dplyr::full_join(., xy_regional_ensemble_future_rescaled, by = c("ID", "join_col_x", "join_col_y")) %>%
    # order
    dplyr::relocate(ID, join_col_x, join_col_y, xy_global_hist_rescaled, xy_global_future_rescaled) %>%
    dplyr::select(-c(xy_global_hist, xy_global_future, xy_regional_ensemble_hist, xy_regional_ensemble_future))


  # filter out only records from locality
  xy_joined_rescaled <- dplyr::semi_join(xy_joined_rescaled, IVR_locations_locality, by = c("ID", "join_col_x", "join_col_y"))





  ### isolate thresholds---------------------------------------------------------

  # global
  global_MTSS <- as.numeric(xy_global_hist_rescaled_thresholds[2, 2])
  # regional ensemble
  regional_ensemble_MTSS_hist <- as.numeric(xy_regional_ensemble_hist_rescaled_thresholds[2, 2])
  regional_ensemble_MTSS_future <- as.numeric(xy_regional_ensemble_future_rescaled_thresholds[4, 2])






  ### find points that cross threshold------------------------------------------

  xy_joined_rescaled_intersects <- xy_joined_rescaled %>%
    dplyr::mutate(
      crosses_threshold =  dplyr::case_when(
        # conditional for starting and ending points that overlap a the threshold
        # x-axis
        xy_global_hist_rescaled > global_MTSS & xy_global_future_rescaled < global_MTSS ~ "crosses",
        xy_global_hist_rescaled < global_MTSS & xy_global_future_rescaled > global_MTSS ~ "crosses",
        # y-axis
        xy_regional_ensemble_hist_rescaled > regional_ensemble_MTSS_future & xy_regional_ensemble_future_rescaled < regional_ensemble_MTSS_future ~ "crosses",
        xy_regional_ensemble_hist_rescaled < regional_ensemble_MTSS_future & xy_regional_ensemble_future_rescaled > regional_ensemble_MTSS_future ~ "crosses",
        # else
        .default = "does not cross"
      )
    )

  # filter out the crosses
  xy_joined_rescaled_intersects <- dplyr::filter(
    xy_joined_rescaled_intersects,
    crosses_threshold == "crosses"
  )




  ### plot data-----------------------------------------------------------------


  # figure annotation title
  # "Risk of Lycorma delicatula establishment in globally important viticultural areas, projected for climate change"

  # plot
  xy_joined_rescaled_plot <- ggplot(data = xy_joined_rescaled) +
    # threshold lines
     # MTSS thresholds
     geom_vline(xintercept = global_MTSS, linetype = "dashed", linewidth = 0.7) + # global
     geom_hline(yintercept = regional_ensemble_MTSS_hist, linetype = "dashed", linewidth = 0.7) + # regional_ensemble- there are two MTSS thresholds for this model, but the difference is so small that you will never see it on the plot
     # arrows indicating change
     geom_segment(
       data = xy_joined_rescaled_intersects,
       aes(
         x = xy_global_hist_rescaled,
         xend = xy_global_future_rescaled,
         y = xy_regional_ensemble_hist_rescaled,
         yend = xy_regional_ensemble_future_rescaled
       ),
       arrow = grid::arrow(angle = 5.5, type = "closed"), alpha = 0.3, linewidth = 0.25, color = "black"
     ) +
     # historical data
     geom_point(
       aes(x = xy_global_hist_rescaled, y = xy_regional_ensemble_hist_rescaled, shape = "Present"),
       size = 2, stroke = 0.7, color = "black", fill = "orchid1"
     ) +
     # future data
     geom_point(
       aes(x = xy_global_future_rescaled, y = xy_regional_ensemble_future_rescaled, shape = paste0("Future | ", model.projected, "\nmean of ", ssp.projected)),
       size = 2, stroke = 0.7, color = "black", fill = "purple3"
     ) +
     # axes scaling
     scale_x_continuous(name = "'global' model risk projection", limits = c(0, 1), breaks = breaks, labels = labels) +
     scale_y_continuous(name = "'regional_ensemble' model risk projection", limits = c(0, 1), breaks = breaks, labels = labels) +
     # quadrant labels
     # extreme risk, top right, quad4
     annotate("label", x = 0.75, y = 0.9, label = "extreme risk", fill = "darkred", color = "azure", size = 5) +
     # high risk, top left, quad3
     annotate("label", x = 0.25, y = 0.9, label = "high risk", fill = "darkorange", color = "azure", size = 5) +
     # moderate risk, bottom right, quad2
     annotate("label", x = 0.75, y = 0.1, label = "moderate risk", fill = "gold", color = "azure", size = 5) +
     # low risk, bottom left, quad1
     annotate("label", x = 0.25, y = 0.1, label = "low risk", fill = "azure4", color = "azure", size = 5) +
     # aesthetics
     scale_shape_manual(name = "Time period", values = c(21, 21)) +
     guides(shape = guide_legend(nrow = 1, override.aes = list(size = 2.5), reverse = TRUE)) +
     theme_bw() +
     theme(legend.position = "bottom", panel.grid.major = element_blank(), panel.grid.minor = element_blank()) +
     coord_fixed(ratio = 1) +
    labs(
      title = "Projected shift in the risk for Lycorma delicatula establishment at key viticultural regions due to climate change",
      subtitle = paste0(stringr::str_to_title(locality_name_internal), ": important viticultural regions"),
      caption = paste0("arrows indicate a region is crossing a risk threshold (dashed lines, MTSS thresh)", ifelse(!is.na(buffer.dist), paste0("\n", buffer.dist, "m buffer used for suitability of viticultural areas"), ""))
    )


  # success message
  cli::cli_alert_success("Viticultural risk plot created")

  ## create IVR summary table---------------------------------------------------

  # join rescaled suitability values with IVR locations
  IVR_locations_joined <- dplyr::left_join(IVR_locations_locality, xy_joined_rescaled, by = c("ID", "join_col_x", "join_col_y")) %>%
    dplyr::relocate(ID, x, y)


  # calculate risk quadrants
  IVR_locations_risk <- IVR_locations_joined %>%
    dplyr::mutate(
      risk_hist = scari::calculate_risk_quadrant(
        suit.x = IVR_locations_joined$xy_global_hist_rescaled,
        suit.y = IVR_locations_joined$xy_regional_ensemble_hist_rescaled,
        thresh.x = global_MTSS, # this threshold remains the same
        thresh.y = regional_ensemble_MTSS_hist
      ),
      risk_future = scari::calculate_risk_quadrant(
        suit.x = IVR_locations_joined$xy_global_future_rescaled,
        suit.y = IVR_locations_joined$xy_regional_ensemble_future_rescaled,
        thresh.x = global_MTSS,
        thresh.y = regional_ensemble_MTSS_future
      ),
      risk_shift = str_c(risk_hist, risk_future, sep = "-")
    )


  # create risk table
  IVR_risk_table <- IVR_locations_risk %>%
    # ensure columns are character
    dplyr::mutate(
      risk_hist = as.character(risk_hist),
      risk_future = as.character(risk_future)
    ) %>%
    # create counts and make into acrostic table
    dplyr::group_by(risk_hist, risk_future) %>%
    dplyr::summarize(count = dplyr::n()) %>%
    tidyr::pivot_wider(names_from = risk_future, values_from = count) %>%
    dplyr::ungroup()

  # add columns that do not exist
  if(!'extreme' %in% names(IVR_risk_table)) IVR_risk_table <- IVR_risk_table %>% tibble::add_column(extreme = 0)
  if(!'high' %in% names(IVR_risk_table)) IVR_risk_table <- IVR_risk_table %>% tibble::add_column(high = 0)
  if(!'moderate' %in% names(IVR_risk_table)) IVR_risk_table <- IVR_risk_table %>% tibble::add_column(moderate = 0)
  if(!'low' %in% names(IVR_risk_table)) IVR_risk_table <- IVR_risk_table %>% tibble::add_column(low = 0)

  # ensure all combinations of risk exist
  if(!'extreme' %in% IVR_risk_table$risk_hist) IVR_risk_table <- IVR_risk_table %>% tibble::add_row(risk_hist = "extreme", extreme = 0, high = 0, moderate = 0, low = 0)
  if(!'high' %in% IVR_risk_table$risk_hist) IVR_risk_table <- IVR_risk_table %>% tibble::add_row(risk_hist = "high", extreme = 0, high = 0, moderate = 0, low = 0)
  if(!'moderate' %in% IVR_risk_table$risk_hist) IVR_risk_table <- IVR_risk_table %>% tibble::add_row(risk_hist = "moderate", extreme = 0, high = 0, moderate = 0, low = 0)
  if(!'low' %in% IVR_risk_table$risk_hist) IVR_risk_table <- IVR_risk_table %>% tibble::add_row(risk_hist = "low", extreme = 0, high = 0, moderate = 0, low = 0)

  # tidy
  IVR_risk_table <- IVR_risk_table %>%
    dplyr::rename("rows_hist_cols_future" = "risk_hist") %>%
    dplyr::relocate("rows_hist_cols_future", "extreme", "high", "moderate") %>%
    dplyr::arrange(factor(.$rows_hist_cols_future, levels = risk_levels)) %>%
    # replace missing categories with 0
    replace(is.na(.), 0)

  # more tidying
  # add totals row and column
  IVR_risk_table <- IVR_risk_table %>%
    tibble::add_column("total_present" = rowSums(dplyr::select(., 2:5))) %>%
    tibble::add_row(rows_hist_cols_future = "total_future", extreme = colSums(dplyr::select(., 2)), high = colSums(dplyr::select(., 3)), moderate = colSums(dplyr::select(., 4)), low = colSums(dplyr::select(., 5)), total_present = nrow(IVR_locations_locality)) %>%
    as.data.frame()

  # edit column of rownames
  IVR_risk_table[1:4, 1] <- str_c(IVR_risk_table[1:4, 1], "present", sep = "_")
  # add rownames
  rownames(IVR_risk_table) <- IVR_risk_table[, 1]
  # get rid of names column
  IVR_risk_table <- dplyr::select(IVR_risk_table, -rows_hist_cols_future)
  # edit column names
  IVR_risk_table <- dplyr::rename(
    IVR_risk_table,
    "extreme_future" = "extreme",
    "high_future" = "high",
    "moderate_future" = "moderate",
    "low_future" = "low"
  )


  # begin formatting
  # add negative sign to top half
  IVR_risk_table[1, 2] <- -(IVR_risk_table[1, 2])
  IVR_risk_table[1:2, 3] <- -(IVR_risk_table[1:2, 3])
  IVR_risk_table[1:3, 4] <- -(IVR_risk_table[1:3, 4])

  # add positive sign to bottom half
  IVR_risk_table[2:4, 1] <- sprintf("%+.0f", IVR_risk_table[2:4, 1])
  IVR_risk_table[3:4, 2] <- sprintf("%+.0f", IVR_risk_table[3:4, 2])
  IVR_risk_table[4, 3] <- sprintf("%+.0f", IVR_risk_table[4, 3])

  # add color formatting to totals
  # extreme risk
  IVR_risk_table[1, 5] <- cell_spec(IVR_risk_table[1, 5], format = "html", bold = TRUE, escape = FALSE, color = "darkred")
  IVR_risk_table[5, 1] <- cell_spec(IVR_risk_table[5, 1], format = "html", bold = TRUE, escape = FALSE, color = "darkred")
  # high risk
  IVR_risk_table[2, 5] <- cell_spec(IVR_risk_table[2, 5], format = "html", bold = TRUE, escape = FALSE, color = "darkorange")
  IVR_risk_table[5, 2] <- cell_spec(IVR_risk_table[5, 2], format = "html", bold = TRUE, escape = FALSE, color = "darkorange")
  # moderate risk
  IVR_risk_table[3, 5] <- cell_spec(IVR_risk_table[3, 5], format = "html", bold = TRUE, escape = FALSE, color = "gold")
  IVR_risk_table[5, 3] <- cell_spec(IVR_risk_table[5, 3], format = "html", bold = TRUE, escape = FALSE, color = "gold")
  # low risk
  IVR_risk_table[4, 5] <- cell_spec(IVR_risk_table[4, 5], format = "html", bold = TRUE, escape = FALSE, color = "darkgrey")
  IVR_risk_table[5, 4] <- cell_spec(IVR_risk_table[5, 4], format = "html", bold = TRUE, escape = FALSE, color = "darkgrey")

  # bold total
  IVR_risk_table[5, 5] <- cell_spec(IVR_risk_table[5, 5], format = "html", bold = TRUE, escape = FALSE)


  # print table, e.g., in html format
  IVR_risk_kable <- knitr::kable(IVR_risk_table, "html", escape = FALSE) %>%
    kableExtra::kable_styling(bootstrap_options = "striped", full_width = FALSE) %>%
    # standardize col width
    kableExtra::column_spec(1:5, width_min = '4cm') %>%
    # add footnotes
    # footnote on time period of predictions
    kableExtra::add_footnote(paste0("future risk calculated for period ", period.projected), notation = "alphabet") %>%
    kableExtra::add_footnote(paste0("present risk calculated for period ", period.present), notation = "alphabet") %>%
    kableExtra::add_footnote("number signs indicate whether climate change is increasing or decreasing risk", notation = "alphabet") %>%
    # styling
    kableExtra::add_header_above(., header = c("Risk of L delicatula establishment for important viticultural regions" = 6), bold = TRUE)  %>%
    # conditional addition of footnote about buffer area
    kableExtra::add_footnote(ifelse(!is.na(buffer.dist), paste0(buffer.dist, "m buffer used for suitability of viticultural areas"), ""), notation = "alphabet")



  # success message
  cli::cli_alert_success("Viticultural regions list created")


  ## create risk area table-----------------------------------------------------

  # use terra::expanse to calculate predicted area presently and under climate change
  # hist
  model_prop_table_hist <- suppressWarnings(
    terra::expanse(
      x = binarized_hist,
      unit = "km",
      byValue = TRUE
    )
    ) # terra expanse tends to tell me that the UTM projections dont work when they do, so I silenced this warning

  # future
  model_prop_table_future_ssp_mean <- suppressWarnings(
    terra::expanse(
      x = binarized_future,
      unit = "km",
      byValue = TRUE
    )
    )

  # create object to help join risk levels with terra expanse
  categories.obj <- tibble::tibble(
    model_suitability = c("unsuitable_agreement", "regional", "global", "suitable_agreement"),
    value = c(5, 6, 9, 10)
  )

  # join
  model_prop_table_joined <- dplyr::left_join(model_prop_table_hist, model_prop_table_future_ssp_mean, by = c("value", "layer")) %>%
    # add labels
    dplyr::left_join(., categories.obj, by = "value")


  # tidy
  model_prop_table_joined <- model_prop_table_joined %>%
    dplyr::select(-c(layer, value)) %>%
    dplyr::rename(
      "area_km_hist" = "area.x",
      "area_km_future" = "area.y"
    ) %>%
    dplyr::mutate(
      # calculate proportions of total area
      prop_total_area_hist = scales::label_percent()(area_km_hist / sum(area_km_hist)),
      prop_total_area_future = scales::label_percent()(area_km_future / sum(area_km_future)),
      # change formatting
      area_km_hist = scales::label_comma()(area_km_hist),
      area_km_future = scales::label_comma()(area_km_future)
    ) %>%
    dplyr::relocate(model_suitability, area_km_hist, prop_total_area_hist, area_km_future, prop_total_area_future) %>%
    dplyr::rename(
      "prop_area_future" = "prop_total_area_future",
      "prop_area_present" = "prop_total_area_hist"
    )

  # add superscript
  colnames(model_prop_table_joined)[2] <- paste0("area_km", common::supsc("2"), "_present")
  colnames(model_prop_table_joined)[4] <- paste0("area_km", common::supsc("2"), "_future")

  # .html formatting
  # format row colors
  model_prop_table_joined[1, 1] <- kableExtra::cell_spec(model_prop_table_joined[1, 1], format = "html", bold = TRUE, escape = FALSE, color = "azure4")
  model_prop_table_joined[2, 1] <- kableExtra::cell_spec(model_prop_table_joined[2, 1], format = "html", bold = TRUE, escape = FALSE, color = "darkorange")
  model_prop_table_joined[3, 1] <- kableExtra::cell_spec(model_prop_table_joined[3, 1], format = "html", bold = TRUE, escape = FALSE, color = "gold")
  model_prop_table_joined[4, 1] <- kableExtra::cell_spec(model_prop_table_joined[4, 1], format = "html", bold = TRUE, escape = FALSE, color = "darkred")

  # convert to kable
  model_prop_kable <- knitr::kable(x = model_prop_table_joined, format = "html", escape = FALSE) %>%
    kableExtra::kable_styling(bootstrap_options = "striped", full_width = TRUE) %>%
    # footnotes
    kableExtra::add_footnote(paste0("present risk calculated for period ", period.present), notation = "alphabet") %>%
    kableExtra::add_footnote(paste0("future areas at risk calculated for period ", period.projected), notation = "alphabet")


  # success message
  cli::cli_alert_success("Risk map proportional areas table created")




  ## create range shift table---------------------------------------------------

  # use terra expanse to calculate suitable area
  range_shift_table <- suppressWarnings(
    terra::expanse(
      x = range_shift,
      unit = "km",
      byValue = TRUE
    )
    )


  # naming object
  range.tibble <- tibble::tibble(
    Ld_range_shift_type = c("remains_unsuitable", "contraction", "expansion", "retained_suitability"),
    value = c(5, 6, 9, 10)
  )


  #tidying
  # add rows
  range_shift_table <-  range_shift_table %>%
    dplyr::left_join(., range.tibble, by = "value")

  # conditional to add missing categories
  if(!'remains_unsuitable' %in% range_shift_table$Ld_range_shift_type) range_shift_table <- range_shift_table %>% tibble::add_row(layer = 1, value = 5, area = 0, Ld_range_shift_type = "remains_unsuitable")
  if(!'contraction' %in% range_shift_table$Ld_range_shift_type) range_shift_table <- range_shift_table %>% tibble::add_row(layer = 1, value = 6, area = 0, Ld_range_shift_type = "contraction")
  if(!'expansion' %in% range_shift_table$Ld_range_shift_type) range_shift_table <- range_shift_table %>% tibble::add_row(layer = 1, value = 9, area = 0, Ld_range_shift_type = "expansion")
  if(!'retained_suitability' %in% range_shift_table$Ld_range_shift_type) range_shift_table <- range_shift_table %>% tibble::add_row(layer = 1, value = 10, area = 0, Ld_range_shift_type = "retained_suitability")


  # more tidying
  range_shift_table <- range_shift_table %>%
    dplyr::mutate(
      prop_total_area = scales::label_percent()(area / sum(area)),
      area = scales::label_comma()(area)
      ) %>%
    dplyr::select(-c(value, layer)) %>%
    dplyr::relocate(Ld_range_shift_type, area) %>%
    replace(is.na(.), 0)

  # EVEN MORE tidying
  # add superscript
  colnames(range_shift_table)[2] <- paste0("area_km", common::supsc("2"))

  # .html formatting
  # format row colors
  range_shift_table <- range_shift_table %>%
    dplyr::mutate(Ld_range_shift_type = kableExtra::cell_spec(Ld_range_shift_type, format = "html", escape = FALSE, bold = TRUE, background = dplyr::case_when(
      Ld_range_shift_type == "remains_unsuitable" ~ "azure4",
      Ld_range_shift_type == "contraction" ~ "blue",
      Ld_range_shift_type == "expansion" ~ "darkgreen",
      Ld_range_shift_type == "retained_suitability" ~ "azure"
    )
    ))

  # convert to kable
  range_shift_kable <- knitr::kable(x = range_shift_table, format = "html", escape = FALSE) %>%
    # standardize col width
    kableExtra::column_spec(1:3, width_min = '4cm') %>%
    # styling
    kableExtra::kable_styling(bootstrap_options = "striped", full_width = FALSE) %>%
    # footnote on time period
    kableExtra::add_footnote(paste0("present risk calculated for period ", period.present), notation = "alphabet") %>%
    kableExtra::add_footnote(paste0("future areas at risk calculated for period ", period.projected), notation = "alphabet")



  # success message
  cli::cli_alert_success("Range shift area table created")




  # format IVR table------------------------------------------------------------

  ## create .csv output
  IVR_locations_output <- IVR_locations_locality %>%
    # join rescaled suitability values
    dplyr::left_join(., xy_joined_rescaled, by = c("ID", "join_col_x", "join_col_y")) %>%
    # round to 2 decimal places
    dplyr::mutate(
      xy_global_hist_rescaled = round((xy_global_hist_rescaled * 10), 2),
      xy_regional_ensemble_hist_rescaled = round((xy_regional_ensemble_hist_rescaled * 10), 2),
      xy_global_future_rescaled = round((xy_global_future_rescaled * 10), 2),
      xy_regional_ensemble_future_rescaled = round((xy_regional_ensemble_future_rescaled * 10), 2)
    )


  ## tidy IVR_locations_risk to join with IVR_locations_output
  IVR_locations_risk_join <- dplyr::select(IVR_locations_risk, join_col_x, join_col_y, ID, risk_hist, risk_future, risk_shift)
  ## join IVR_locations_risk with IVR_locations_output
  IVR_locations_output <- dplyr::left_join(IVR_locations_output, IVR_locations_risk_join, by = c("ID", "join_col_x", "join_col_y")) %>%
    # mutate to also add count of risk levels for quantification and statistics
    # extreme = 4, high = 3, moderate = 2, low = 1
    # risk_shift_count = risk_future_count - risk_hist_count
    dplyr::mutate(
      risk_hist_count = dplyr::case_when(
        risk_hist == "extreme" ~ 4,
        risk_hist == "high" ~ 3,
        risk_hist == "moderate" ~ 2,
        risk_hist == "low" ~ 1
      ),
      risk_future_count = dplyr::case_when(
        risk_future == "extreme" ~ 4,
        risk_future == "high" ~ 3,
        risk_future == "moderate" ~ 2,
        risk_future == "low" ~ 1
      ),
      risk_shift_count = risk_future_count - risk_hist_count
    ) %>%
    dplyr::select(-c(join_col_x, join_col_y)) # remove join cols

  # rename columns
  IVR_locations_output <- IVR_locations_output %>%
    dplyr::rename(
      "global_model_risk_present" = "xy_global_hist_rescaled",
      "regional_ensemble_model_risk_present" = "xy_regional_ensemble_hist_rescaled",
      "global_model_risk_future" = "xy_global_future_rescaled",
      "regional_ensemble_model_risk_future" = "xy_regional_ensemble_future_rescaled",
      "risk_level_present" = "risk_hist",
      "risk_level_future" = "risk_future",
      "risk_count_present" = "risk_hist_count",
      "risk_count_future" = "risk_future_count"
    ) %>%
    # rearrange columns
    dplyr::relocate(risk_count_present, .after = risk_level_present) %>%
    dplyr::relocate(risk_count_future, .after = risk_level_future) %>%
    dplyr::relocate(risk_shift_count, .after = risk_shift)


  # format as .html
  IVR_locations_output_kable <- knitr::kable(IVR_locations_output, "html", escape = FALSE) %>%
    kableExtra::kable_styling(bootstrap_options = "striped", full_width = FALSE) %>%
    kableExtra::add_header_above(., header = c("L delicatula risk to important viticultural regions" = 17), bold = TRUE)

  # success message
  cli::cli_alert_success("Viticultural risk table created")



  ## create report--------------------------------------------------------------

  risk_report <- list(
    # tibble of info on the report
    "Report_info" = tibble::tibble(
      "Report_data" = c("Report prepared for species:", "Locality Name:", "Locality Type:", "Time period of present risk based on historical data:", "Time period of future risk projection:", "CMIP6 model used for future risk projection:", "SSP scenarios included:"),
      "value" = c(focal.species, stringr::str_to_title(locality_name_internal), stringr::str_to_title(locality.type), period.present, period.projected, model.projected, ssp.projected)
    ),
    "viticultural_regions_list" = IVR_locations_output_kable,
    "risk_maps" = list(
      "present_risk_map" = binarized_hist_plot,
      "future_risk_map" = binarized_future_plot
    ),
    "risk_maps_prop_area_table" = model_prop_kable,
    "viticultural_risk_plot" = xy_joined_rescaled_plot,
    "viticultural_risk_table" = IVR_risk_kable,
    "range_shift_map" = range_shift_plot,
    "range_shift_table" = range_shift_kable
  )

  # success message
  cli::cli_alert_success("Report created")


  ## return report and save if save.report = TRUE-------------------------------

  # output into global env
  assign(paste0(locality_name_internal, "_", focal.species, "_risk_report"), risk_report, envir = .GlobalEnv)


  if(save.report == TRUE) {

    # check if directory exists
    if(dir.exists(mypath) == FALSE) {

      cli::cli_abort(paste0("Report output could not be saved because directory does not exist:\n", mypath))
      stop()
    }

    # save files

    ## IVR list
    readr::write_csv(IVR_locations_output, file = file.path(mypath, paste0(locality_name_internal, "_", focal.species , "_report_viticultural_regions_list.csv")))

    ## risk maps----------------------------------------------------------------
    suppressWarnings(ggsave(
      binarized_hist_plot,
      filename = file.path(mypath, paste0(locality_name_internal, "_", focal.species, "_report_risk_map_present.jpg")),
      height = 8,
      width = 10,
      device = jpeg,
      dpi = "retina"
    ))
    suppressWarnings(ggsave(
      binarized_future_plot,
      filename = file.path(mypath, paste0(locality_name_internal, "_", focal.species, "_report_risk_map_", period.projected, "_", ssp.projected, "_", model.projected, ".jpg")),
      height = 8,
      width = 10,
      device = jpeg,
      dpi = "retina"
    ))

    # range shift map-----------------------------------------------------------
    suppressWarnings(ggsave(
      range_shift_plot,
      filename = file.path(mypath, paste0(locality_name_internal, "_", focal.species, "_report_range_shift_map_", period.projected, "_", ssp.projected, "_", model.projected, ".jpg")),
      height = 8,
      width = 10,
      device = jpeg,
      dpi = "retina"
    ))

    # risk quadrant plot
    suppressWarnings(ggsave(
      xy_joined_rescaled_plot,
      filename = file.path(mypath, paste0(locality_name_internal, "_", focal.species, "_report_viticultural_risk_plot.jpg")),
      height = 8,
      width = 8,
      device = jpeg,
      dpi = "retina"
    ))


    # tables--------------------------------------------------------------------
    # IVR risk table
    # save as .html
    kableExtra::save_kable(
      IVR_risk_kable,
      file = file.path(mypath, paste0(locality_name_internal, "_", focal.species, "_report_viticultural_risk_table.html")),
      self_contained = TRUE,
      bs_theme = "simplex",
      density = 500
    )

    # convert to jpg
    webshot::webshot(
      url = file.path(mypath, paste0(locality_name_internal, "_", focal.species, "_report_viticultural_risk_table.html")),
      file = file.path(mypath, paste0(locality_name_internal, "_", focal.species, "_report_viticultural_risk_table.jpg")),
      zoom = 4
    )

    # prop area table
    # save as .html
    kableExtra::save_kable(
      model_prop_kable,
      file = file.path(mypath, paste0(locality_name_internal, "_", focal.species, "_report_risk_map_areas_table.html")),
      self_contained = TRUE,
      bs_theme = "simplex",
      density = 500
    )

    # convert to jpg
    webshot::webshot(
      url = file.path(mypath, paste0(locality_name_internal, "_", focal.species, "_report_risk_map_areas_table.html")),
      file = file.path(mypath, paste0(locality_name_internal, "_", focal.species, "_report_risk_map_areas_table.jpg")),
      zoom = 2
    )


    #  range shift table
    kableExtra::save_kable(
      range_shift_kable,
      file = file.path(mypath, paste0(locality_name_internal, "_", focal.species, "_report_range_shift_table.html")),
      self_contained = TRUE,
      bs_theme = "simplex",
      density = 500
    )

    # convert to jpg
    webshot::webshot(
      url = file.path(mypath, paste0(locality_name_internal, "_", focal.species, "_report_range_shift_table.html")),
      file = file.path(mypath, paste0(locality_name_internal, "_", focal.species, "_report_range_shift_table.jpg")),
      zoom = 2
    )



    # remove .html files
    file.remove(
      file.path(mypath, paste0(locality_name_internal, "_", focal.species, "_report_viticultural_risk_table.html")),
      file.path(mypath, paste0(locality_name_internal, "_", focal.species, "_report_range_shift_table.html")),
      file.path(mypath, paste0(locality_name_internal, "_", focal.species, "_report_risk_map_areas_table.html"))
      )



    # success message
    cli::cli_alert_success("Report saved to file")
    # DONE saving


  } else if(save.report == FALSE) {

    cli::cli_alert_success("Report NOT saved to file")

  }

  # DONE

}
