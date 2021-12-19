## hibit_2019
dataset_id <- 'hibit_2019'

ddata <- data.table::fread(paste0('data/raw data/', dataset_id, '/rdata.csv'), skip = 1)

## melting sites and time periods
ddata <- data.table::melt(ddata,
              id.vars = 'species',
              variable.name = 'temp'
)
# splitting period and local
ddata[, c('year', 'local') := data.table::tstrsplit(temp, ' (?=Plot)', perl = TRUE)][,
                                                     temp := NULL]

ddata <- ddata[ value > 0 & !is.na(value) ]

# standardisation by rarefaction
effort <- data.table::data.table(
   year = c('1970', '2017'),
   'Plot 1' = c(100, 400),
   'Plot 2' = c(400, 400),
   'Plot 3' = c(400, 400),
   'Plot 4' = c(600, 400),
   'Plot 5' = c(1200, 400),
   'Plot 6' = c(600, 400),
   'Plot 7' = c(1000, 400)
)

effort <- data.table::melt(effort, id.vars = 'year', value.name = 'effort', variable.name = 'local')
ddata <- merge(ddata, effort, by = c('local', 'year'))

ddata[, value := as.integer(value * (effort / 10000))] # converting density to the original abundance
ddata <- ddata[!local %in% c("Plot 1", "Plot 2")]

minN <- min(ddata[, .(N = sum(value)), by = .(local, year)]$N)
ddata[, local_richness := mobr::rarefaction(x = value, method = "IBR", effort = minN), by = .(local, year)][,regional_richness := length(unique(species))][, species := NULL][, value := NULL]
ddata <- unique(ddata)


ddata[, ':='(
   dataset_id = dataset_id,
   regional = 'Hawaii',

   period = c('historical', 'recent')[match(year, c('1970', '2017'))],
   timepoints = paste0('T', 1:2)[match(year, c('1970', '2017'))]
)]

meta <- unique(ddata[, .(regional, local, period, year, effort)])

meta[, ':='(
   dataset_id = dataset_id,
   realm = "Terrestrial",
   taxon = "Plants",

   study_type = 'resurvey',
   effort = 1L,

   data_pooled_by_authors = FALSE,

   latitude = c('21°34`25.62"N', '21°34`18.39"N', '21°34`19.56"N', '21°32`58.61"N', '21°34`12.62"N', '21°31`34.61"N', '21°31`25.61"N')[match(local, paste('Plot', 1:7))],
   longitude = c('158°12`30.07"W','158°12`37.41"W', '158°12`39.10"W','158°10`48.09"W','158°12`4.07"W','158° 9`19.09"W','158° 9`10.09"W')[match(local, paste('Plot', 1:7))],

   alpha_grain = effort,
   alpha_grain_unit = 'm2',
   alpha_grain_type = 'sample',
   alpha_grain_comment = 'area of the sampling sites',

   gamma_bounding_box = 1545L,
   gamma_bounding_box_unit = 'km2',
   gamma_bounding_box_type = "island",
   gamma_bounding_box_comment = "area of the Island of Oahu Hawaii",

   gamma_sum_grains_unit = "m2",
   gamma_sum_grains_type = "sample",
   gamma_sum_grains_comment = "sum of sampled areas per year",

   comment = "Extracted from Hibit et al 2019 table 4. Authors resurveyed plots in 2017 that were originally sampled in 1970 to assess native and exotic species dynamics. Despite different sampling efforts, the authors tried to reproduce original method and plot delimitations hence the resurvey categorisation. 'The sites used by Hatheway and Wirawan were located using coordinates provided in each study, [...]These coordinates did not always exactly match site descriptions, so they were compared with site pictures, slopes, elevations, and plant community compositions to obtain the best fit for where each site originally existed.[...]For consistency, our study utilized a standardized plot size of 20 × 20 m (400m2). These plots were square, rather than the circular plots which had been utilized by Wirawan (1974). Due to variability in plot sizes in 1970, plots 4–7 were larger in 1970 than 2017 (Table 1).' Regional is the whole island. Local is a semi-permanent sampling site. ",
   comment_standardisation = "Varying effort has been standardised by excluding Plots 1 and 2 and rarefying the communities to the smallest observed sampled abundance (Nmin = 105)."
)][, gamma_sum_grains :=  sum(alpha_grain), by = .(local, year)]

ddata[, effort := NULL]

dir.create(paste0('data/wrangled data/', dataset_id), showWarnings = FALSE)
data.table::fwrite(ddata, paste0('data/wrangled data/', dataset_id, "/", dataset_id, '.csv'),
       row.names = FALSE)

data.table::fwrite(meta, paste0('data/wrangled data/', dataset_id, "/", dataset_id, '_metadata.csv'),
       row.names = FALSE)
