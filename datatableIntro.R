#
# My experiments following the data.table vignette 1
#
# https://rawgit.com/wiki/Rdatatable/data.table/vignettes/datatable-intro.html
#
library(magrittr)
library(data.table)

# read the data
flights <- fread("https://raw.githubusercontent.com/wiki/arunsrinivasan/flights/NYCflights14/flights14.csv")

DT = data.table(ID = c("b","b","b","a","a","c"), a = 1:6, b = 7:12, c = 13:18)

# How data.table enhances regular data.frames
#
# DT[i, j, by]
# 
# ##   R:      i                 j        by
# ## SQL:  where   select | update  group by  

#
# 1) Subsetting rows (i)
#

flights[origin == "JFK" & month == 6L]  # within data.table, columns are variables!

flights[order(origin, -dest)] # order by origin (ascending) and dest (descending)
                              # order in data.tables [...] is not base order, but
                              # the internal data.table forder(), much faster

#
# 2) Subsetting columns (j)
#

flights[, arr_delay]        # returns a vector
flights[, list(arr_delay)]  # returns a data.table
flights[, .(arr_delay)]     # .() is an alias for list()

flights[, .(delay_arr=arr_delay, delay_dep=dep_delay)] # select and rename columns

flights[, c("arr_delay", "dep_delay"), with=FALSE] # select using column names

flights[, year:day] # select range of columns
flights[, -(year:day), with=FALSE] # select all BUT these columns

# data.table j can handle expresions and compute over columns as variables
flights[, sum((arr_delay+dep_delay)<0)]

# this can be combined with subsets from i
flights[origin == "JFK" & month == 6L,
        .(m_arr=mean(arr_delay), m_dep=mean(dep_delay))]

# .N - special symbol for number of rows. in selection. Can be used with groups 
flights[origin == "JFK" & month == 6L, .N]

#
# 3) aggregation (by)
#

flights[,.(.N), by=.(origin)]

# number of flights by American Airlines between each airport
flights[carrier=="AA", .N, by=.(origin, dest)]

# add average delays each month
flights[carrier=="AA", 
        .(count=.N, AvgArrDelay=mean(arr_delay), AvgDepDelay=mean(dep_delay)),
        by=.(origin, dest, month)]

# keyby - automatically sort the groups
flights[carrier=="AA", 
        .(count=.N, AvgArrDelay=mean(arr_delay), AvgDepDelay=mean(dep_delay)),
        keyby=.(origin, dest, month)]


# chaining - data.table version of %>% 
flights[,.N,by=.(origin, dest)][
  order(origin, -dest)][
    1:10]

# 'by' can use expressions to make groups
flights[, .N, .(dep_delay>0, arr_delay>0)]

#
# Special symbol - .SD
# Stands for Subset of Data. It is a data.table holding the data of a current by group
#
DT

# print .SD for each group
DT[,print(.SD), by=ID]   # j expression has side effects

# compute mean of each column and ID using .SD
DT[, lapply(.SD, mean), by=ID]

# use .SDcols to choose a subset of .SD columns to operate on
DT[, lapply(.SD, mean), by=ID, .SDcols=c("a","c")]

# return first 2 rows of each month group
flights[, head(.SD, 2), by=month]





