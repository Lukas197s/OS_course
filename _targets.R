library(targets)
library(tarchetypes)

source("R_functions/functions_all.R")

tar_option_set(
  packages = c(
    "dplyr", "tidyr", "stringr", "ggplot2",
    "lme4", "lmerTest", "emmeans", "janitor"
  )
)

list(
  tar_target(
    raw_traits,
    read.csv("data/data_nullExclude.csv")
  ),
  
  tar_target(
    df_clean,
    clean_ndvi_data(raw_traits)
  ),
  
  tar_target(
    ndvi_plot,
    plot_ndvi_simple(df_clean)
  ),
  
  tar_target(
    model_plot,
    ndvi_model_plot(df_clean)
  )
)
