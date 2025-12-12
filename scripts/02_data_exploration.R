## Data Exploration /
## Basic inspection of dataset 

# 1. Load packages
library(dplyr)
library(tidyr)
library(stringr)
library(ggplot2)
library(janitor)
library(targets)

# 2. Source functions
lapply(list.files("R_functions", full.names = TRUE), source)

# 3. Load raw data 
raw_traits <- tar_read(raw_traits)


# 4. Clean data 
df_clean <- clean_ndvi_data(raw_traits)


# 5. Look at data structure
str(df_clean)
colSums(is.na(df_clean))
range(df_clean$date, na.rm = TRUE)



# 6. Some plos for early exploration
eda_plots <- explore_ndvi_data(df_clean)
print(eda_plots$histogram)
print(eda_plots$boxplot)
print(eda_plots$timeseries)

# 8. Summary
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


