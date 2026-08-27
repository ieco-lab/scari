# Shifting Climate Assessments for Risk of Invasions (SCARI)
## `scari` R Package Overview <a href="https://ieco-lab.github.io/scari/"><img src="man/figures/logo.png" align="right" height="120" alt="scari website" /></a>

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

`scari` is an R package and research compendium that documents a multiscale species distribution modeling (SDM) workflow to forecast establishment and impact risk of a species invasion as it shifts with climate change.

We developed this workflow to quantify the shifting risk for the establishment of invasive species under climate change. We specifically look at *Lycorma delicatula* (spotted lanternfly or SLF) as a focal species for our study, and quantify the potential risk for its establishment within globally important viticulture regions. The `R` function [create_risk_report](R/create_risk_report.R) produces risk maps, range shift estimates, risk plots and other outputs at the scale of countries or smaller geopolitical units. For example usage of this function in different contexts, see the [Create Reports](docs/articles/reports_index.html) tab.

### Citation

The package `scari` is a research compendium for:

Owens, S. M. (2024). Multi-scale Modeling of the Spotted Lanternfly *Lycorma delicatula* (Hemiptera: Fulgoridae) Reveals Displaced Risk to Viticulture and Regional Range Expansion Due to Climate Change [M.S., Temple University]. In ProQuest Dissertations and Theses (30996434448). https://www.proquest.com/dissertations-theses/multi-scale-modeling-spotted-lanternfly-em/docview/30996434448/se-2?accountid=130527
![image](https://github.com/user-attachments/assets/c840b94d-0c42-40bb-9134-cae1c31bb7e3)

### License

This project is licensed under the [MIT License](https://opensource.org/licenses/MIT). See [`LICENSE.md`](LICENSE.md) for the full text.

### Installation

This package should be first be downloaded and installed from GitHub by running the following code:

```
require(devtools)
# install.packages("devtools") # if devtools is not installed yet
devtools::install_github("ieco-lab/scari")
library(scari)
```

The **dependency** packages should then be installed for the package to run properly:

Here are the main packages that `scari` depends on:

```
install.packages(c('cli', 'common', 'CoordinateCleaner', 'devtools', 'dismo', 'ENMTools', 'formattable', 'gginnards', 'ggspatial', 'gitcreds', 'grid', 'here', 'httr', 'kableExtra', 'kgc', 'patchwork', 'pkgdown', 'plotROC', 'pROC', 'raster', 'rasterVis', 'remotes', 'renv', 'rgbif', 'rJava', 'rlang', 'rmarkdown', 'rnaturalearth', 'scales', 'SDMtune', 'sf', 'sp', 'stats', 'stringr', 'terra', 'tidyverse', 'usethis', 'utils', 'viridis', 'webshot', 'webshot2'))

# Install package which cannot be obtained from the CRAN
library(devtools)
remotes::install_github("ieco-lab/lydemapr", build_vignettes = FALSE)
remotes::install_github("ropensci/rnaturalearthdata")
remotes::install_github("ropensci/rnaturalearthhires")
remotes::install_github("densitymodelling/dsmextra")

# install specific versions of packages
remotes::install_version("ggnewscale", version = "0.4.10") # due to issue with color scales
remotes::install_version("GeoThinneR", version = "1.1.0") # due to issue with thin_points
remotes::install_version("tidygeocoder", version = "1.0.5") # due to issue with reverse_geocode()

# we also suggest installing the following packages if using the appendix in vignette 050:
install.packages("blockCV")
```

### Sitemap

This GitHub project is organized into two groups of vignettes: those which generate reports for SLF risk to viticulture based on our analysis, and those outlining our modeling pipeline used to create these reports.

Reports can be generated using vignettes 150-152, which contain example usage of our function [create_risk_report()](vignettes/150_create_risk_report.Rmd) (150) to create reports for global countries and states/provinces (151), and for the USA specifically (152).

For a guide to using our full modeling pipeline, please see this sitemap and the [Analyses](docs/articles/articles_index.html) tab:

* Step 1: Initialize `scari` and dependencies       | vignette 010
* Step 2: Retrieve and tidy input data for MaxEnt   | vignettes 020-030
* Step 3: Execute SDM modeling pipeline             | vignettes 040-090
* Step 4: Ensemble regional-scale SDMs              | vignettes 100-110
* Step 5: Quantify SLF risk                         | vignettes 120-130, 160
* Step 6: Validate model fit                        | vignettes 140-142

## How to Use this Project

Before diving into this project and our modeling workflow, an end user should:

1. Read the [companion paper](https://www.proquest.com/dissertations-theses/multi-scale-modeling-spotted-lanternfly-em/docview/30996434448/se-2?accountid=130527), which outlines the conceptual underpinnings for this project.
2. Download, build and install this package locally.
3. Install the package `renv`, and run `renv::restore()` inside the R project, which ensures that your R package versions are consistent for running this package. (NOTE: this creates a project-specific R package library, so it should not affect your main library).
4. Run the first vignette, [010_initialize_renv](vignettes/010_initialize_pkg.Rmd), which initializes `renv`, lists our package's dependencies, and introduces some important information.
5. See the [Get Started](articles/scari.html) tab for help in using our package to produce localized reports on SLF risk to viticulture or to recreate our analysis for another invasive species of interest
  
Once these steps are completed, the end user can get started either generating SLF reports, or following and editing the full modeling pipeline. 

#### Computing and Software Information

This package was developed and its vignettes were rendered on a Dell Precision desktop PC with the following characteristics:

* Core: intel Xeon CPU, 3.60 GHz
* RAM memory: 64 GB (at least 2GB memory allocation to Java via R)
* Operating System: Windows 11 Enterprise, version 24H2
* R version: 4.6.1
* Rstudio version: 2026.07.1+147

Be sure to download and install the correct bit version of [Java](https://www.oracle.com/java/technologies/downloads/#java24) for your operating system to use this package. 

## References

Gallien, L., Douzet, R., Pratte, S., Zimmermann, N. E., & Thuiller, W. (2012). Invasive species distribution models – how violating the equilibrium assumption can create new insights. Global Ecology and Biogeography, 21(11), 1126–1136. https://doi.org/10.1111/j.1466-8238.2012.00768.x

Huron, N. A., Behm, J. E., & Helmus, M. R. (2022). Paninvasion severity assessment of a U.S. grape pest to disrupt the global wine market. Communications Biology, 5(1), 655. https://doi.org/10.1038/s42003-022-03580-w

Phillips, S. J., Anderson, R. P., & Schapire, R. E. (2006). Maximum entropy modeling of species geographic distributions. Ecological Modelling, 190(3), 231–259. https://doi.org/10.1016/j.ecolmodel.2005.03.026
