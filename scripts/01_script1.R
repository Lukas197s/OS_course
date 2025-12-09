# ===============================
# Salinas River NDVI Analysis
# ===============================

# Load required packages
library(dplyr)
library(tidyr)
library(stringr)
library(ggplot2)
library(lme4)
library(lmerTest)
library(emmeans)
library(janitor)   

# Source functions; source("R/functions.R")
source("R_functions/functions_all.R")

# Load raw data 
raw <- load_data()

# Clean data
data_clean <- clean_ndvi_data()

# Exploratory plot 
plot_ndvi_simple(data_clean)

# Statistical analysis: test NDVI differences
ndvi_model_plot(data_clean)

# Optional: save plots ----
# ggsave("ndvi_trends_plot.png", plot = last_plot(), width = 8, height = 5)
