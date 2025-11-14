## My custom functions

## Load libraries needed
library(dplyr)
library(tidyr)
library(stringr)
library(ggplot2)
library(lme4)
library(lmerTest)   # for p-values
library(ggplot2)
library(dplyr)
library(emmeans) 


load_data <- function(path = "data/data_nullExclude.csv") {
  if (!file.exists(path)) {
    stop(paste("File not found:", path))
  }
  
  df <- read.csv(path)
  return(df)
}



clean_ndvi_data <- function(path = "data/data_nullExclude.csv") 
  {
  
  # Fix column names and remove problematic characters
  df <- raw %>%
    janitor::clean_names()   
  
  # Standardize ID and type column
  df <- df %>%
    mutate(
      type = factor(type),
      unique_id = factor(unique_id)
    )
  
  # OBJECTID and CID represent the same information.
  # Keep one standardized ID:
  if ("cid" %in% names(df)) {
    df <- df %>%
      mutate(site_id = cid) %>% # create standardized site ID
      select(-cid, -objectid) # remove redundant columns
  }
  
  # Identify columns that contain NDVI measurements
  ndvi_cols <- grep("^mean_", names(df), value = TRUE)
  
  # Transform from wide to long format 
  # Each row is one site at one date
  df_long <- df %>%
    pivot_longer(
      cols = all_of(ndvi_cols),
      names_to = "date_raw",
      values_to = "ndvi"
    )
  
  # Extract and convert date info
  df_long <- df_long %>%
    mutate(
      date = str_remove(date_raw, "^mean_"),
      date = as.Date(date, format = "%Y%m%d")
    ) %>%
    select(-date_raw)
  
  # Arrange rows by site and date
  df_long <- df_long %>%
    arrange(site_id, date)
  
  return(df_long)
}





plot_ndvi_simple <- function(df) {
  ggplot(df, aes(x = date, y = ndvi, color = type)) +
    geom_line() +            # line for temporal trend
    geom_point(size = 1.5) + # small points for clarity
    labs(
      x = "Date",
      y = "NDVI",
      color = "Site Type",
      title = "NDVI over Time by Site Type"
    ) +
    theme_minimal() +
    theme(
      axis.text.x = element_text(angle = 45, hjust = 1)
    )
}




ndvi_model_plot <- function(df) {
  library(lme4)
  library(lmerTest)   # for p-values
  library(ggplot2)
  library(dplyr)
  library(emmeans)   # for estimated marginal means
  
  # ---- 1. Fit linear mixed model ----
  # NDVI ~ type + random intercept for site_id
  model <- lmerTest::lmer(ndvi ~ type + (1 | site_id), data = df)
  
  # ---- 2. Model summary ----
  cat("===== Model Summary =====\n")
  print(summary(model))
  
  # ---- 3. Estimated marginal means ----
  emmeans_res <- emmeans(model, specs = "type")
  cat("\n===== Estimated Marginal Means =====\n")
  print(emmeans_res)
  
  # ---- 4. Plot estimated means with error bars ----
  plot_df <- as.data.frame(emmeans_res)
  
  ggplot(plot_df, aes(x = type, y = emmean, fill = type)) +
    geom_bar(stat = "identity", color = "black", width = 0.6) +
    geom_errorbar(aes(ymin = emmean - SE, ymax = emmean + SE), width = 0.2) +
    labs(
      x = "Site Type",
      y = "Estimated Mean NDVI",
      title = "NDVI by Site Type"
    ) +
    theme_minimal() +
    theme(legend.position = "none")
}
