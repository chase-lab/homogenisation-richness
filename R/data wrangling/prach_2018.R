# prach_2018
dataset_id <- "prach_2018"

# Communities ----

ddata <- data.table::data.table(
  dataset_id = dataset_id,
  regional = "Bohemian Forest",
  local = "all_sites",

  year = c(1966L, 2009L),
  period = c("historical","recent"),
  timepoints = c("T1","T2"),

  regional_richness = c(222L, 201L),
  local_richness = c(15L, 12L)
)


# Metadata ----

meta <- unique(ddata[, .(dataset_id, regional, local, year, period)])
meta[, ':='(
  taxon = "Plants",
  realm = "Terrestrial",

  latitude =  "48.9 N",
  longitude = "14 E",

  effort = 156L,
  study_type = "resurvey",

  data_pooled_by_authors = TRUE,
  data_pooled_by_authors_comment = "Plots were sampled only once per period 'For the resurvey, we selected 156 plots (Figure 1) sampled between 1955 and 1980 (median sampling year was 1966 and interquartile range was 1960–1973)[...]We resurveyed the plots in 2009–2011' ",
  sampling_years = c("1955-1980", "2009-2011"),

  alpha_grain = 500L,
  alpha_grain_unit = "m2",
  alpha_grain_type = "sample",
  alpha_grain_comment = "vegetation plot",

  gamma_bounding_box = 2500L,
  gamma_bounding_box_unit = "km2",
  gamma_bounding_box_type = "functional",
  gamma_bounding_box_comment = "Bohemian Forest - given by the authors",

  gamma_sum_grains = 500L * 156L,
  gamma_sum_grains_unit = "m2",
  gamma_sum_grains_type = "plot",
  gamma_sum_grains_comment = "area of sampled plots",

  comment = "Extracted from prach_2018. Methods: 'For the resurvey, we selected 156 plots (Figure 1) sampled between 1955 and 1980 (median sampling year was 1966 and interquartile range was 1960–1973) and with at least about 40-year-old canopy trees at the time of both surveys. The age was assessed from detailed forest management plans. To relocate these plots, we used geographic coordinates of the plots[...]We resurveyed the plots in 2009–2011 in the same part of the vegetation season according to the date when the original plot was recorded and used the same plot size of 500 m2 as in the original survey. Within each plot, we recorded all vascular plant species and estimated their percentage cover' Effort is the number of historical sites that were resurveyed.",
  doi = 'https://doi.org/10.1111/avsc.12372'
)]

dir.create(paste0('data/wrangled data/', dataset_id), showWarnings = FALSE)
data.table::fwrite(ddata, paste0('data/wrangled data/', dataset_id, "/", dataset_id, '.csv'),
                   row.names = FALSE)
data.table::fwrite(meta, paste0('data/wrangled data/', dataset_id, "/", dataset_id, '_metadata.csv'),
                   row.names = FALSE)

