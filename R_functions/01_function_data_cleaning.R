## This is the function for cleaning the data

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
