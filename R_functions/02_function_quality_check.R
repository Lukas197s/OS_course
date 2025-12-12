## this is the function to check for problems with the dataset

check_ndvi_quality <- function(df_clean) {
  
  # Check NDVI range 
  outside_range <- df_clean %>% 
    filter(ndvi < -1 | ndvi > 1)
  
  if (nrow(outside_range) > 0) {
    stop("Error: NDVI values outside expected range [-1, 1].")
  } else {
    message("NDVI values within expected range [-1, 1].")
  }
  
  #  Check for missing values
  missing_vals <- colSums(is.na(df_clean))
  message("Missing Values per Column")
  print(missing_vals)
  
  # CHeck for duplicate rows
  dup_count <- sum(duplicated(df_clean))
  message("Number of duplicated rows: ", dup_count)
  
  # 4. Search outliers
  mean_ndvi <- mean(df_clean$ndvi, na.rm = TRUE)
  sd_ndvi <- sd(df_clean$ndvi, na.rm = TRUE)
  outliers <- df_clean %>%
    filter(ndvi < mean_ndvi - 3 * sd_ndvi |
             ndvi > mean_ndvi + 3 * sd_ndvi)
  message("Number of NDVI outliers (±3 SD): ", nrow(outliers))
  
  # 5. Calculate sample sizes per site
  samples_per_site <- df_clean %>% count(site_id)
  message("Samples per Site: ")
  print(samples_per_site)
  
  # 6. Check for time gaps in NDVI measurements
  gap_df <- df_clean %>%
    group_by(site_id) %>%
    arrange(date) %>%
    mutate(gap_days = as.numeric(date - lag(date))) %>%
    filter(!is.na(gap_days) & gap_days > 40)
  
  if (nrow(gap_df) == 0) {
    message("No long  gaps detected (>40 days).")
  } else {
    message("Detected time gaps > 40 days:")
    print(gap_df)
  }
}



