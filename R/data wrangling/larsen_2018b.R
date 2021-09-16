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
  regional = "Wales",
  regional_richness = unlist(raw_ddata[4, 2:4])[match(year, c("1984", "1995", "2012"))],
  timepoints = paste0('T', seq_along(unique(year))[match(year, sort(unique(year)))])
)]


# Metadata ----

meta <- unique(ddata[, .(dataset_id, regional, local, year)])
meta[, ':='(
  taxon = 'invertebrates',
  realm = 'freshwater',

  latitude =  "52° 18′ 0'' N",
  longitude = "3° 36′ 0'' W",

  effort = 1L,
  study_type = "ecological sampling",

  alpha_grain = NA,
  alpha_grain_unit = NA,
  alpha_grain_type = NA,
  alpha_grain_comment = "alpha is a stream sampled in a standardised way",

  gamma_extent = 20779L,
  gamma_extent_unit = "km2",
  gamma_extent_type = "administrative",
  gamma_extent_comment = "area of Wales",

  comment = "Extracted from data Larsen, S., Chase, J.M., Durance, I. and Ormerod, S.J. (2018), Lifting the veil: richness measurements fail to detect systematic biodiversity change over three decades. Ecology, 99: 1316-1326. https://doi.org/10.1002/ecy.2213. Here, mean richness of 56 streams throughout Wales were used for alpha and gamma is for the country."
)]

dir.create(paste0('data/wrangled data/', dataset_id), showWarnings = FALSE)
data.table::fwrite(ddata, paste0('data/wrangled data/', dataset_id, "/", dataset_id, '.csv'),
                   row.names = FALSE)
data.table::fwrite(meta, paste0('data/wrangled data/', dataset_id, "/", dataset_id, '_metadata.csv'),
                   row.names = FALSE)

