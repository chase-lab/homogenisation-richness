## merging Wrangled data.frames

# Merging ----
listfiles <- list.files('./data/wrangled data', pattern = '[[:digit:]](a|b)?\\.csv',
                        full.names = TRUE, recursive = T)
listfiles_metadata <- list.files('data/wrangled data', pattern = '_metadata.csv',
                                 full.names = TRUE, recursive = T)

template <- utils::read.csv('data/template_communities.txt', h = TRUE, sep = '\t')
column_names_template <- template[,1]

lst <- lapply(listfiles, data.table::fread)
dt <- data.table::rbindlist(lst, fill = TRUE)

template_metadata <- utils::read.csv('data/template_metadata.txt', h = TRUE, sep = '\t')
column_names_template_metadata <- template_metadata[,1]

lst_metadata <- lapply(listfiles_metadata, data.table::fread)
meta <- data.table::rbindlist(lst_metadata, fill = TRUE)




## Counting the study cases ----
dt[,.(nsites = length(unique(local))), by = dataset_id][order(nsites, decreasing = T)]

# Ordering ----
data.table::setcolorder(dt, intersect(column_names_template, colnames(dt)))
dt <- dt[order(dataset_id, regional, local, period, year)]

# Temporary fix of timepoints ----
dt[, timepoints := as.integer(gsub('T', '', timepoints))]

# Temporary fix of period ----
dt[ timepoints == '1', period := 'first']
dt[, ismax := timepoints == max(timepoints), by = dataset_id][ (ismax), period := 'last'][, ismax := NULL]
dt[ !period %in% c('first','last'), period := 'intermediate']

# * checking timepoints ----
if (!all(dt[, (check = which.max(year) == which.max(timepoints)), by = dataset_id]$check)) warning('timepoints order has to be checked')

# Saving dt ----
data.table::fwrite(dt, 'data/communities.csv', row.names = F)
# data.table::fwrite(dt, 'C:/Users/as80fywe/Dropbox/BioTIMEx/Local-Regional Homogenization/_richness/communities.csv', row.names = F)



# Metadata ----

# Checking metadata
unique(meta$taxon)
unique(meta$realm)

# Converting alpha grain and gamma extent units ----
meta[, alpha_grain := as.numeric(alpha_grain)
][,
  alpha_grain := data.table::fifelse(alpha_grain_unit == 'mile2',
                         alpha_grain / 0.00000038610,
                         data.table::fifelse(alpha_grain_unit == 'km2',
                                 alpha_grain * 1000000,
                                 data.table::fifelse(alpha_grain_unit == 'acres',
                                         alpha_grain * 4046.856422,
                                         data.table::fifelse(alpha_grain_unit == 'ha',
                                                 alpha_grain * 10000,
                                                 data.table::fifelse(alpha_grain_unit == 'cm2',
                                                         alpha_grain / 10000,
                                                         alpha_grain)
                                         )
                                 )
                         )
  )
][, alpha_grain_unit := NULL]

meta[, gamma_bounding_box := as.numeric(gamma_bounding_box)
][,
  gamma_bounding_box := data.table::fifelse(gamma_bounding_box_unit == 'm2',
                                      gamma_bounding_box / 1000000,
                                      data.table::fifelse(gamma_bounding_box_unit == 'mile2',
                                                          gamma_bounding_box * 2.589988,
                                                          data.table::fifelse(gamma_bounding_box_unit == 'ha',
                                                                              gamma_bounding_box / 100,
                                                                              gamma_bounding_box)
                                      )
  )
][, gamma_bounding_box_unit := NULL]

meta[, gamma_sum_grains := as.numeric(gamma_sum_grains)
][,
  gamma_sum_grains := data.table::fifelse(gamma_sum_grains_unit == 'm2',
                                      gamma_sum_grains / 1000000,
                                      data.table::fifelse(gamma_sum_grains_unit == 'mile2',
                                                          gamma_sum_grains * 2.589988,
                                                          data.table::fifelse(gamma_sum_grains_unit == 'ha',
                                                                              gamma_sum_grains / 100,
                                                                              gamma_sum_grains)
                                      )
  )
][, gamma_sum_grains_unit := NULL]

data.table::setnames(meta, c('alpha_grain', 'gamma_bounding_box', 'gamma_sum_grains'), c('alpha_grain_m2', 'gamma_bounding_box_km2','gamma_sum_grains_km2'))

