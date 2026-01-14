# NDVI Analysis Example

**A reproducible R workflow for analyzing NDVI data to assess vegetation responses to environmental change.**

## Intro
This project demonstrates how NDVI (Normalized Difference Vegetation Index) data can be cleaned, explored, and visualized to detect patterns in 
vegetation greenness over time. While the example dataset comes from riparian sites along the Salinas River, California, the workflow is designed to be adaptable for 
studies assessing vegetation impacts from environmental changes, including wind energy infrastructure.


## Installation for Users

To run the analysis:

1. Install R (version ≥ 4.3) from [CRAN](https://cran.r-project.org/).  
2. Install required R packages:  

```r
install.packages(c("tidyverse", "lubridate", "ggplot2", "dplyr"))
```

3. Download or clone this repository:
git clone https://github.com/Lukas197s/OS_course.git

4. Access data in the data/ folder and scripts in the scripts/ folder.
5. Install and load targets
```r
install.packages("targets")  # if not already installed
library(targets)
```
6. Execute targets
```r
tar_make()
```

## Installation for Contributors
1. Fork the repository on GitHub
2. Clone your fork locally and set up R ≥ 4.3
3. Install additional dependencies for development, including devtools: install.packages(c("tidyverse", "lubridate", "ggplot2", "dplyr", "devtools"))
4. Follow the scripts in the order described in scripts/README.md to reproduce analyses.
5. Use Git for version control and submit pull requests for contributions.

## Contributor Expectations
1. Follow the established workflow: quality check → exploration → visualization → temporal analysis → anomaly detection.
2. Comment all new code clearly and provide reproducible steps.
3. Test any new functions or scripts for errors and compatibility with existing workflow.
4. Respect data privacy and cite original sources.
5. Submit changes via pull requests and participate in code review when requested.

## Known Issues

1. Seasonal aggregation assumes uniform measurement intervals; irregular sampling may affect results.
2. Currently supports only datasets structured like the example NDVI dataset from Salinas River.
3. Large datasets may require increased memory allocation in R.
