# DATA 607 Week 7 Assignment - Working with XML and JSON in R
# Student: Kalyan (Kalyanaraman Parthasarathy)

# Clear the console
cat("\014")

# Check if the package is installed. If not, install the package
if(!require('XML')) {
  install.packages('XML')
  library(XML)
}

# Check if the package is installed. If not, install the package
if(!require('rjson')) {
  install.packages('rjson')
  library(rjson)
}

# Read the books.html fle
booksHTMLFile <- readLines("https://raw.githubusercontent.com/kalyanparthasarathy/DATA607/master/books.html")

# Find the lines that matches the pattern "<td> .... </td>"
tdPattern = "<td>([0-9A-Za-z\\., \\(\\)-\\']*)</td>"

# Extract the lines that matches the pattern
matchingLines = grep(tdPattern, booksHTMLFile[1:length(booksHTMLFile)], value=TRUE)

# Extract onlt the information that we need from <td> tag
booksInformation <- trimws(unlist(sub("<td>([0-9A-Za-z\\., \\(\\)-\\']*)</td>", "\\1", matchingLines)))

# Books HTML data as it is - Before formatting
booksInformation

# Books information as data frame
booksInformationDF <- cbind.data.frame(split(booksInformation, rep(1:5, times=length(booksInformation)/5)), stringsAsFactors=F)
names(booksInformationDF) <- c("Title", "Author", "Publication_Year", "Publisher", "ISBN")
booksInformationDF = booksInformationDF[-1,]

# HTML Contents as Dataframe
booksInformationDF

# Structure of HTML Books
str(booksInformationDF)


# Reading Books XML File
# First download the file from Github repository and save to local file system
# Then use XML parse 
download.file("https://raw.githubusercontent.com/kalyanparthasarathy/DATA607/master/books.xml", destfile = "Books_XML_File.xml")
booksXMLFile <- xmlParse("Books_XML_File.xml")
booksXMLDF <- xmlToDataFrame(booksXMLFile)

# XML Contents
booksXMLDF

# Structure of XML Books
str(booksXMLDF)



# Reading Books JSON File
jsonData <- rjson::fromJSON(file="https://raw.githubusercontent.com/kalyanparthasarathy/DATA607/master/books.json")

# Structure of JSON data
str(jsonData)

