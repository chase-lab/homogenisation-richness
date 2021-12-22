# Preparing a reference list for all data sets ----
## the citation for the data repository and the article are associated when available.

references <- data.table::fread(
  file = "./data/list_of_datasets.csv",
  na.strings = c("", "NA"),
  encoding = "UTF-8",
  select = c("dataset_id","reference")
)
