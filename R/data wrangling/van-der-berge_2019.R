# van-der-berge_2019
dataset_id <- "van-der-berge_2019"

# Communities ----

ddata <- data.table::data.table(
  dataset_id = dataset_id,
  regional = rep(c("hedgerows, Turnhout","forest, Turnhout"), each = 2L),
  local = "all_sites",

  year = rep(c(1974L, 2015L), 2L),
  period = rep(c("historical","recent"), 2L),
  timepoints = rep(c("T1","T2"), 2L),

  regional_richness = c(70L, 120L, 30L, 24L),
  local_richness = c(8.69, 13.2, 5.6, 3.65)
)


# Metadata ----

meta <- unique(ddata[, .(dataset_id, regional, local, year, period)])
meta[, ':='(
  taxon = 'plants',
  realm = 'terrestrial',

  latitude =  "51°19′N",
  longitude = "04°57′E",

  effort = rep(c(54L, 20L), each = 2L),
  study_type = "ecological sampling",

  alpha_grain = rep(c(25L, 60L), each = 2L),
  alpha_grain_unit = "m2",
  alpha_grain_type = "sample",
  alpha_grain_comment = "25 to 150 m2 for hedgerows and 60 to 150m2 for forests",

  gamma_bounding_box = 56.06,
  gamma_bounding_box_unit = "km2",
  gamma_bounding_box_type = "administrative",
  gamma_bounding_box_comment = "area of the municipality of Turnhout",

  comment = "Extracted from table 1, DOI: 10.1111/avsc.12424. Methods: 'A representative part of the vegetation was recorded via plots varying between 25–150 m2 and 60–150 m2 for hedgerows and forests, respectively.'"
)]

dir.create(paste0('data/wrangled data/', dataset_id), showWarnings = FALSE)
data.table::fwrite(ddata, paste0('data/wrangled data/', dataset_id, "/", dataset_id, '.csv'),
                   row.names = FALSE)
data.table::fwrite(meta, paste0('data/wrangled data/', dataset_id, "/", dataset_id, '_metadata.csv'),
                   row.names = FALSE)

