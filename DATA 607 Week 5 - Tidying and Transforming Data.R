# Week 5 Assignment - Tidying and Transforming Data
# Student: Kalyan (Kalyanaraman Parthasarathy)

# Clear the console
cat("\014")

# Check if the package is installed. If not, install the package
if(!require('tidyr')) {
  install.packages('tidyr')
  library(tidyr)
}

# Check if the package is installed. If not, install the package
if(!require('dplyr')) {
  install.packages('dplyr')
  library(tidyr)
}

flightDataCSV <- read.csv("")
