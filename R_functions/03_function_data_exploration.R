
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
    labs(title = "NDVI distribution") +
    theme_ndvi()+
    ndvi_colors()
  
  p2 <- ggplot(df_clean, aes(type, ndvi)) +
    geom_boxplot() +
    theme_minimal() +
    labs(title = "NDVI by site type")+
    theme_ndvi()+
    ndvi_colors()
  
  
  p3 <- ggplot(df_clean, aes(date, ndvi, color = type)) +
    geom_line() +
    theme_minimal() +
    labs(title = "NDVI time series")+
    theme_ndvi()+
    ndvi_colors()
  
  
  return(list(
    histogram = p1,
    boxplot   = p2,
    timeseries = p3
  ))
}
