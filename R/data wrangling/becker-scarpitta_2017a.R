# becker-scarpitta_2017 Bryophytes
dataset_id <- "becker-scarpitta_2017a"

# Communities ----

ddata <- data.table::data.table(
  dataset_id = dataset_id,
  regional = "Brotonne forest, France",
  local = "all_subplots",

  year = c(1976L, 2012L),
  period = c("historical","recent"),
  timepoints = c("T1","T2"),

  regional_richness = c(18L, 53L),
  local_richness = c(3.3, 6.8)
)


# Metadata ----

meta <- unique(ddata[, .(dataset_id, regional, local, year)])
meta[, ':='(
  taxon = 'bryophytes',
  realm = 'terrestrial',

  latitude  =  "49.5 N",
  longitude = "0.725 E",

  effort = 91L,
  study_type = "resurvey",

  alpha_grain = 1,
  alpha_grain_unit = "m2",
  alpha_grain_type = "sample",
  alpha_grain_comment = "each subplot is one of soil, rock, tree stumps or fallen branches ",

  gamma_extent = 7450L,
  gamma_extent_unit = "ha",
  gamma_extent_type = "functional",
  gamma_extent_comment = "area of the fieldwork region",

  comment = "Extracted from table 1, Doi: 10.1111/jvs.12579. Methods: 'Using identical methods for the two time periods, theabundance of all species of vascular plant (herbaceous species, ferns, shrubs and trees) and bryophytes (Bryophyta and Marchantiophyta) were recorded following a phytosociological approach (Bardat 1978). In each plot (400 m2) or subplot (see below), the abundance of all vascular plant and bryophyte species present in the plot was recorded using Braun-Blanquet’s phytosociological coefficient[...]For bryophytes, recent surveys were conducted in April 2012, and in each plot we sampled up to four microhabitats (‘subplots’), corresponding to different substrates: soil, rock, tree stumps and fallen branches. Not all substrates were present in a given plot, so the total number of subplots (93: 44 soil + 2 rock + 32 stump +  15 branch) is <46 x4, but identical for the two time periods (balanced design). Because there are only two subplots on rock per year, we removed these from analyses, leaving 91 subplots per year.' Effort is the total number of subplots."
)]

dir.create(paste0('data/wrangled data/', dataset_id), showWarnings = FALSE)
data.table::fwrite(ddata, paste0('data/wrangled data/', dataset_id, "/", dataset_id, '.csv'),
                   row.names = FALSE)
data.table::fwrite(meta, paste0('data/wrangled data/', dataset_id, "/", dataset_id, '_metadata.csv'),
                   row.names = FALSE)
