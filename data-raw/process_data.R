################################################################################
#
# Read data
#
################################################################################

studentData <- read.csv("data-raw/studentData.csv")
devtools::use_data(studentData, overwrite = TRUE)

studentPlacement <- read.csv("data-raw/studentPlacements.csv")
devtools::use_data(studentPlacement, overwrite = TRUE)
