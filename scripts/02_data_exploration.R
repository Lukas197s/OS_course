# Data Exploration 
# Purpose: Basic inspection of data set 

# 1. Load packages
library(dplyr)
library(tidyr)
library(stringr)
library(ggplot2)
library(janitor)

# 2. Source functions
source("R_functions/functions_all.R")

# 3. Load raw data 
raw_traits <- read.csv("data/data_nullExclude.csv")


# 4. Clean data 
df_clean <- clean_ndvi_data(raw_traits)


# 
str(df_clean)
colSums(is.na(df_clean))
range(df_clean$date, na.rm = TRUE)



# 6. Exploration and plots
eda_plots <- explore_ndvi_data(df_clean)
print(eda_plots$histogram)
print(eda_plots$boxplot)
print(eda_plots$timeseries)

# 8. Very lightweight numerical summaries
print(summary(df_clean$ndvi))

df_clean %>%
  group_by(type) %>%
  summarise(
    n = n(),
    mean = mean(ndvi, na.rm = TRUE),
    sd   = sd(ndvi, na.rm = TRUE),
    min  = min(ndvi, na.rm = TRUE),
    max  = max(ndvi, na.rm = TRUE),
    .groups = "drop"
  ) %>%
  print()

# Summary by site
site_summary <- df_clean %>%
  group_by(site_id) %>%
  summarise(
    mean_ndvi = mean(ndvi, na.rm = TRUE),
    sd_ndvi   = sd(ndvi, na.rm = TRUE),
    n_obs     = n(),
    .groups = "drop"
  )


