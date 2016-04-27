#
# data.table course, beginner
#
library(data.table)

# data.table arguments
# DT[i, j, by]:
#   i - select rows
#   j - select or transform columns
#   by - group by

#
# Exercise 1
#

# Create my_first_data_table
DT1 <- data.table(x=letters[1:5], y=1:5)

# Create a data.table using recycling
DT <- data.table(a=1:2, b=LETTERS[1:4])

# Print the third row to the console
DT[3]

# Print the second and third row to the console, but do not commas
DT[2:3]

#
# Exercise 2
#

# Print the penultimate row of DT using .N (.N is a special character for number of rows)
DT[.N-1]   

# Print the column names of DT, and number of rows and number of columns
names(DT)
nrow(DT)
ncol(DT)

# Select row 2 twice and row 3, returning a data.table with three rows where row 2 is a duplicate of row 1.
DT[c(2,2,3)]

#
# Exercise 3
#
DT <- data.table(A=1:5, B=letters[1:5], C=6:10)

# return a data.table
DT[,.(B)]

# return a vector
DT[,B]

#
# Exercise 4
#
D <- 5

# column slot j (DT[i,j,by]) can apply any function to columns as if they were variables
# It applies it to the DT environment.
# if the column is not present, it will look in the parent environment
# Any function can be used, for example plot, which will run its side effects and return NULL
DT[,D]
DT[,.(D)]  # .() construct always returns a data.frame

#
# Exercise 5
#

# Subset rows 1 and 3, and columns B and C
DT[c(1,3), .(B,C)]

# Assign to ans the correct value
ans <- DT[,(.(B=B,val=A*C))]

# Fill in the blanks such that ans2 equals target
target <- data.table(B = c("a", "b", "c", "d", "e", "a", "b", "c", "d", "e"), 
                     val = as.integer(c(6:10, 1:5)))
ans2 <- DT[, .(B, val = cbind(C,A) )]

#
# Lecture 3: group by
#
DT <- data.table(A=letters[3:1], B=1:6)
DT[, .(Sum=sum(B), Mean=mean(B)), by=.(A)] # simple group by

DT <- data.table(A=1:6, B=10:15)
DT[,.(Sum=sum(B)), by=.(A%%2)]   # define groups with functions

DT[,sum(B), by=A%%2]   # if j and by are only one expression, there is no need for .() 

#
# Exercise 6
#

# Convert iris to a data.table: DT
DT <- as.data.table(iris)

# For each Species, print the mean Sepal.Length
DT[, .(Mean.Sepal.Length=mean(Sepal.Length)), by=.(Species)]

# Print mean Sepal.Length, grouping by first letter of Species
DT[, .(Mean.Sepal.Length=mean(Sepal.Length)), by=.(FirstLetter=substr(Species,1,1))]

#
# Exercise 7
#

# data.table version of iris: DT
DT <- as.data.table(iris)

# Group the specimens by Sepal area (to the nearest 10 cm2) and count how many occur in each group.
DT[, .N , by =10* round( Sepal.Length * Sepal.Width / 10)]

# Now name the output columns `Area` and `Count`
DT[, .(Count=.N) , by = .(Area=10* round( Sepal.Length * Sepal.Width / 10))]

#
# Exercise 8
#

# Create the data.table DT
set.seed(1L)
DT <- data.table(A=rep(letters[2:1], each=4L), B=rep(1:4, each=2L), C=sample(8))

# Create the new data.table, DT2
DT2 <- DT[,.(C=cumsum(C)), by=.(A,B)]

# Select from DT2 the last two values from C while you group by A
DT2[, .(C=C[(.N-1):.N]), by=.(A)]


