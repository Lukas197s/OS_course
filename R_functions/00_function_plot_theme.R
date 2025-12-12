theme_ndvi <- function() {
  theme_minimal(base_size = 14) +
    theme(
      panel.grid.minor = element_blank(),
      panel.grid.major = element_line(color = "grey85"),
      plot.title = element_text(face = "bold", size = 16),
      axis.title = element_text(size = 14),
      legend.position = "right"
    )
}

ndvi_colors <- function() {
  list(
    scale_color_viridis_d(option = "D"),
    scale_fill_viridis_d(option = "D")
  )
}