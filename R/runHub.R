################################################################################
#
#'
#' Initiate infohub Shiny application
#'
#' @return NULL
#'
#' @examples
#' if(interactive()) runHub()
#'
#' @export
#'
#
################################################################################

runHub <- function() {
  appDir <- system.file("infohub", package = "infohub")

    if (appDir == "") {
    stop("Could not find example directory. Try re-installing `mypackage`.", call. = FALSE)
  }

  shiny::runApp(appDir, display.mode = "normal")
}
