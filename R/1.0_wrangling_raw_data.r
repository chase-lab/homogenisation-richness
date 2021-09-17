# Wrangle raw data
lapply(X = list.files('./R/data wrangling', pattern = ".R|.r", full.names = TRUE),
       FUN = source, encoding = 'UTF-8', echo = FALSE, local = TRUE
)
