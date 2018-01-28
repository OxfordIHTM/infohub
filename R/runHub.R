################################################################################
#
#' runHUb
#'
#' @return NULL
#' @examples
#' #
#'
#' @export
#
runHub <- function() {
  appDir <- system.file("shiny-server", package = "infohub")

    if (appDir == "") {
    stop("Could not find example directory. Try re-installing `mypackage`.", call. = FALSE)
  }

  shiny::runApp(appDir, display.mode = "normal")
}
