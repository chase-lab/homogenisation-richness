# zeni_2020
dataset_id <- "zeni_2020"

# Communities ----

ddata <- data.table::data.table(
  dataset_id = dataset_id,
  regional = "Sao Paulo state, Brazil",
  local = "all_sites",

  year = c(2003L, 2013L),
  period = c("historical","recent"),
  timepoints = c("T1","T2"),

  regional_richness = c(46L, 44L),
  local_richness = c(10.42, 9.26)
)


# Metadata ----

meta <- unique(ddata[, .(dataset_id, regional, local, year, period)])
meta[, ':='(
  realm = "Freshwater",
  taxon = "Fish",

  latitude =  -20.470351,
  longitude = -50.264952,

  effort = 38L,
  study_type = "ecological_sampling",

  data_pooled_by_authors = FALSE,

  alpha_grain = c(144, 118.5),
  alpha_grain_unit = "m2",
  alpha_grain_type = "sample",
  alpha_grain_comment = "sampled area: 'Average of stream width multiplied by the extension (75 meters)'",

  gamma_sum_grains = c(144, 118.5)*38,
  gamma_sum_grains_unit = "m2",
  gamma_sum_grains_type = "sample",
  gamma_sum_grains_comment = "sum of individual sampled areas",

  gamma_bounding_box = 160L * 80L,
  gamma_bounding_box_unit = "km2",
  gamma_bounding_box_type = "box",
  gamma_bounding_box_comment = "coarse area of a box covering all sites",

  comment = "Extracted from https://doi.org/10.1007/s10750-020-04356-1 . Methods: 'We sampled 38 stream reaches in the Sao Jose dos Dourados and Turvo-Grande river basins of Sao Paulo state, southeastern Brazil, in both 2003 and 2013.[...]Streams were surveyed once per year during the dry season (May–August). We used the same methodology to sample fish assemblages in both periods[...]We collected 46 and 44 species in 2003 and 2013, respectively, and stream reach alpha diversity (local species richness) was not different between years (2003: mean = 10.42 ± SD 3.81 and 2013: mean = 9.26 ± SD 3.65; t = 1.35, P value = 0.18).'",
  doi = 'https://doi.org/10.1007/s10750-020-04356-1'
)]

dir.create(paste0('data/wrangled data/', dataset_id), showWarnings = FALSE)
data.table::fwrite(ddata, paste0('data/wrangled data/', dataset_id, "/", dataset_id, '.csv'),
                   row.names = FALSE)
data.table::fwrite(meta, paste0('data/wrangled data/', dataset_id, "/", dataset_id, '_metadata.csv'),
                   row.names = FALSE)

