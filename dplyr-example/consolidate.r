library('readr') # faster
library('dplyr') # filter and aggregating data
library('TTR') # seasonal adjustment
PATH = '/temp/dplyr-example' # set this to where you stored everything
WIDTHS = c(4, 2, 8, 3, 4, 2, 2, 13, 13, 15, 1) # these are the widths of each
                                               # of the columns in the fixed
                                               # width text file. the numbers
                                               # were specified in
POSITIONS =
COLNAMES = c('year', 'month', 'ncm', 'country', 'port', 'state', 'units',
             'qt', 'kg', 'fob', 'via')

# the original data set had all kinds of exports listed. we are only interested
# in commodities. we know commodities have specific NCMs, according to a table
# published at http://www.mdic.gov.br/arquivo/secex/balanca/TABELAS.xls
NCMS <- c(17011100, 17011300, 17011400, 17019900, 52010010, 52010020, 52010090,
          76011000, 09011110, 02011000, 02012010, 02012020, 02012090, 02013000,
          02021000, 02022010, 02022020, 02022090, 02023000, 02071100, 02071200,
          02071300, 02071400, 02031100, 02031200, 02031900, 02032100, 02032200,
          02032900, 47010000, 47020000, 47031100, 47031900, 47032100, 47032900,
          47041100, 47041900, 47042100, 47042900, 47050000, 47062000, 47063000,
          47069100, 47069200, 47069300, 41011000, 41012000, 41012010, 41012020,
          41012030, 41012110, 41012120, 41012130, 41012210, 41012220, 41012230,
          41012910, 41012920, 41012930, 41013010, 41013020, 41013030, 41014010,
          41014020, 41014030, 41015010, 41015020, 41015030, 41019010, 41019020,
          41019030, 41021000, 41022100, 41022900, 41031000, 41032000, 41033000,
          41039000, 41041011, 41041012, 41041013, 41041020, 41041090, 41041111,
          41041112, 41041113, 41041114, 41041119, 41041121, 41041122, 41041123,
          41041124, 41041129, 41041910, 41041920, 41041930, 41041940, 41041990,
          41042100, 41042211, 41042212, 41042213, 41042219, 41042290, 41042900,
          41043111, 41043119, 41043120, 41043190, 41043911, 41043912, 41043990,
          41044110, 41044120, 41044130, 41044190, 41044910, 41044920, 41044990,
          41051010, 41051021, 41051029, 41051090, 41051100, 41051210, 41051290,
          41051900, 41052010, 41052090, 41053000, 41061100, 41061210, 41061290,
          41061900, 41062010, 41062090, 41062110, 41062121, 41062129, 41062190,
          41062200, 41063110, 41063190, 41063200, 41064000, 41069100, 41069200,
          41071010, 41071090, 41071110, 41071120, 41071190, 41071210, 41071220,
          41071290, 41071910, 41071920, 41071990, 41072100, 41072900, 41079000,
          41079110, 41079190, 41079210, 41079290, 41079910, 41079990, 41080000,
          41090010, 41090020, 41100000, 41110000, 41120000, 41131010, 41131090,
          41132000, 41133000, 41139000, 41141000, 41142010, 41142020, 41151000,
          41152000, 22071000, 22071010, 22071090, 22072010, 22072011, 22072019,
          23040010, 23040090, 24011010, 24011020, 24011030, 24011040, 24011090,
          24012010, 24012020, 24012030, 24012040, 24012090, 24013000, 27100021,
          27100029, 27101151, 27101159, 27101251, 27101259, 72081000, 72082500,
          72082610, 72082690, 72082710, 72082790, 72083610, 72083690, 72083700,
          72083810, 72083890, 72083910, 72083990, 72084000, 72085100, 72085200,
          72085300, 72085400, 72089000, 72091500, 72091600, 72091700, 72091800,
          72092500, 72092600, 72092700, 72092800, 72099000, 72101100, 72101200,
          72102000, 72103010, 72103090, 72104110, 72104190, 72104910, 72104990,
          72105000, 72106100, 72106900, 72106911, 72106919, 72106990, 72107010,
          72107020, 72109000, 72111300, 72111400, 72111900, 72112300, 72112910,
          72112920, 72119010, 72119090, 72121000, 72122010, 72122090, 72123000,
          72124010, 72124020, 72124021, 72124029, 72125000, 72125010, 72125090,
          72126000, 72191100, 72191200, 72191300, 72191400, 72192100, 72192200,
          72192300, 72192400, 72193100, 72193200, 72193300, 72193400, 72193500,
          72199010, 72199090, 72201100, 72201210, 72201220, 72201290, 72202010,
          72202090, 72209000, 72251100, 72251900, 72252000, 72253000, 72254010,
          72254020, 72254090, 72255000, 72255010, 72255090, 72259100, 72259200,
          72259900, 72259910, 72259990, 72261100, 72261900, 72262010, 72262090,
          72269100, 72269200, 72269300, 72269400, 72269900, 10059010, 10059090,
          26011100, 26011200, 26012000, 26011210, 26011290, 15071000, 27100041,
          27100042, 27100049, 27101921, 27101922, 27101929, 38260000, 27090010,
          72061000, 72069000, 72071110, 72071190, 72071200, 72071900, 72072000,
          72189100, 72189900, 72249000, 12010010, 12010090, 12011000, 12019000,
          20091100, 20091200, 20091900)

