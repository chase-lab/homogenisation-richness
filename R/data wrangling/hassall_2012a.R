# hassall_2012a
dataset_id <- "hassall_2012a"

# Communities ----

ddata <- data.table::data.table(
  dataset_id = dataset_id,
  regional = "Cheshire, England",
  local = "all_sites",

  year = c(1996L, 2006L),
  period = c("historical","recent"),
  timepoints = c("T1","T2"),

  regional_richness = c(149L, 142L),
  local_richness = c(23.5, 22.3)
)


# Metadata ----

meta <- unique(ddata[, .(dataset_id, regional, local, year, period)])
meta[, ':='(
  taxon = "Plants",
  realm = "Freshwater",

  latitude =  "53.0957 N",
  longitude = "-2.7576 E",

  effort = 51L,
  study_type = "resurvey",

  data_pooled_by_authors = TRUE,
  data_pooled_by_authors_comment = "Original survey was spread over 1995 and 1996. Resurvey was in 2006",
  sampling_years = c("1995-1996", "2006"),

  alpha_grain = 2154L,
  alpha_grain_unit = "m2",
  alpha_grain_type = "lake_pond",
  alpha_grain_comment = "mean pond area measured on 44 of the 51 sampled ponds",

  gamma_bounding_box = 2343L,
  gamma_bounding_box_unit = "km2",
  gamma_bounding_box_type = "administrative",
  gamma_bounding_box_comment = "area of half the Cheshire county given by the authors",

  gamma_sum_grains =  2154L * 51L,
  gamma_sum_grains_unit = "m2",
  gamma_sum_grains_type = "lake_pond",
  gamma_sum_grains_comment = "sum of the areas of the 51 ponds",

  comment = "Extracted from https://doi.org/10.1007/s10531-011-0223-9. Methods: 'We surveyed 51 ponds in northern England in 1995/6 and again in 2006, identifying all macrophytes (167 species) and all macroinvertebrates (221 species, excluding Diptera) to species.[...]The presence and absence of invertebrate species was recorded using standardised sampling methods.' Effort is the number of historical sites that were resurveyed.",
  doi = 'https://doi.org/10.1007/s10531-011-0223-9'
)]

dir.create(paste0('data/wrangled data/', dataset_id), showWarnings = FALSE)
data.table::fwrite(ddata, paste0('data/wrangled data/', dataset_id, "/", dataset_id, '.csv'),
                   row.names = FALSE)
data.table::fwrite(meta, paste0('data/wrangled data/', dataset_id, "/", dataset_id, '_metadata.csv'),
                   row.names = FALSE)

