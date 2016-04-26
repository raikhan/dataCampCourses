#
# googleVis course
#
# https://campus.datacamp.com/courses/having-fun-with-googlevis
# 

# Load rdatamarket and initialize client
library(magrittr)

library("rdatamarket")
dminit(NULL)

# Pull in life expectancy and population data
life_expectancy <- dmlist("15r2!hrp")
population <- dmlist("1cfl!r3d")

# Inspect life_expectancy and population with head() or tail()
head(life_expectancy)
tail(life_expectancy)
head(population)
tail(population)
     
# Load in the yearly GDP data frame for each country as gdp
gdp <- dmlist("15c9!hd1")     
     
# Inspect gdp with tail()
tail(gdp)

#
# Lesson 2
#
# Load in the plyr package
library("plyr")

# Rename the Value for each dataset
names(gdp)[3] <- "GDP"
names(life_expectancy)[3] <- "LifeExpectancy"
names(population)[3] <- "Population"

# Use plyr to join your three data frames into one: development 
gdp_life_exp <- join(gdp, population)
development <- join(gdp_life_exp, life_expectancy)

#
# Lesson 3
#
selection <- c("Afghanistan",    "Australia",      "Austria",        "Belgium",       
               "Bolivia",        "Brazil",         "Cambodia",       "Azerbaijan",    
               "Chile",          "China",          "Denmark",        "Estonia",       
               "Ethiopia",       "Finland",        "France",         "Georgia",       
               "Germany",        "Ghana",          "Greece",         "India",         
               "Indonesia",      "Iraq",           "Italy",          "Japan",         
               "Lithuania",      "Luxembourg",     "Mexico",         "New Zealand",   
               "Niger",          "Norway",         "Poland",         "Portugal",      
               "Rwanda",         "Somalia",        "South Africa",   "Spain",         
               "Sweden",         "Switzerland",    "Turkey",         "Uganda",        
               "Ukraine",        "United Kingdom", "United States",  "Vietnam"   )

# Subset development with Year on or before 2008
development_complete <- subset(development, Year<2009)

# Print out tail of development_complete
tail(development_complete)

# Subset development_complete: keep only countries in selection
development_motion <- subset(development_complete, Country %in% selection)

#
# Lesson 4 : first googleVis plot
#
library(googleVis)


