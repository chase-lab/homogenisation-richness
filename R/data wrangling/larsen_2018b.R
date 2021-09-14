# larsen_2018b
dataset_id <- "larsen_2018b"

raw_ddata <- data.table::as.data.table(
  readxl::read_xlsx("./data/close access data/larsen_2018_Data_Jon.xlsx", sheet = 2L)
)

ddata <- raw_ddata[1:2]
ddata[, local := c("Site_1", "Site_2")]

# melting years ----
ddata <- data.table::melt(ddata,
                          id.vars = "local",
                          measure.vars = c("1984", "1995", "2012"),
                          variable.name = "year",
                          value.name = "local_richness")

# Communities ----

ddata[, ":="(
  dataset_id = dataset_id,
  regional = "Larsen_2018_Oceanic_sampling",
  regional_richness = unlist(raw_ddata[4, 2:4])[match(year, c("1984", "1995", "2012"))],
  timepoints = paste0('T', seq_along(unique(year))[match(year, sort(unique(year)))])
)]


# Metadata ----

meta <- unique(ddata[, .(dataset_id, regional, local, year)])
meta[, ':='(
  taxon = 'mammals',
  realm = 'marine',

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

