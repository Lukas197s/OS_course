## Some analysis of NDVI trends

# NDVI over time (smoothed)
plot_ndvi_time <- function(df_clean) {
  ggplot(df_clean, aes(x = date, y = ndvi, color = type)) +
    geom_point(alpha = 0.4) +
    geom_smooth(method = "loess", se = TRUE, span = 0.3) +
    theme_minimal() +
    labs(
      title = "NDVI trends over time by site type",
      x = "Date",
      y = "NDVI"
    )+
    theme_ndvi()+
    ndvi_colors()
}

# Seasonal patterns
plot_seasonal_ndvi <- function(df_clean) {
  df_clean %>%
    mutate(month = lubridate::month(date, label = TRUE)) %>%
    group_by(type, month) %>%
    summarise(mean_ndvi = mean(ndvi, na.rm = TRUE), .groups = "drop") %>%
    ggplot(aes(x = month, y = mean_ndvi, color = type, group = type)) +
    geom_line(size = 1.2) +
    geom_point(size = 2) +
    theme_minimal() +
    labs(
      title = "Seasonal NDVI patterns by site type",
      x = "Month",
      y = "Mean NDVI"
    )+
    theme_ndvi()+
    ndvi_colors()
}

# NDVI per site
plot_ndvi_distribution <- function(df_clean) {
  ggplot(df_clean, aes(x = ndvi, fill = type)) +
    geom_histogram(bins = 30, alpha = 0.6) +
    facet_wrap(~ site_id, ncol = 4) +
    theme_minimal() +
    labs(
      title = "NDVI distribution per site",
      x = "NDVI",
      y = "Count"
    )+
    theme_ndvi()+
    ndvi_colors()
}

# 5d. NDVI density by type
plot_ndvi_density <- function(df_clean) {
  ggplot(df_clean, aes(x = ndvi, fill = type)) +
    geom_density(alpha = 0.5) +
    theme_minimal() +
    labs(
      title = "NDVI density by site type",
      x = "NDVI",
      y = "Density"
    )+
    theme_ndvi()+
    ndvi_colors()
}

# 5e. NDVI anomalies per site
plot_ndvi_anomalies <- function(df_clean) {
  df_anomaly <- df_clean %>%
    group_by(site_id) %>%
    mutate(ndvi_anomaly = ndvi - mean(ndvi, na.rm = TRUE)) %>%
    ungroup()
  
  ggplot(df_anomaly, aes(x = date, y = ndvi_anomaly, color = type)) +
    geom_line(alpha = 0.7) +
    facet_wrap(~ site_id, ncol = 4) +
    theme_minimal() +
    labs(
      title = "NDVI anomalies per site",
      x = "Date",
      y = "NDVI anomaly"
    )+
    theme_ndvi()+
    ndvi_colors()
}
