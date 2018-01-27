################################################################################
#
# Read data
#
################################################################################

studentData <- read.csv("data-raw/studentData.csv")
devtools::use_data(studentData, overwrite = TRUE)

studentPlacements <- read.csv("data-raw/studentPlacements.csv")
devtools::use_data(studentPlacements, overwrite = TRUE)
