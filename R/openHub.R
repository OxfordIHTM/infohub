################################################################################
#
#' openHub
#'
#' Initiate infohub app.
#' @return NULL
#' @export
#'
openHub <- function() {
  appDir <- system.file("shiny-server", package = "infohub")

  if (appDir == "") {
    stop("Could not find example directory. Try re-installing `infohub`.", call. = FALSE)
  }

  shiny::runApp(appDir, display.mode = "normal")
}
