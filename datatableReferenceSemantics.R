#
# data.table vignette: Reference semantics
#
# https://rawgit.com/wiki/Rdatatable/data.table/vignettes/datatable-reference-semantics.html
#
library(magrittr)
library(data.table)

# read the data
flights <- fread("https://raw.githubusercontent.com/wiki/arunsrinivasan/flights/NYCflights14/flights14.csv")
