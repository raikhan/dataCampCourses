#
# Efficient reshaping with data.table
#
# https://rawgit.com/wiki/Rdatatable/data.table/vignettes/datatable-reshape.html
#
library(magrittr)
library(data.table)

# read the data
DT <- fread("https://raw.githubusercontent.com/Rdatatable/data.table/master/vignettes/melt_default.csv")
DT2 <- fread("https://raw.githubusercontent.com/Rdatatable/data.table/master/vignettes/melt_enhanced.csv")

#
# melt (wide to long)
#
DT.m1 <- melt(DT, id.vars = c("family_id", "age_mother"),
              measure.vars = c("dob_child1", "dob_child2", "dob_child3"),
              variable.name = "child",
              value.name = "dob")
#
# dcast (long to wide)
#
dcast(DT.m1, family_id+age_mother~child, value.var = "dob")

# dcast can be used to aggregate
dcast(DT.m1, family_id~., fun.aggregate = function(x) sum(!is.na(x)), value.var = "dob")

#
# Advanced melt
#

# melt multiple columns simultaneously
colA = paste("dob_child", 1:3, sep = "")
colB = paste("gender_child", 1:3, sep = "")
DT.m2 = melt(DT2, measure = list(colA, colB), value.name = c("dob", "gender"))
DT.m2

# use patterns() to select columns
DT.m2 = melt(DT2, measure = patterns("^dob", "^gender"), 
             value.name = c("dob", "gender"))
DT.m2

## new 'cast' functionality - multiple value.vars
DT.c2 = dcast(DT.m2, family_id + age_mother ~ variable, value.var = c("dob", "gender"))
DT.c2

