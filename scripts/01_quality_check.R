# 1. Load the targets package
library(targets)

# 2. Read the cleaned NDVI dataset from the pipeline
df_clean <- tar_read(df_clean)

# 3. Source the quality check function (it can depend on nothing else)
lapply(list.files("R_functions", full.names = TRUE), source)

# 4. Run the quality check
check_ndvi_quality(df_clean)