# create a list of the files in the directory
files <- list.files(path=PATH, pattern="*.txt", full.names=T, recursive=FALSE)

# 'results' is where we will hold the final data. for now, it has 4 columns
results <- data.frame(year=numeric(), month=numeric(),
                      fob=numeric(), kg=numeric())

# loop through the files
for (i in seq(1, length(files))) {
    # impexp <- tolower(substr(basename(filename), start=1, stop=3)) # NOT USED
    filename <- files[i]

    # progress bar because why not
    cat(sprintf('\rAppending file: %s [%s] (%s/%s)',
                basename(filename),
                paste(
                    paste(rep('-', i), sep="", collapse=""),
                    paste(rep(' ', length(files) - i), sep="", collapse=""),
                    sep="", collapse=""),
                i,
                length(files)))

    # load the fixed width file with 'readr' package because it's blazing fast.
    # the Map call in col_types is a shortcut to generate args-values pairs
    # for the cols() function, which is a requirement, unfortunately.
    # basically we want to call cols(year='n', month='n', ...) and so on,
    # where each argument is an element in the COLNAMES variable from the
    # beginning of the script
    filedata <- read_fwf(
        filename,
        col_positions=fwf_widths(WIDTHS, col_names=COLNAMES),
        col_types=do.call(cols, Map(function(x) 'n', COLNAMES)),
        progress=F) # don't show a progress bar. we have our own.

    # use dplyr to filter and aggregate data
    filedata.agg <- filedata %>%
        filter(ncm %in% NCMS) %>%
        group_by(year, month) %>%
        select(year, month, kg, fob) %>%
        summarize(fob=sum(as.numeric(fob)) / 1000000,
                  volume=sum(as.numeric(kg)) / 1000000)

    # store this single file's aggregate data into the results variable
    results <- rbind(results, filedata.agg)

    # remove these from memory to prevent memory leak. not sure if necessary,
    # but I added it just in case, because the files are huge.
    rm(filedata.agg, filedata)
}

# create date column
results$date <- sprintf('%04d-%02d', results$year, results$month)
results <- results[,c('date', 'fob', 'volume')]

# create log of columns and seasonally adjusted (sa) columns
results$fob.sa <- SMA(results$fob, n=12)
results$volume.sa <- SMA(results$volume, n=12)
results$fob.log <- log(results$fob)
results$volume.log <- log(results$volume)
results$fob.log.sa <- SMA(results$fob.log, n=12)
results$volume.log.sa <- SMA(results$volume.log, n=12)

# import the total exports data set and create a seasonally adjusted column too
exports <- read_csv('exports.csv')
exports$exports.sa <- SMA(exports$exports, n=12)

results <- left_join(results, exports) # I love you, Hadley!

cat('\nWriting CSV file... ')
write.csv(results, 'dplyr-example.csv', append=F, na="")
cat('Done.\n')
