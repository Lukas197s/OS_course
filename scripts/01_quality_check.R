## Script to check the quality of the data and whether there are any "problems" with the dataset

# 1. Load libraries 
library(dplyr)
library(tidyr)
library(targets)

# 2. Load raw data
raw_traits <- tar_read(raw_traits)

# 2. Clean NDVI dataset
df_clean <- tar_read(df_clean)

# 3. Source functions
lapply(list.files("R_functions", full.names = TRUE), source)

# 4. Run  quality check
check_ndvi_quality(df_clean)