# Converting coordinates into a common format with parzer ----
meta[, ":="(latitude = parzer::parse_lat(latitude), longitude = parzer::parse_lon(longitude))]

# Ordering metadata ----
meta <- meta[order(dataset_id, regional, local, period, year)]
data.table::setcolorder(meta, intersect(column_names_template_metadata, colnames(meta)))


## checking encoding ----
for (i in seq_along(lst_metadata)) if (any(!unlist(unique(apply(lst_metadata[[i]][, c("local","regional","comment")], 2, Encoding))) %in% c("UTF-8","unknown"))) warning(paste0("Encoding issue in ", listfiles[i]))


# Checks ----
## checking encoding ----
for (i in seq_along(lst_metadata)) if (any(!unlist(unique(apply(lst_metadata[[i]][, c("local","regional","comment")], 2, Encoding))) %in% c("UTF-8","unknown"))) warning(paste0("Encoding issue in ", listfiles[i]))

## checking year range homogeneity among regions ----
if (any(meta[, length(unique(paste(range(year), collapse = "-"))), by = .(dataset_id, regional)]$V1 != 1L)) warning("all local scale sites were not sampled for the same years and timepoints has to be consistent with years")

## checking effort ----
unique(meta[effort == 'unknown' | is.na(effort), .(dataset_id, effort)])

## checking alpha_grain_type ----
if (any(!unique(meta$alpha_grain_type) %in% c("island", "plot", "administrative", "watershed", "sample", "lake_pond", "archipelago", "trap", "transect", "ecosystem", "functional"))) warning(paste("Invalid alpha_grain_type value in", unique(meta[!alpha_grain_type %in% c("island", "plot", "administrative", "watershed", "sample", "lake_pond", "archipelago", "trap", "transect", "ecosystem", "functional"), dataset_id]), collapse = ", "))

## checking gamma_sum_grains_type & gamma_bounding_box_type ----
if (any(!na.omit(unique(meta$gamma_sum_grains_type)) %in% c("archipelago", "administrative", "watershed", "sample", "lake_pond", "plot", "quadrat", "transect", "ecosystem", "functional", "box"))) warning(paste("Invalid gamma_sum_grains_type value in", paste(unique(meta[!gamma_sum_grains_type %in% c("archipelago", "administrative", "watershed", "sample", "lake_pond", "plot", "quadrat", "transect", "ecosystem", "functional", "box"), dataset_id]), collapse = ", ")))

if (any(!na.omit(unique(meta$gamma_bounding_box_type)) %in% c("administrative", "island", "functional", "convex-hull", "watershed", "box", "buffer", "ecosystem", "shore"))) warning(paste("Invalid gamma_bounding_box_type value in", paste(unique(meta[!gamma_bounding_box_type %in% c("administrative", "island", "functional", "convex-hull", "watershed", "box", "buffer", "ecosystem", "shore"), dataset_id]), collapse = ", ")))

## checking units ----
if (any( !na.omit(unique(meta$alpha_grain_unit)) %in%  c("acres", "ha", "km2", "m2","cm2", "mile2"))) warning("Non standard unit in alpha")
if (any( !na.omit(unique(meta$gamma_sum_grains_unit)) %in%  c("acres", "ha", "km2", "m2", "mile2"))) warning("Non standard unit in gamma_sum_grains")
if (any( !na.omit(unique(meta$gamma_bounding_box_unit)) %in%  c("acres", "ha", "km2", "m2", "mile2"))) warning("Non standard unit in gamma_bounding_box")

# Checking that all data sets have both community and metadata data ----
if (length(base::setdiff(unique(dt$dataset_id), unique(meta$dataset_id))) > 0) warning('Incomplete community or metadata tables')
if (nrow(meta) != nrow(unique(meta[, .(dataset_id, regional, local, year, period)]))) warning("Redundant rows in meta")
if (nrow(meta) != nrow(unique(dt[, .(dataset_id, regional, local, year, period)]))) warning("Discrepancies between dt and meta")




# Saving meta ----
data.table::fwrite(meta, 'data/metadata.csv', row.names = F)

# data.table::fwrite(meta, 'C:/Users/as80fywe/Dropbox/BioTIMEx/Local-Regional Homogenization/_richness/metadata.csv', row.names = F)
