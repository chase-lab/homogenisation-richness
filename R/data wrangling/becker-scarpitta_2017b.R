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

meta <- unique(ddata[, .(dataset_id, regional, local, year)])
meta[, ':='(
  taxon = 'plants',
  realm = 'terrestrial',

  latitude  =  "49.5 N",
  longitude = "0.725 E",

  effort = 74L,
  study_type = "resurvey",

  alpha_grain = 400,
  alpha_grain_unit = "m2",
  alpha_grain_type = "plot",
  alpha_grain_comment = "given by the authors",

  gamma_extent = 7450L,
  gamma_extent_unit = "ha",
  gamma_extent_type = "functional",
  gamma_extent_comment = "area of the fieldwork region",

  comment = "Extracted from table 1, Doi: 10.1111/jvs.12579. Methods: 'Using identical methods for the two time periods, theabundance of all species of vascular plant (herbaceous species, ferns, shrubs and trees) and bryophytes (Bryophyta and Marchantiophyta) were recorded following a phytosociological approach (Bardat 1978). In each plot (400 m2) or subplot (see below), the abundance of all vascular plant and bryophyte species present in the plot was recorded using Braun-Blanquet’s phytosociological coefficient[...]For vascular plants, the recent surveys were conducted in 2009 during two time windows in April for spring flowering species and in June/July for summer flowering species' Effort is the total number of plots."
)]

dir.create(paste0('data/wrangled data/', dataset_id), showWarnings = FALSE)
data.table::fwrite(ddata, paste0('data/wrangled data/', dataset_id, "/", dataset_id, '.csv'),
                   row.names = FALSE)
data.table::fwrite(meta, paste0('data/wrangled data/', dataset_id, "/", dataset_id, '_metadata.csv'),
                   row.names = FALSE)
