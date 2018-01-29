################################################################################
#
#' infohub
#'
#' Interactive information hub for the Oxford University International Health
#' and Tropical Medicine (IHTM) implemented in R.
#'
#' The MSc in International Health and Tropical Medicine is a full-time one-year
#' multidisciplinary and interdisciplinary programme examining major challenges
#' to the health of populations in resource-limited contexts. The course is
#' embedded within the Oxford Centre for Tropical Medicine and Global Health,
#' Nuffield Department of Medicine.
#'
#' @docType package
#' @name infohub
#' @importFrom leaflet leaflet %>% leafletOutput addTiles setView renderLeaflet
#'     leafletProxy addCircles clearShapes addCircleMarkers addMarkers
#'     markerClusterOptions addLayersControl layersControlOptions addMiniMap
#' @importFrom shiny navbarPage tabPanel icon div tags includeCSS shinyApp
#'     absolutePanel h4 h6
#'
#'
NULL

# quiets concerns of R CMD check re: the variables that appear
if(getRversion() >= "2.15.1")
  utils::globalVariables(c("studentData", "studentPlacement", "providers", "mapStyle"))

################################################################################
#
#' studentData
#'
#' Data on number of IHTM MSc students per country.
#'
#' @format A data frame with two variables:
#' \describe{
#' \item{\code{country}}{Name of country location}
#' \item{\code{n}}{Number of students}
#' \item{\code{lon}}{Longitude}
#' \item{\code{lat}}{Latitude}
#' }
"studentData"


################################################################################
#
#' studentPlacement
#'
#' Data on various placement options for IHTM MSc students.
#'
#' @format A data frame with 7 variables:
#' \describe{
#' \item{\code{location}}{City/Area location of placement option}
#' \item{\code{country}}{Country location of placement option}
#' \item{\code{org_full}}{Name of organisation providing placement option (full)}
#' \item{\code{org_short}}{Name of organisation providing placement option (short)}
#' \item{\code{subject}}{Subject/topic for placement option}
#' \item{\code{keywords}}{Keywords/tags identifier for placement option}
#' \item{\code{url}}{Website/URL providing further information about placement option}
#' \item{\code{lon}}{Longitude}
#' \item{\code{lat}}{Latitude}
#' }
"studentPlacement"


################################################################################
#
#' mapStyle
#'
#' Data on various Mapbox map styles.
#'
#' @format A data frame with 2 variables
#' \describe{
#' \item{\code{style}}{Map style name}
#' \item{\code{url}}{Map style URL}
#' }
"mapStyle"
