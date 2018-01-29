################################################################################
#
# UI
#
################################################################################
#
# Load dependencies
#
library(shiny)
library(shinythemes)
library(leaflet)
library(devtools)
devtools::install_github("OxfordIHTM/infohub"); library(infohub)
#
#
#
navbarPage(title = "Oxford University MSc in International Health and Tropical Medicine", id = "chosenTab",
  tabPanel(title = "", value = 1, icon = icon(name = "home", class = "fa-lg"),
    div(class = "outer",
        tags$head(
          includeCSS("styles.css"),
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

