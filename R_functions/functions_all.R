## This file contains all functions 

clean_ndvi_data <- function(raw_traits) 
  {
  
  # Fix column names and remove problematic characters
  df <- raw_traits %>%
    janitor::clean_names()   
  
  # Standardize ID and type column
  df <- df %>%
    mutate(
      type = factor(type),
      unique_id = factor(unique_id)
    )
  
  # Keep one standardized ID
  if ("cid" %in% names(df)) {
    df <- df %>%
      mutate(site_id = cid) %>% # create standardized site ID
      select(-cid, -objectid) # remove redundant columns
  }
  
  # Identify columns that contain NDVI measurements
  ndvi_cols <- grep("^mean_", names(df), value = TRUE)
  
  # Transform from wide to long  
  # Each row is one site at one date
  df_long <- df %>%
    pivot_longer(
      cols = all_of(ndvi_cols),
      names_to = "date_raw",
      values_to = "ndvi"
    )
  
  # Extract and convert date 
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





plot_ndvi_simple <- function(df_clean) {
  ggplot(df_clean, aes(x = date, y = ndvi, color = type)) +
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



ndvi_model_plot <- function(df_clean) {
  
  # 1. Fit LMM
  model <- lmerTest::lmer(ndvi ~ type + (1 | site_id), data = df_clean)
  print(summary(model))
  
  # 2. Estimated marginal means 
  emmeans_res <- emmeans(model, specs = "type")
  print(emmeans_res)
  
  # 3. EMMs
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




# Function for data exploration
explore_ndvi_data <- function(df_clean) {
  
  
  # Structure 
  print(str(df_clean))
  
  # N/As or missing value
  print(colSums(is.na(df_clean)))
  
  # Global NDVI summary 
  print(
    df_clean %>%
      summarise(
        n    = n(),
        mean = mean(ndvi, na.rm = TRUE),
        sd   = sd(ndvi, na.rm = TRUE),
        min  = min(ndvi, na.rm = TRUE),
        max  = max(ndvi, na.rm = TRUE)
      )
  )
  
  # NDVI by site type 
  print(
    df_clean %>%
      group_by(type) %>%
      summarise(
        n    = n(),
        mean = mean(ndvi, na.rm = TRUE),
        sd   = sd(ndvi, na.rm = TRUE),
        min  = min(ndvi, na.rm = TRUE),
        max  = max(ndvi, na.rm = TRUE),
        .groups = "drop"
      )
  )
  
  # NDVI by date
  print(
    df_clean %>%
      summarise(
        start_date = min(date, na.rm = TRUE),
        end_date   = max(date, na.rm = TRUE),
        n_dates    = n_distinct(date)
      )
  )
  
  # Some plots 
  p1 <- ggplot(df_clean, aes(ndvi)) +
    geom_histogram(bins = 40) +
    theme_minimal() +
    labs(title = "NDVI distribution")
  
  p2 <- ggplot(df_clean, aes(type, ndvi)) +
    geom_boxplot() +
    theme_minimal() +
    labs(title = "NDVI by site type")
  
  p3 <- ggplot(df_clean, aes(date, ndvi, color = type)) +
    geom_line() +
    theme_minimal() +
    labs(title = "NDVI time series")
  
  return(list(
    histogram = p1,
    boxplot   = p2,
    timeseries = p3
  ))
}