# rumschlag_2023
dataset_id <- "rumschlag_2023"

if (!file.exists("data/raw data/rumschlag_2023/rdata.rds")) {
  if (!file.exists("data/cache/rumschlag_2023.zip"))
    curl::curl_download(url = "https://figshare.com/ndownloader/files/39582949",
                        destfile = "data/cache/rumschlag_2023.zip", mode = "wb")

  base::dir.create(path = "data/raw data/rumschlag_2023/", showWarnings = FALSE)
  base::saveRDS(
    object = data.table::as.data.table(x = utils::read.csv(
      file = base::unz(description = "data/cache/rumschlag_2023.zip",
                       filename = "github/data/dat_div_NRSA_USGS_4Jan.csv"),
      header = TRUE, sep = ",", stringsAsFactors = TRUE)),
    file = "data/raw data/rumschlag_2023/rdata.rds")
}

ddata <- base::readRDS(file = "data/raw data/rumschlag_2023/rdata.rds")

# Communities ----
ddata[, c("X", "sc","sc.CL","Gen_ID_Prop","Agency") := NULL]
data.table::setnames(ddata, new = c("local_richness", "regional_richness",
                                    "year", "regional"))


ddata[, ":="(
  dataset_id = dataset_id,
  local = "all_subplots",

  year = (1993L:2019L)[base::match(year, 1L:27L)]
)]


# Metadata ----
coords <- data.table::data.table(
  regional = as.factor(levels(ddata$regional)),
  latitude = c(32L, 47L, 45L, 37L, 35L, 42L, 45L, 45L, 37L),
  longitude = c(-90L, -75L, -105L, -85L, -100L, -90L, -90L, -120L, -112L)
)

meta <- unique(ddata[, .(dataset_id, regional, local, year)])
meta[coords, ":="(latitude = i.latitude, longitude = i.longitude), on = "regional"]

meta[, ':='(
  taxon = "Invertebrates",
  realm = "Freshwater",

  effort = 1L,
  study_type = "resurvey",

  data_pooled_by_authors = FALSE,

  alpha_grain = 1.021933,
  alpha_grain_unit = "m2",
  alpha_grain_type = "sample",
  alpha_grain_comment = "NRSA wadeable stream sampling: 11 1square foot samples per site",

  gamma_sum_grains_unit = "m2",
  gamma_sum_grains_type = "sample",
  gamma_sum_grains_comment = "local sample sampled area times average number of sites per region",

  gamma_bounding_box = 8080464.3 / 9,
  gamma_bounding_box_unit = "km2",
  gamma_bounding_box_type = "functional",
  gamma_bounding_box_comment = "average area of the ecoregion",

  comment = "Extracted from figshare repository Rumschlag, Samantha (2023). Density declines, richness increases, and composition shifts in stream macroinvertebrates. figshare. Journal contribution. https://doi.org/10.6084/m9.figshare.22266046.v1
METHODS found in https://doi.org/10.1126/sciadv.adf4896: 'We derived site-level density and α and region-level ᾱ, γ, and β diversity metrics for macroinvertebrate communities, within the orders Arthropoda, Mollusca, and Annelida, using data from federal biomonitoring programs in the United States that spanned 27 years, from 1993 until 2019 (Fig. 1 and figs. S1 and S2). These programs included six U.S. EPA federal projects and 64 USGS federal and regional projects (table S1). We refer to EPA and USGS as two agencies. Overall, the dataset was based on 3914 unique EPA sites and 2217 unique USGS sites. Regions used in the present analyses are ecoregions, which are areas of grossly similar environmental characteristics, such as climate, vegetation, soil type, and geology, as defined by the EPA National Aquatic Resource Surveys'
Effort, ie number of sites per region, is unknown but it is large: in the hundreds
Coordinates for regions were estimated on the map in https://doi.org/10.1126/sciadv.adf4896
",
  doi = 'https://doi.org/10.6084/m9.figshare.22266046.v1 | https://doi.org/10.1126/sciadv.adf4896'
)][, gamma_sum_grains := (3914 / 9 + 2217 / 9) * alpha_grain]


dir.create(paste0('data/wrangled data/', dataset_id), showWarnings = FALSE)
data.table::fwrite(
  x = ddata,
  file = paste0('data/wrangled data/', dataset_id, "/", dataset_id, '.csv'),
  row.names = FALSE)
data.table::fwrite(
  x = meta,
  file = paste0('data/wrangled data/', dataset_id, "/", dataset_id, '_metadata.csv'),
  row.names = FALSE)
