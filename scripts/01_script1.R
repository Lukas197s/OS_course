# ===============================
# Salinas River NDVI Analysis
# ===============================

# ---- 1. Load required packages ----
library(dplyr)
library(tidyr)
library(stringr)
library(ggplot2)
library(lme4)
library(lmerTest)
library(emmeans)
library(janitor)   

# 2. Source functions; source("R/functions.R")
source("R_functions/functions_all.R")

# 3. Load raw data ----
raw <- load_data("data/data_nullExclude.csv")

# ---- 4. Clean data ----
data_clean <- clean_ndvi_data()

# ---- 5. Exploratory plot ----
plot_ndvi_simple(data_clean)

# ---- 6. Statistical analysis: test NDVI differences ----
ndvi_model_plot(data_clean)

# ---- 7. Optional: save plots ----
# ggsave("ndvi_trends_plot.png", plot = last_plot(), width = 8, height = 5)
