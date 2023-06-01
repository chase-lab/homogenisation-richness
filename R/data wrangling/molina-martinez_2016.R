# molina-martinez_2016
dataset_id <- "molina-martinez_2016"

# Communities ----

ddata <- data.table::data.table(
  dataset_id = dataset_id,
  regional = "Sierra de Juarez, Mexico",
  local = rep(c(117L, 600L, 800L, 1300L, 1600L, 2000L, 2400L, 3000L), each = 2),

  year = rep(c(1988L, 2010L), 8L),
  period = rep(c("historical","recent"), 8L),
  timepoints = rep(c("T1","T2"), 8L),

  regional_richness = rep(c(221L, 178L), 8L),
  local_richness = c(131L, 101L, 128L, 90L, 136L, 99L, 91L, 71L, 66L, 57L, 34L, 52L, 15L, 40L, 11L, 24L)
)


# Metadata ----

meta <- unique(ddata[, .(dataset_id, regional, local, year, period)])
meta[, ':='(
  taxon = "Invertebrates",
  realm = "Terrestrial",

  latitude  =  "17 37' 0'' N",
  longitude = "96 24' 0'' W",

  effort = 18L,
  study_type = "resurvey",

  data_pooled_by_authors = TRUE,
  data_pooled_by_authors_comment = "Sites were sampled repeatedly in 2010 and 2011. Effort is standardised between sites",
  sampling_years = c("1988", "2010-2011")[match(period, c("historical","recent"))],

  alpha_grain = 2500L,
  alpha_grain_unit = "m2",
  alpha_grain_type = "sample",
  alpha_grain_comment = "500m fixed transects",

  gamma_sum_grains = 2500L * 18L * 8L,
  gamma_sum_grains_unit = "m2",
  gamma_sum_grains_type = "sample",
  gamma_sum_grains_comment = "area of sampled transects times the number of visits times the number of localities in the region",

  gamma_bounding_box = 345L,
  gamma_bounding_box_unit = "km2",
  gamma_bounding_box_type = "box",
  gamma_bounding_box_comment = "area of the box covering the sampling points",

  comment = "Extracted from table 1, DOI: 10.1111/ddi.12473. Methods: 'Eight sites spanning elevations ranging from 117 m to 3000 m were surveyed in 1988 (Luis-Martinez et al., 1991) and resurveyed in 2010-2011 using 500-m fixed transect routes (Molina-Martinez et al., 2013). Butterflies were sampled using transect walks and Van Someren-Rydon traps[...]Consistency of sampling techniques between the time periods was facilitated by A. L.-M., who was involved in both the 1988 and 2010-2011 surveys. In 1988, field sampling was carried out over a 98-day period, while the 2010-2011 field observations spanned 99 days: each site was surveyed on 18-24 occasions during May to October 2010 and March to May 2011, for a total of 219 transect events.' Effort is standardised between sites.",
  doi = 'https://doi.org/10.1111/ddi.12473'
)]

dir.create(paste0('data/wrangled data/', dataset_id), showWarnings = FALSE)
data.table::fwrite(ddata, paste0('data/wrangled data/', dataset_id, "/", dataset_id, '.csv'),
                   row.names = FALSE)
data.table::fwrite(meta, paste0('data/wrangled data/', dataset_id, "/", dataset_id, '_metadata.csv'),
                   row.names = FALSE)

