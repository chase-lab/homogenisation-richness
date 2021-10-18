# kolari_2021
dataset_id <- "kolari_2021"

# Communities ----

ddata <- data.table::data.table(
  dataset_id = dataset_id,
  regional = "Elimyssalo Nature Reserve, Finland",
  local = rep(c("high pH","intermediate pH","low pH","very low pH"), each = 2),

  year = rep(c(1998L, 2018L), 8L),
  period = rep(c("historical","recent"), 8L),
  timepoints = rep(c("T1","T2"), 8L),

  regional_richness = rep(c(110L, 112L), 8L),
  local_richness = c(11.6, 15.8, 11.8, 13.2, 9.6, 11.7, 10.1, 11.5)
)


# Metadata ----

meta <- unique(ddata[, .(dataset_id, regional, local, year, period)])
meta[, ':='(
  taxon = 'plants',
  realm = 'terrestrial',

  latitude  =  "N64°12′",
  longitude = "E30°26′",

  effort = rep(c(53L, 52L, 45L, 53L), each = 2L),
  study_type = "resurvey",

  alpha_grain = 0.25,
  alpha_grain_unit = "m2",
  alpha_grain_type = "sample",
  alpha_grain_comment = "The vegetation data [...] consists of 0.25 m2 plots",

  gamma_bounding_box = 0.171,
  gamma_bounding_box_unit = "km2",
  gamma_bounding_box_type = "functional",
  gamma_bounding_box_comment = "area of the wetland",

  comment = "Extracted from table 1, DOI: 10.1002/ece3.7592. Methods: 'The study site “Härkösuo” mire is a narrow, sloping fen, approximately 1 km long and up to 150 m wide (0.171km2).[...]The vegetation data of Tahvanainen et al. (2002) consists of 0.25m2 plots at all water sampling points (n=77), 148 plots randomly chosen within the grid squares, and 15 additional plots near the springs with 5-m interval. In summer 2018, we repeated the water sampling and vegetation survey. Original vegetation plots had coordinates of 1-m accuracy attached to the regular grid over the mire, and some wooden poles used to mark the grid points in 1998 remain in place.' Effort is the number of plots per habitat type (pH level)."
)]

dir.create(paste0('data/wrangled data/', dataset_id), showWarnings = FALSE)
data.table::fwrite(ddata, paste0('data/wrangled data/', dataset_id, "/", dataset_id, '.csv'),
                   row.names = FALSE)
data.table::fwrite(meta, paste0('data/wrangled data/', dataset_id, "/", dataset_id, '_metadata.csv'),
                   row.names = FALSE)

