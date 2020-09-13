################################################################################
#
#'
#' Initiate infohub Shiny application
#'
#' @return NULL
#'
#' @examples
#' if(interactive()) openHub()
#'
#' @export
#'
#
################################################################################

openHub <- function() {
  ## Server
  server <- function(input, output) {
    ## Map base layer
    output$map <- leaflet::renderLeaflet({
      leaflet::leaflet() %>%
        ## Add base map tiles - Mapbox Standard
        leaflet::addTiles(
          urlTemplate = mapStyle$url[mapStyle$style == "mapbox.standard"],
          attribution = "Map by <a href = 'http://www.mapbox.com/'>Mapbox</a>",
          group = "Mapbox Standard"
        ) %>%
        ## Add base map tiles - Mapbox Satellite
        leaflet::addTiles(
          urlTemplate = mapStyle$url[mapStyle$style == "mapbox.satellite"],
          attribution = "Map by <a href = 'http://www.mapbox.com/'>Mapbox</a>",
          group = "Mapbox Satellite"
        ) %>%
        ## Add base map tiles - Mapbox Street
        leaflet::addTiles(
          urlTemplate = mapStyle$url[mapStyle$style == "mapbox.street"],
          attribution = "Map by <a href = 'http://www.mapbox.com/'>Mapbox</a>",
          group = "Mapbox Street"
        ) %>%
        ## Add markers for student origin location
        leaflet::addCircleMarkers(
          data = studentData,
          ~lon, ~lat,
          radius = 4 * studentData$n,
          stroke = TRUE,
          color = "#002147",
          weight = 3,
          fillOpacity = 0.8,
          fillColor = "#002147",
          popup = paste("<b>Country:</b> ", studentData$country, "<br/>",
                        "<b>No. of students from country:</b> ",
                        studentData$n, " student/s", sep = ""),
                        group = "Student Origin Location") %>%
        ## Add markers for student placements
        leaflet::addMarkers(
          data = studentPlacement,
          ~lon, ~lat,
          popup = paste("<b>Location:</b> ",
                        studentPlacement$location, ", ",
                        studentPlacement$country, "<br/>",
                        "<b>Organisation:</b> ",
                        studentPlacement$org_full, " - ",
                        studentPlacement$org_short, "<br/>",
                        "<b>Subject:</b> ",
                        studentPlacement$subject, "<br/>",
                        "<a href='", studentPlacement$url,
                        "'>More Info</a>", sep = ""),
          clusterOptions = leaflet::markerClusterOptions(),
          group = "Student Placement") %>%
        ## Add layers control
        leaflet::addLayersControl(
          baseGroups = c("Mapbox Standard", "Mapbox Satelllite", "Mapbox Street"),
          overlayGroups = c("Student Origin Location", "Student Placement"),
          options = layersControlOptions(collapsed = FALSE)
        ) %>%
        ## Add mini-map
        leaflet::addMiniMap(
          tiles = leaflet::providers$Esri.NatGeoWorldMap,
          toggleDisplay = TRUE) %>%
        ## Set view
        leaflet::setView(lng = 20, lat = 20, zoom = 3)
    })
  }

  ## UI
  ui <- shiny::navbarPage(
    title = "Oxford University MSc in International Health and Tropical Medicine",
    id = "chosenTab",
    shiny::tabPanel(title = "", value = 1, icon = icon(name = "home", class = "fa-lg"),
      shiny::div(class = "outer",
        shiny::tags$head(
          shiny::includeCSS(system.file("infohub", "styles.css",
                                        package = "infohub")),
          shiny::tags$link(rel = "icon",
                           href = system.file("infohub", "ox-square-border.gif",
                                              package = "infohub"))
        ),
        leaflet::leafletOutput("map", width = "100%", height = "100%"),
        ## Create absolute panel - INPUT
        shiny::absolutePanel(
          id = "controls", class = "panel panel-default", fixed = TRUE,
          draggable = FALSE, top = "auto", left = 10, right = "auto",
          bottom = 10, width = 330, height = "auto",
          ## Panel section header
          shiny::div(style="display: inline-block;vertical-align:middle;",
            shiny::h4("MSc in International Health and Tropical Medicine"),
            shiny::h6(
              "The MSc in International Health and Tropical Medicine is a full-time
              one-year multidisciplinary and interdisciplinary programme examining
              major challenges to the health of populations in resource-limited
              contexts. The course is embedded within the Oxford Centre for Tropical
              Medicine and Global Health, Nuffield Department of Medicine."
            )
          )
        )
      )
    )
  )
  ##
  shiny::shinyApp(ui = ui, server = server)
}
