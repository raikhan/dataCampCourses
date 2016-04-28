#
# Keys and fast binary search based subset vignette
#
# https://rawgit.com/wiki/Rdatatable/data.table/vignettes/datatable-keys-fast-subset.html
#
# Keys are effectively row names in Pandas (can have multiple levels)
# But also, it allows MUCH faster subsetting (binary vs vector search)
#
library(magrittr)
library(data.table)

# read the data
flights <- fread("https://raw.githubusercontent.com/wiki/arunsrinivasan/flights/NYCflights14/flights14.csv")

set.seed(1L)
DF = data.frame(ID1 = sample(letters[1:2], 10, TRUE),
                ID2 = sample(1:3, 10, TRUE),
                val = sample(10),
                stringsAsFactors = FALSE,
                row.names = sample(LETTERS[1:10]))
rownames(DF)

DT <- as.data.table(DF)
rownames(DT)    # data.tables never have row names
# to preserve row names from data.frame, use keep.rownames=TRUE
DTn <- as.data.table(DF, keep.rownames = TRUE) # adds 'rn' column with row names

# Two ways to set a key
setkey(flights, origin)
# or
setkeyv(flights, "origin")   # for programmatically setting keys

# once the key is set, the data.table can be subset by querrying the key column with .()
flights[.("JFK")]
# or 
flights[J("JFK")]
# or
flights[list("JFK")]

key(flights)  # get the column name of the key

#
# Multiple keys: order by first, then by second etc.
# 
setkey(flights, origin, dest)
key(flights)

flights[.("JFK")]   # can still subset on first key only
flights[.(unique(origin), "MIA")]   # this is how to subset on second key alone

# use keys to sub-assign
flights[, sort(unique(hour))] # 24 should be 0
setkey(flights, hour)
key(flights) # "hour"
flights[.(24), hour:=0L]
key(flights) # NULL - that's because the values of the key column have changed

#
# mult argument - select which rows are returned by subsetting 
# (default is 'all')
#
setkey(flights, origin, dest)
flights[.("JFK", "MIA")] %>% nrow()
flights[.("JFK", "MIA"), mult="first"]
flights[.("JFK", "MIA"), mult="last"]

#
# nomatch argument - select whether unmatched rows are skipped or returned as NA
#
flights[.(c("JFK","LGA", "EWR"), "XNA"), mult="last"]
flights[.(c("JFK","LGA", "EWR"), "XNA"), mult="last", nomatch=0L]


