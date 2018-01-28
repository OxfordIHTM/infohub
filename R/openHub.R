################################################################################
#
#' openHub
#'
#' Initiate infohub app.
#' @param data Data for mapping
#' @return NULL
#' @export
#'
openHub <- function(data) {
  #
  # Server
  #
  server <- function(input, output) {
    #
    # Map base layer
    #
    output$map <- renderLeaflet({
      leaflet() %>%
        addTiles(
          urlTemplate = "https://api.mapbox.com/styles/v1/ernestguevarra/cj5di36jn0gxg2rphjn3yetpt/tiles/256/{z}/{x}/{y}?access_token=pk.eyJ1IjoiZXJuZXN0Z3VldmFycmEiLCJhIjoiejRRLXlZdyJ9.sqS1zi0rDH5CIzvcn9SXSg",
          attribution = "Map by <a href = 'http://www.mapbox.com/'>Mapbox</a>"
        ) %>%
        setView(lng = 20, lat = 20, zoom = 3)
    })
    #
    #
    #
    leafletProxy("map", data = data) %>%
      clearShapes() %>%
      addCircleMarkers(~lon, ~lat, radius = data$n * 4,
        stroke = FALSE, fillOpacity = 0.6, fillColor = "#002147")
  }
  #
  # UI
  #
  ui <- navbarPage(title = "Oxford IHTM Infohub", id = "chosenTab",
    tabPanel(title = "", value = 1, icon = icon(name = "home", class = "fa-lg"),
      div(class = "outer", tags$head(includeCSS(system.file("shiny-server", "styles.css", package = "infohub"))),
        leafletOutput("map", width = "100%", height = "100%")
      )
    ),
    #
    #
    #
    tabPanel(title = "Settings", value = 2, icon = icon(name = "cog", class = "fa-lg"))
  )
  #
  #
  #
  shinyApp(ui = ui, server = server)
}
