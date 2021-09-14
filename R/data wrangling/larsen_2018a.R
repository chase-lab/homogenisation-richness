# larsen_2018a
dataset_id <- "larsen_2018a"

ddata <- data.table::as.data.table(
  readxl::read_xlsx("./data/close access data/larsen_2018_Data_Jon.xlsx", sheet = 1L)
)
data.table::setnames(ddata, c(1,3), c("year", "regional_richness"))

# melting sites ----
ddata <- data.table::melt(ddata,
                 id.vars = 1:3,
                 variable.name = "local",
                 value.name = "local_richness")

# Communities ----

ddata[, ":="(
  dataset_id = dataset_id,
  regional = "watershed",

  timepoints = paste0('T', seq_along(unique(year))[match(year, sort(unique(year)))]),

  `Av local Rich` = NULL
  )]


# Metadata ----

meta <- unique(ddata[, .(dataset_id, regional, local, year)])
meta[, ':='(
  taxon = '',
  realm = 'freshwater',

  latitude =  NA,
  longitude = NA,

  effort = NA,
  study_type = "ecological sampling",

  alpha_grain = NA,
  alpha_grain_unit = NA,
  alpha_grain_type = NA,
  alpha_grain_comment = NA,

  gamma_extent = NA,
  gamma_extent_unit = NA,
  gamma_extent_type = NA,
  gamma_extent_comment = NA,

  comment = "Extracted from data shared by Larsen et al, June 2021."
)]

dir.create(paste0('data/wrangled data/', dataset_id), showWarnings = FALSE)
data.table::fwrite(ddata, paste0('data/wrangled data/', dataset_id, "/", dataset_id, '.csv'),
                   row.names = FALSE)
data.table::fwrite(meta, paste0('data/wrangled data/', dataset_id, "/", dataset_id, '_metadata.csv'),
                   row.names = FALSE)

