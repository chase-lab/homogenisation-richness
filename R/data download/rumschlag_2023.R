# rumschlag_2023
if (!base::file.exists('data/raw data/rumschlag_2023/rdata.rds')) {
   if (!base::file.exists('data/cache/rumschlag_2023.zip'))
      base::download.file(url = 'https://figshare.com/ndownloader/files/39582949',
                          destfile = 'data/cache/rumschlag_2023.zip', mode = 'wb')

   utils::unzip('data/cache/rumschlag_2023.zip', exdir = 'data/cache/rumschlag_2023')

   data.table::fread(file = 'data/cache/rumschlag_2023//github/data/invertsfam.csv',
                     sep = ',', header = TRUE, stringsAsFactors = TRUE)

   base::dir.create(path = 'data/raw data/rumschlag_2023/', showWarnings = FALSE)
   base::saveRDS(object = rdata, file = 'data/raw data/rumschlag_2023/rdata.rds')
}
