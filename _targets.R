## Load libraries needed
library(targets)
library(tarchetypes)
library(dplyr)
library(tidyr)
library(stringr)
library(ggplot2)
library(lme4)
library(lmerTest)   
library(ggplot2)
library(dplyr)
library(viridis)



lapply(list.files("R_functions", full.names = TRUE), source)

tar_option_set(
  packages = c(
    "dplyr", "tidyr", "stringr", "ggplot2",
    "lme4", "lmerTest", "emmeans", "janitor"
  )
)

list(
  # load dataset
  tar_target(
    raw_traits,
    read.csv("data/data_nullExclude.csv")
  ),
  # clean dataset
  tar_target(
    df_clean,
    clean_ndvi_data(raw_traits)
  ),
  # check for problems
  tar_target(
    ndvi_quality_check,
    check_ndvi_quality(df_clean)
  ),
  # data exploration
  tar_target(
    eda_plots,
    explore_ndvi_data(df_clean)
  ),
  # NDVI over time
  tar_target(
    ndvi_time_plot,
    plot_ndvi_time(df_clean)
  ),
  # NDVI by season
  tar_target(
    ndvi_seasonal_plot,
    plot_seasonal_ndvi(df_clean)
  ),
  # NDVI distribution per site
  tar_target(
    ndvi_distribution_plot,
    plot_ndvi_distribution(df_clean)
  ),
  # NDVI density 
  tar_target(
    ndvi_density_plot,
    plot_ndvi_density(df_clean)
  ),
  # NDVI anomalies per site
  tar_target(
    ndvi_anomaly_plot,
    plot_ndvi_anomalies(df_clean)
)
)

