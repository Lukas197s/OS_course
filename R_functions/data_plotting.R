## My custom functions

## Load libraries needed
library(dplyr)
library(tidyr)
library(stringr)


load_data <- function(path = "data/data_nullExclude.csv") {
  if (!file.exists(path)) {
    stop(paste("File not found:", path))
  }
  
  df <- read.csv(path)
  return(df)
}

df = load_data()


clean_ndvi_data <- function(path = "data/data_nullExclude.csv") 
  {
  # ---- 1. LOAD ----
  raw <- read.csv(path, check.names = FALSE)
  
  # ---- 2. CLEAN BASIC COLUMN NAMES ----
  df <- raw %>%
    janitor::clean_names()   # makes everything snake_case and consistent
  
  # ---- 3. FIX IDs & TYPES ----
  df <- df %>%
    mutate(
      type = factor(type),
      unique_id = factor(unique_id)
    )
  
  # OBJECTID and CID represent the same information.
  # Keep one standardized ID:
  if ("cid" %in% names(df)) {
    df <- df %>%
      mutate(site_id = cid) %>%
      select(-cid, -objectid)
  }
  
  # ---- 4. IDENTIFY NDVI COLUMNS ----
  ndvi_cols <- grep("^mean_", names(df), value = TRUE)
  
  # ---- 5. WIDE → LONG TRANSFORMATION ----
  df_long <- df %>%
    pivot_longer(
      cols = all_of(ndvi_cols),
      names_to = "date_raw",
      values_to = "ndvi"
    )
  
  # ---- 6. EXTRACT DATES ----
  df_long <- df_long %>%
    mutate(
      date = str_remove(date_raw, "^mean_"),
      date = as.Date(date, format = "%Y%m%d")
    ) %>%
    select(-date_raw)
  
  # ---- 7. FINAL CLEANUP ----
  df_long <- df_long %>%
    arrange(site_id, date)
  
  return(df_long)
}

data_clean = clean_ndvi_data()







# run a linear regression
fit_model = function(data, response, predictor){
  mod = lm(as.formula(paste(response, "~", predictor)), data = data)
  mod
}

# make figure
make_figure = function(traits){
  ggplot(traits, aes(x = Gradient, y = Value)) +
    geom_boxplot(fill = c("grey80", "darkgreen")) +
    labs(x = "", y = expression(Leaf~area~cm^2)) +
    theme_bw()
}