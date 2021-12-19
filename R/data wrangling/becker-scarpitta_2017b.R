# becker-scarpitta_2017 vascular plants
dataset_id <- "becker-scarpitta_2017b"

# Communities ----

ddata <- data.table::data.table(
  dataset_id = dataset_id,
  regional = "Brotonne forest, France",
  local = "all_plots",

  year = c(1976L, 2009L),
  period = c("historical","recent"),
  timepoints = c("T1","T2"),

  regional_richness = c(87L, 62L),
  local_richness = c(15.8, 9.8)
)


# Metadata ----

meta <- unique(ddata[, .(dataset_id, regional, local, year, period)])
meta[, ':='(
  taxon = "Plants",
  realm = "Terrestrial",

  latitude  =  "49.5 N",
  longitude = "0.725 E",

  effort = 74L,
  study_type = "resurvey",

  data_pooled_by_authors = TRUE,
  data_pooled_by_authors_comment = "Original survey was spread over 1975, 1976 and 1977. Resurvey was in 2012.",
  sampling_years = c("1975-1977", "2009"),

  alpha_grain = 400L,
  alpha_grain_unit = "m2",
  alpha_grain_type = "plot",
  alpha_grain_comment = "given by the authors",

  gamma_bounding_box = 7450L,
  gamma_bounding_box_unit = "ha",
  gamma_bounding_box_type = "functional",
  gamma_bounding_box_comment = "area of the fieldwork region",

  gamma_sum_grains = 74L * 400L,
  gamma_sum_grains_unit = "m2",
  gamma_sum_grains_type = "plot",
  gamma_sum_grains_comment = "area of sampled subplots",

  comment = "Extracted from table 1, Doi: 10.1111/jvs.12579. Methods: 'Using identical methods for the two time periods, theabundance of all species of vascular plant (herbaceous species, ferns, shrubs and trees) and bryophytes (Bryophyta and Marchantiophyta) were recorded following a phytosociological approach (Bardat 1978). In each plot (400 m2) or subplot (see below), the abundance of all vascular plant and bryophyte species present in the plot was recorded using Braun-Blanquet’s phytosociological coefficient[...]For vascular plants, the recent surveys were conducted in 2009 during two time windows in April for spring flowering species and in June/July for summer flowering species' Effort is the total number of plots."
)]

dir.create(paste0('data/wrangled data/', dataset_id), showWarnings = FALSE)
data.table::fwrite(ddata, paste0('data/wrangled data/', dataset_id, "/", dataset_id, '.csv'),
                   row.names = FALSE)
data.table::fwrite(meta, paste0('data/wrangled data/', dataset_id, "/", dataset_id, '_metadata.csv'),
                   row.names = FALSE)

