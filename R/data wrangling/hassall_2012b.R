# hassall_2012b
dataset_id <- "hassall_2012b"

# Communities ----

ddata <- data.table::data.table(
  dataset_id = dataset_id,
  regional = "Cheshire, England",

  year = c(1995L, 2006L),
  period = c("historical","recent"),
  timepoints = c("T1","T2"),

  regional_richness = c(181L, 201L),
  local_richness = c(29.5, 39.8)
)


# Metadata ----

meta <- unique(ddata[, .(dataset_id, regional, year)])
meta[, ':='(
  taxon = 'invertebrates',
  realm = 'freshwater',

  latitude =  "53.0957 N",
  longitude = "-2.7576 E",

  effort = 51L,
  study_type = "resurvey",

  alpha_grain = 2154L,
  alpha_grain_unit = "m2",
  alpha_grain_type = "lake/pond",
  alpha_grain_comment = "mean pond area measured on 44 of the 51 sampled ponds",

  gamma_extent = 2343L,
  gamma_extent_unit = "km2",
  gamma_extent_type = "administrative",
  gamma_extent_comment = "area of half the Cheshire county given by the authors",

  comment = "Extracted from DOI 10.1007/s10531-011-0223-9. Methods: 'We surveyed 51 ponds in northern England in 1995/6 and again in 2006, identifying all macrophytes (167 species) and all macroinvertebrates (221 species, excluding Diptera) to species.[...]The presence and absence of invertebrate species was recorded using standardised sampling methods.' Effort is the number of historical sites that were resurveyed."
)]

dir.create(paste0('data/wrangled data/', dataset_id), showWarnings = FALSE)
data.table::fwrite(ddata, paste0('data/wrangled data/', dataset_id, "/", dataset_id, '.csv'),
                   row.names = FALSE)
data.table::fwrite(meta, paste0('data/wrangled data/', dataset_id, "/", dataset_id, '_metadata.csv'),
                   row.names = FALSE)

