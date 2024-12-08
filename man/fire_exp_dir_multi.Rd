% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/fire_exp_dir_multi.R
\name{fire_exp_dir_multi}
\alias{fire_exp_dir_multi}
\title{Generate a directional load plot or table for multiple values}
\usage{
fire_exp_dir_multi(exposure, values, plot = FALSE, all = FALSE)
}
\arguments{
\item{exposure}{SpatRaster from \code{\link[=fire_exp]{fire_exp()}}}

\item{values}{Spatvector of value as a point or simplified polygon}

\item{plot}{Boolean, when \code{TRUE}: returns a standardized directional plot.
The default is \code{FALSE}.}

\item{all}{Boolean, when \code{TRUE}: considers all 3 segments (0-15km) of
directional transects. when \code{FALSE}: only the segments from 5-15 km are
included (Default)}
}
\value{
a data.frame of the features with attributes: value featureID,
degree, to5 (binary), to10(binary), t015(binary), full(binary),
outer (binary). Unless:
* \code{plot = TRUE}: a standardized plot as a ggplot object
}
\description{
\code{fire_exp_dir_multi()} automates the directional vulnerability
assessment methods from Beverly and Forbes 2023. This function can return
directional loads as:
\itemize{
\item a standardized radial plot as a ggplot object
\item a table summarizing if each degree is included by feature
}
}
\examples{
#' # read example hazard data ----------------------------------
filepath <- "extdata/hazard.tif"
haz <- terra::rast(system.file(filepath, package = "fireexposuR"))
# example points across the landscape
e <- terra::buffer(terra::vect(terra::ext(haz), crs = haz), -15500)
pts <- terra::spatSample(e, 20)
# ----------------------------------------------------------

exp <- fire_exp(haz, tdist = "l")
# this example will take a while to run
\dontrun{
fire_exp_dir_multi(exp, pts, plot = TRUE)
}
}
