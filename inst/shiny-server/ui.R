################################################################################
#
# UI
#
################################################################################
#
# Set navbar
#
navbarPage(title = "Urban Water and Sanitation Survey", id = "chosenTab",
  #
  # Create tab panel
  #
  tabPanel(title = "",
           value = 1,
           icon = icon(name = "home", class = "fa-lg"),
    #
    # Header HTML
    #
    div(class = "outer",
      #
      # Header HTML
      #
      tags$head(
        includeCSS("styles.css"),
        tags$link(rel = "icon", href = "http://www.validmeasures.org/favicon.ico")
      ),
      #
      # Output map
      #
      leafletOutput("map", width = "100%", height = "100%")
    )
  ),
  #
  #
  #
  tabPanel(title = "Settings",
           value = 3,
           icon = icon(name = "cog", class = "fa-lg")
  )
)

