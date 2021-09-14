# litza_2016
dataset_id <- "litza_2016"

# Communities ----

ddata <- data.table::data.table(
  dataset_id = dataset_id,
  regional = "Schleswig-Holstein, Germany",

  year = c(1967L, 2015L),
  period = c("historical","recent"),
  timepoints = c("T1","T2"),

  regional_richness = c(182L, 164L),
  local_richness = c(39L, 36L)
)


# Metadata ----

meta <- unique(ddata[, .(dataset_id, regional, year)])
meta[, ':='(
  taxon = 'plants',
  realm = 'terrestrial',

  latitude =  "54.25 N",
  longitude = "10 E",

  effort = 51L,
  study_type = "resurvey",

  alpha_grain = 700L,
  alpha_grain_unit = "m2",
  alpha_grain_type = "sample",
  alpha_grain_comment = "70m long transect of the whole width (estimated 10m) of the hedgerow",

  gamma_extent = 15763.18 / 2,
  gamma_extent_unit = "km2",
  gamma_extent_type = "administrative",
  gamma_extent_comment = "area of half the state of Schleswig-Holstein",

  comment = "Extracted from http://dx.doi.org/10.1016/j.biocon.2016.12.003. Methods: 'Because the original study was carried out in summer, the sampling was done in June and July 2015 even though this might miss spring flowering plants. The plot length in the original studywas given as usually varying between 60 and 80 m of a hedgerow. For the resurvey, we applied a fixed length of 70 m. The plot width was defined by the borders of the adjacent fields in accordance with the original study, meaning that the field margins were also included in the sampling.' Effort is the number of historical sites that were resurveyed."
)]

dir.create(paste0('data/wrangled data/', dataset_id), showWarnings = FALSE)
data.table::fwrite(ddata, paste0('data/wrangled data/', dataset_id, "/", dataset_id, '.csv'),
                   row.names = FALSE)
data.table::fwrite(meta, paste0('data/wrangled data/', dataset_id, "/", dataset_id, '_metadata.csv'),
                   row.names = FALSE)

