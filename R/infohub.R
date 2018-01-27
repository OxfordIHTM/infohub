################################################################################
#
#' infohub
#'
#' Interactive information hub for the Oxford University International Health
#' and Tropical Medicine (IHTM) implemented in R
#'
#' @docType package
#' @name infohub
#'
NULL


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
#' }
"studentPlacement"
