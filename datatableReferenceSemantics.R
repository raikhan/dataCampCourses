#
# data.table vignette: Reference semantics
#
# https://rawgit.com/wiki/Rdatatable/data.table/vignettes/datatable-reference-semantics.html
#
# Adding, updating and deleting columns by reference using :=
#
library(magrittr)
library(data.table)

# read the data
flights <- fread("https://raw.githubusercontent.com/wiki/arunsrinivasan/flights/NYCflights14/flights14.csv")

#
# 1) Add columns
#

# two forms of := usage
flights[, `:=`(speed = distance/(air_time/60),  # speed in mph
               delay = arr_delay + dep_delay)]  # total delay in minutes

flights[,c("speed", "delay") := list(speed = distance/(air_time/60),
                                     delay = arr_delay + dep_delay)]

#
# 2) Changing column values
#
flights[, sort(unique(hour))]  # 25 unique values because 24 should be 0
flights[hour==24L, hour :=0L]

#
# 3) Delete column
#
flights[, c("delay"):=NULL]
# flights[, delay:=NULL] # if only one column is affected
# or 
flights[, `:=`(delay=NULL)]

#
# 4) := with group by
#
flights[, max_speed := max(speed), by=.(origin, dest)]

#
# 5) Add multiple columns with := and .SD
#
in_cols <- c("arr_delay", "dep_delay")
out_cols <- c("max_arr_delay", "max_dep_delay")
flights[, c(out_cols) := lapply(.SD, max), by=month, .SDcols=in_cols ]

#
# 6) Remove multiple columns
#
flights[, c("speed", "max_speed", "max_arr_delay", "max_dep_delay"):=NULL]

#
# Using := without updating DT - copy()
#

foo <- function(DT) {
  DT <- copy(DT)  # this makes a deep copy of the input DT. Then, function operates on it.
  DT[, speed := distance / (air_time / 60)]
  DT[, .(max_speed = max(speed)), by=month]  
}
foo(flights)
"speed" %in% (flights %>% names)  # flights does not have a "speed" column, even though we used :=

# 
# Adding columns by reference changes column names even when they are stored in other variables
# 
DT <-  data.table(x=1L, y=2L)
DT_n <- names(DT)
DT[, z:= 3L]  # add a column
DT_n          # name also appears in the list of column names !!!
              # copy(names(DT)) to avoid this (just like in Python)






