dataset_id <- "nielsen_2019"

if (!file.exists("data/raw data/nielsen_2019/rdata.rds")) {
  # Downloading data ----
  #   if (!file.exists("data/cache/green_2021_suplementary.docx")) {
  #     curl::curl_download(
  #       url = "https://onlinelibrary.wiley.com/action/downloadSupplement?doi=10.1111%2Fddi.13387&file=ddi13387-sup-0001-Supinfo.docx",
  #       destfile = "data/cache/green_2021_suplementary.docx",
  #       mode = "wb"
  #     )
  #   }
  # Extracting data from docx appendix ----
  rdata <- docxtractr::docx_extract_tbl(
    docx = docxtractr::read_docx(path = "data/cache/nielsen_2019/ele13361-sup-0001-appendixs1.docx"),
    tbl_number = 1L
  )

  data.table::setDT(rdata)

  base::dir.create(path = "data/raw data/nielsen_2019/", showWarnings = FALSE)
  base::saveRDS(rdata, file = "data/raw data/nielsen_2019/rdata.rds")
}

# Data preparation ----
ddata <- base::readRDS(file = "data/raw data/nielsen_2019/rdata.rds")

ddata <- data.table::melt(data = ddata,
                          id.vars = c("Number...Region.name", "Year.issued", "Area.km2"),
                          measure.vars = c("X.species.historical.data","X.species.present.data"),
                          variable.name = "year")
data.table::setnames(ddata,
                     old = c("Number...Region.name", "Area.km2"),
                     new = c("local", "alpha_grain"))

ddata <- unique(ddata[, local_richness := mean(as.integer(value)),
                      by = year][, .(
                        dataset_id = dataset_id,
                        regional = "Denmark",
                        local = "all_sites",

                        year = data.table::fifelse(grepl("historical", year),
                                                   as.integer(mean(as.integer(Year.issued))),
                                                   2019L),
                        local_richness,
                        alpha_grain = mean(as.numeric(alpha_grain))
                        )])[, regional_richness := c(1367L, 1822L)]


# Metadata ----

meta <- unique(ddata[, .(dataset_id, regional, local, year, alpha_grain)])
meta[, ':='(
  taxon = "Plants",
  realm = "Terrestrial",

  latitude =  55.3,
  longitude = 11.3,

  effort = 14L,
  study_type = "checklist",

  data_pooled_by_authors = TRUE,
  data_pooled_by_authors_comment = "Original surveys happened between 1857 and 1883. Atlas Flora Danica was 1992-2012",
  sampling_years = c("1857-1883", "1992-2012"),

  alpha_grain_unit = "km2",
  alpha_grain_type = "administrative",
  alpha_grain_comment = "mean region area given by the authors",

  gamma_bounding_box = 6245L,
  gamma_bounding_box_unit = "km2",
  gamma_bounding_box_type = "administrative",
  gamma_bounding_box_comment = "total sampled area",

  gamma_sum_grains =  alpha_grain * 14L,
  gamma_sum_grains_unit = "km2",
  gamma_sum_grains_type = "administrative",
  gamma_sum_grains_comment = "sum of the areas of the 14 regions",

  comment = "Extracted from Appendix 1 https://doi.org/10.1111/ele.13361. Methods: 'we searched all repositories, including the botanical collections at the Natural History Museum of Denmark, from published and unpublished local to regional floras from the times of Lin- naeus to year 1900 (see also Pedersen 2015)[...]We carefully selected 14 comprehensive floras, of which the authors explicitly stated an aim to include all wild species[...]The 14 study regions – all situated in Denmark – vary in spatial extent between 22 and 1800 km2 and include five smal- ler islands, four larger islands and five tracts of mainland areas[...]Present data were gathered from the most recent national plant survey, Atlas Flora Danica (AFD), carried out between 1992 and 2012 by the Danish Botanical Society in 5 9 5 km grid cells (Hartvig & Vestergaard 2015). To spatially match historical with present data, AFD data were compiled from the grid cells best corresponding to the historical region[...]' Effort is the number of regions that were resurveyed. There is also a Dryad repository https://doi.org/10.5061/dryad.qv3811j",
  doi = 'https://doi.org/10.1111/ele.13361'
)]

ddata[, alpha_grain := NULL]

dir.create(paste0('data/wrangled data/', dataset_id), showWarnings = FALSE)
data.table::fwrite(
  x = ddata,
  file = paste0('data/wrangled data/', dataset_id, "/", dataset_id, '.csv'),
  row.names = FALSE)
data.table::fwrite(
  x = meta,
  file = paste0('data/wrangled data/', dataset_id, "/", dataset_id, '_metadata.csv'),
  row.names = FALSE)
