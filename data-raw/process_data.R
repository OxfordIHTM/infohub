################################################################################
#
# Read data
#
################################################################################

library(ggmap)

studentData <- read.csv("data-raw/studentData.csv")
studentData <- data.frame(studentData, geocode(as.character(studentData$country)))
studentData <- tibble::tibble(studentData)
usethis::use_data(studentData, overwrite = TRUE, compress = "xz")

studentPlacement <- read.csv("data-raw/studentPlacements.csv")
studentPlacement <- data.frame(studentPlacement, geocode(paste(as.character(studentPlacement$location), as.character(studentPlacement$country), sep = ", ")))
studentPlacement <- tibble::tibble(studentPlacement)
usethis::use_data(studentPlacement, overwrite = TRUE, compress = "xz")


################################################################################
#
# Create map style data
#
################################################################################

style <- c("mapbox.satellite", "mapbox.street", "mapbox.dark", "mapbox.light",
           "mapbox.moonlight", "mapbox.northstar", "mapbox.standard", "mapbox.decimal",
           "mapbox.terminal", "mapbox.ukiyo-e", "mapbox.nowicka", "mapbox.scenic",
           "mapbox.metropolis")

url <- c("https://api.mapbox.com/styles/v1/mapbox/satellite-streets-v10/tiles/256/{z}/{x}/{y}?access_token=pk.eyJ1IjoiZXJuZXN0Z3VldmFycmEiLCJhIjoiejRRLXlZdyJ9.sqS1zi0rDH5CIzvcn9SXSg",
         "https://api.mapbox.com/styles/v1/mapbox/streets-v10/tiles/256/{z}/{x}/{y}?access_token=pk.eyJ1IjoiZXJuZXN0Z3VldmFycmEiLCJhIjoiejRRLXlZdyJ9.sqS1zi0rDH5CIzvcn9SXSg",
         "https://api.mapbox.com/styles/v1/mapbox/dark-v9/tiles/256/{z}/{x}/{y}?access_token=pk.eyJ1IjoiZXJuZXN0Z3VldmFycmEiLCJhIjoiejRRLXlZdyJ9.sqS1zi0rDH5CIzvcn9SXSg",
         "https://api.mapbox.com/styles/v1/mapbox/light-v9/tiles/256/{z}/{x}/{y}?access_token=pk.eyJ1IjoiZXJuZXN0Z3VldmFycmEiLCJhIjoiejRRLXlZdyJ9.sqS1zi0rDH5CIzvcn9SXSg",
         "https://api.mapbox.com/styles/v1/ernestguevarra/cj3nban30001z2rpahc10c9ef/tiles/256/{z}/{x}/{y}?access_token=pk.eyJ1IjoiZXJuZXN0Z3VldmFycmEiLCJhIjoiejRRLXlZdyJ9.sqS1zi0rDH5CIzvcn9SXSg",
         "https://api.mapbox.com/styles/v1/ernestguevarra/cj4ke832y4sng2spe2ds4fs55/tiles/256/{z}/{x}/{y}?access_token=pk.eyJ1IjoiZXJuZXN0Z3VldmFycmEiLCJhIjoiejRRLXlZdyJ9.sqS1zi0rDH5CIzvcn9SXSg",
         "https://api.mapbox.com/styles/v1/ernestguevarra/cj5di36jn0gxg2rphjn3yetpt/tiles/256/{z}/{x}/{y}?access_token=pk.eyJ1IjoiZXJuZXN0Z3VldmFycmEiLCJhIjoiejRRLXlZdyJ9.sqS1zi0rDH5CIzvcn9SXSg",
         "https://api.mapbox.com/styles/v1/ernestguevarra/cj5ms1akt3pbi2smtcewsex9m/tiles/256/{z}/{x}/{y}?access_token=pk.eyJ1IjoiZXJuZXN0Z3VldmFycmEiLCJhIjoiejRRLXlZdyJ9.sqS1zi0rDH5CIzvcn9SXSg",
         "https://api.mapbox.com/styles/v1/ernestguevarra/cj6g0tzbd30kc2sph2wyh666m/tiles/256/{z}/{x}/{y}?access_token=pk.eyJ1IjoiZXJuZXN0Z3VldmFycmEiLCJhIjoiejRRLXlZdyJ9.sqS1zi0rDH5CIzvcn9SXSg",
         "https://api.mapbox.com/styles/v1/ernestguevarra/cjb38aptl29ar2spywoh20s69/tiles/256/{z}/{x}/{y}?access_token=pk.eyJ1IjoiZXJuZXN0Z3VldmFycmEiLCJhIjoiejRRLXlZdyJ9.sqS1zi0rDH5CIzvcn9SXSg",
         "https://api.mapbox.com/styles/v1/ernestguevarra/cjb38boti1vsb2slyub73v836/tiles/256/{z}/{x}/{y}?access_token=pk.eyJ1IjoiZXJuZXN0Z3VldmFycmEiLCJhIjoiejRRLXlZdyJ9.sqS1zi0rDH5CIzvcn9SXSg",
         "https://api.mapbox.com/styles/v1/ernestguevarra/cjb38c92p1vsw2slyvdv9t4i7/tiles/256/{z}/{x}/{y}?access_token=pk.eyJ1IjoiZXJuZXN0Z3VldmFycmEiLCJhIjoiejRRLXlZdyJ9.sqS1zi0rDH5CIzvcn9SXSg",
         "https://api.mapbox.com/styles/v1/ernestguevarra/cjc8urdjr6xs82sl6ntpmfx67/tiles/256/{z}/{x}/{y}?access_token=pk.eyJ1IjoiZXJuZXN0Z3VldmFycmEiLCJhIjoiejRRLXlZdyJ9.sqS1zi0rDH5CIzvcn9SXSg")

mapStyle <- data.frame(style, url)
write.csv(mapStyle, "data-raw/mapStyle.csv", row.names = FALSE)

mapStyle <- tibble::tibble(mapStyle)
usethis::use_data(mapStyle, overwrite = TRUE, compress = "xz")
