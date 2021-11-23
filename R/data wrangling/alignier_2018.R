# alignier_2018
dataset_id <- "alignier_2018"

# Communities ----

ddata <- data.table::data.table(
  dataset_id = dataset_id,
  regional = "Zone Atelier Armorique, France",
  local = "all_sites",

  year = c(1994L, 2015L),
  period = c("historical","recent"),
  timepoints = c("T1","T2"),

  regional_richness = c(308L, 284L),
  local_richness = c(28.31, 31.89)
)


# Metadata ----

meta <- unique(ddata[, .(dataset_id, regional, local, year, period)])
meta[, ':='(
  taxon = "Plants",
  realm = "Terrestrial",

  latitude =  "48° 36′ N",
  longitude = "1° 32′ W",

  effort = 309L,
  study_type = "ecological_sampling",

  alpha_grain = 25L * 5L,
  alpha_grain_unit = "m2",
  alpha_grain_type = "sample",
  alpha_grain_comment = "1 25m long plot per field margin, as wide as the field margin",

  gamma_sum_grains = 650L * 3L,
  gamma_sum_grains_unit = "ha",
  gamma_sum_grains_type = "functional",
  gamma_sum_grains_comment = "area of the three sampled landscapes in the experimental site",

  comment = "Extracted from https://doi.org/10.1016/j.agee.2017.09.013. Methods: 'A set of 309 field margins across three contrasted landscapes (107 in landscape A, 106 in landscape B and 96 in landscape C), firstly sampled in 1994, was resurveyed in 2015 using precisely the same protocol. The three landscapes (around 650 ha each) were defined from mapping surveys using a combination of the grain size of the field mosaic, the density of hedgerow network and the relative abundance of grassland versus crop. As the three sites are within 5–10 km from one another, they have a common plant species pool[...]All vascular understory plants were sampled in 25 m long plot (one plot per field margin) placed in the middle of the field margin to avoid multiple edge effects from connection with other field margins. To incorporate local heterogeneity in field margin structure, all thewidth of field margins was sampled.'"
)]

dir.create(paste0('data/wrangled data/', dataset_id), showWarnings = FALSE)
data.table::fwrite(ddata, paste0('data/wrangled data/', dataset_id, "/", dataset_id, '.csv'),
                   row.names = FALSE)
data.table::fwrite(meta, paste0('data/wrangled data/', dataset_id, "/", dataset_id, '_metadata.csv'),
                   row.names = FALSE)

