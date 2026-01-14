## Load libraries needed
library(targets)
library(tarchetypes)


lapply(list.files("R_functions", full.names = TRUE), source)

tar_option_set(
  packages = c(
    "tidyverse" , "lme4", "lmerTest", "ggplot2" , "dplyr" , "viridis", 
    "emmeans", "janitor"
  )
)

list(
  # 1.track input file
  tar_target(
    raw_traits_file,
    "data/data_nullExclude.csv",
    format = "file" ##file targets do not produce an object or run code?!
  ),
  # 2.read dataset
  tar_target(
    raw_traits,
    read.csv(raw_traits_file)
  ),
  # 3.clean dataset
  tar_target(
    df_clean,
    clean_ndvi_data(raw_traits)
  ),
  # 4.check for problems
  tar_target(
    ndvi_quality_check,
    check_ndvi_quality(df_clean)
  ),
  # 5.data exploration
  tar_target(
    eda_plots,
    explore_ndvi_data(df_clean)
  ),
  # 6.NDVI over time
  tar_target(
    ndvi_time_plot,
    plot_ndvi_time(df_clean)
  ),
  # 7.NDVI by season
  tar_target(
    ndvi_seasonal_plot,
    plot_seasonal_ndvi(df_clean)
  ),
  # 8.NDVI distribution per site
  tar_target(
    ndvi_distribution_plot,
    plot_ndvi_distribution(df_clean)
  ),
  # 9.NDVI density 
  tar_target(
    ndvi_density_plot,
    plot_ndvi_density(df_clean)
  ),
  # 10.NDVI anomalies per site
  tar_target(
    ndvi_anomaly_plot,
    plot_ndvi_anomalies(df_clean)
    ),
  # 11.Add .qmd file to targets
  tar_quarto(
  report,
  "quarto_file.qmd"
)
)

