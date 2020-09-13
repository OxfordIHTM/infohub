################################################################################
#
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
#' @keywords internal
#' @importFrom leaflet leaflet %>% leafletOutput addTiles setView renderLeaflet
#'   leafletProxy addCircles clearShapes addCircleMarkers addMarkers
#'   markerClusterOptions addLayersControl layersControlOptions addMiniMap
#'   providers
#' @importFrom shiny navbarPage tabPanel icon div tags includeCSS shinyApp
#'   absolutePanel h4 h6
#' @importFrom magrittr %>%
#'
#'
#
################################################################################
"_PACKAGE"

# quiets concerns of R CMD check re: the variables that appear
if(getRversion() >= "2.15.1") utils::globalVariables(c("studentData",
                                                       "studentPlacement",
                                                       "mapStyle"))

################################################################################
#
#' Data on number of IHTM MSc students per country.
#'
#' @format A data frame with 28 rows and 4 columns:
#'
#' | **Variable** | **Description** |
#' | :--- | :--- |
#' | `country` | Name of country location |
#' | `n` | Number of students |
#' | `lon` | Longitude coordinate |
#' | `lat` | Latitude coordinate |
#'
#' @examples
#' studentData
#'
#
################################################################################
"studentData"


################################################################################
#
#' Data on various placement options for IHTM MSc students.
#'
#' @format A tibble with 38 rows and 9 columns:
#'
#' | **Variable** | **Description** |
#' | :--- | :--- |
#' | `location` | City/Area location of placement option |
#' | `country` | Country location of placement option |
#' | `org_full` | Name of organisation providing placement option (full) |
#' | `org_short` | Name of organisation providing placement option (short) |
#' | `subject` | Subject/topic for placement option |
#' | `keywords` | Keywords/tags identifier for placement option |
#' | `url` | Website/URL providing further information about placement option |
#' | `lon` | Longitude coordinate |
#' | `lat` | Latitude coordinate |
#'
#' @examples
#' studentPlacement
#'
#
################################################################################
"studentPlacement"


################################################################################
#
#' Data on various Mapbox map styles.
#'
#' @format A tibble with 13 rows and 2 columns:
#'
#' | **Variable** | **Description** |
#' | :--- | :--- |
#' | `style` | Map style name |
#' | `url` | Map style URL |
#'
#' @examples
#' mapStyle
#'
#
################################################################################
"mapStyle"
