lapply(list.files("R_functions", full.names = TRUE), source)

# Run each plot
plot_ndvi_time(df_clean)
plot_seasonal_ndvi(df_clean)
plot_ndvi_distribution(df_clean)
plot_ndvi_density(df_clean)
plot_ndvi_anomalies(df_clean)


