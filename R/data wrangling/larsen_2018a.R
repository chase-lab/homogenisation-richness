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
  regional = "Llyn Brianne",

  timepoints = paste0('T', seq_along(unique(year))[match(year, sort(unique(year)))]),

  `Av local Rich` = NULL
  )]


# Metadata ----

meta <- unique(ddata[, .(dataset_id, regional, local, year)])
meta[, ':='(
  taxon = "Invertebrates",
  realm = "Freshwater",

  latitude =  "52°80 N",
  longitude = " 3°45 0 W",

  effort = 10L,
  study_type = "ecological_sampling",

  data_pooled_by_authors = FALSE,

  alpha_grain = 23 * 25.5,
  alpha_grain_unit = "cm2",
  alpha_grain_type = "sample",
  alpha_grain_comment = "hand net dimension given by the authors",

  gamma_sum_grains = .23 * .255 * 10,
  gamma_sum_grains_unit = "m2",
  gamma_sum_grains_type = "sample",
  gamma_sum_grains_comment = "summed area of samples",

  gamma_bounding_box = 300L,
  gamma_bounding_box_unit = "km2",
  gamma_bounding_box_type = "catchement",
  gamma_bounding_box_comment = "area of the Llyn Brianne watershed",

  comment = "Extracted from data Larsen, S., Chase, J.M., Durance, I. and Ormerod, S.J. (2018), Lifting the veil: richness measurements fail to detect systematic biodiversity change over three decades. Ecology, 99: 1316-1326. https://doi.org/10.1002/ecy.2213. Here, composition of 10 streams of the Llyn Brianne watershed were used.",
  doi = 'https://doi.org/10.1002/ecy.2213'
)]

dir.create(paste0('data/wrangled data/', dataset_id), showWarnings = FALSE)
data.table::fwrite(ddata, paste0('data/wrangled data/', dataset_id, "/", dataset_id, '.csv'),
                   row.names = FALSE)
data.table::fwrite(meta, paste0('data/wrangled data/', dataset_id, "/", dataset_id, '_metadata.csv'),
                   row.names = FALSE)

