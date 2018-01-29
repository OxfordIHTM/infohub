################################################################################
#
#' openHub
#'
#' Initiate infohub app.
#'
#' @return NULL
#' @export
#'
openHub <- function() {
  #
  # Server
  #
  server <- function(input, output) {
    #
    # Map base layer
    #
    output$map <- renderLeaflet({
      leaflet() %>%
        #
        # Add base map tiles - Mapbox Standard
        #
        addTiles(
          urlTemplate = mapStyle$url[mapStyle$style == "mapbox.standard"],
          attribution = "Map by <a href = 'http://www.mapbox.com/'>Mapbox</a>",
          group = "Mapbox Standard"
        ) %>%
        #
        # Add base map tiles - Mapbox Satellite
        #
        addTiles(
          urlTemplate = mapStyle$url[mapStyle$style == "mapbox.satellite"],
          attribution = "Map by <a href = 'http://www.mapbox.com/'>Mapbox</a>",
          group = "Mapbox Satellite"
        ) %>%
        #
        # Add base map tiles - Mapbox Street
        #
        addTiles(
          urlTemplate = mapStyle$url[mapStyle$style == "mapbox.street"],
          attribution = "Map by <a href = 'http://www.mapbox.com/'>Mapbox</a>",
          group = "Mapbox Street"
        ) %>%
        #
        # Add markers for student origin location
        #
        addCircleMarkers(data = studentData,
                         ~lon, ~lat,
                         radius = 4 * studentData$n,
                         stroke = FALSE,
                         fillOpacity = 0.8,
                         fillColor = "#002147",
                         popup = paste("<b>Country:</b> ", studentData$country, "<br/>",
                                       "<b>No. of students from country:</b> ", studentData$n, " student/s", sep = ""),
                         group = "Student Origin Location") %>%
        #
        # Add markers for student placements
        #
        addMarkers(data = studentPlacement,
                   ~lon, ~lat,
                   popup = paste("<b>Location:</b> ", studentPlacement$location, ", ", studentPlacement$country, "<br/>",
                                 "<b>Organisation:</b> ", studentPlacement$org_full, " - ", studentPlacement$org_short, "<br/>",
                                 "<b>Subject:</b> ", studentPlacement$subject, "<br/>",
                                 "<a href='", studentPlacement$url, "'>More Info</a>", sep = ""),
                   clusterOptions = markerClusterOptions(),
                   group = "Student Placement") %>%
        #
        # Add layers control
        #
        addLayersControl(
          baseGroups = c("Mapbox Standard", "Mapbox Satelllite", "Mapbox Street"),
          overlayGroups = c("Student Origin Location", "Student Placement"),
          options = layersControlOptions(collapsed = FALSE)
        ) %>%
        #
        # Add mini-map
        #
        addMiniMap(
          tiles = providers$Esri.NatGeoWorldMap,
          toggleDisplay = TRUE) %>%
        #
        # Set view
        #
        setView(lng = 20, lat = 20, zoom = 3)
    })
  }
  #
  # UI
  #
  ui <- navbarPage(title = "Oxford University MSc in International Health and Tropical Medicine", id = "chosenTab",
    tabPanel(title = "", value = 1, icon = icon(name = "home", class = "fa-lg"),
      div(class = "outer",
        tags$head(
          includeCSS(system.file("shiny-server", "styles.css", package = "infohub")),
          tags$link(rel = "icon", href = "ox-square-border.gif")
        ),
        leafletOutput("map", width = "100%", height = "100%"),
        #
        # Create absolute panel - INPUT
        #
        absolutePanel(id = "controls", class = "panel panel-default", fixed = TRUE,
                      draggable = FALSE, top = "auto", left = 10, right = "auto", bottom = 10,
                      width = 330, height = "auto",
          #
          # Panel section header
          #
          div(style="display: inline-block;vertical-align:middle;",
            h4("MSc in International Health and Tropical Medicine"),
            h6("The MSc in International Health and Tropical Medicine is a full-time
            one-year multidisciplinary and interdisciplinary programme examining
            major challenges to the health of populations in resource-limited
            contexts. The course is embedded within the Oxford Centre for Tropical
            Medicine and Global Health, Nuffield Department of Medicine.")
          )
        )
      )
    )
  )
  #
  #
  #
  shinyApp(ui = ui, server = server)
}
