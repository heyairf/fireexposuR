% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/fire_exp_map_cont.R
\name{fire_exp_map_cont}
\alias{fire_exp_map_cont}
\title{Map exposure with a continuous scale}
\usage{
fire_exp_map_cont(exposure, aoi)
}
\arguments{
\item{exposure}{SpatRaster from \code{\link[=fire_exp]{fire_exp()}}}

\item{aoi}{(optional) SpatVector of an area of interest to mask the exposure}
}
\value{
a map is returned as a ggplot object
}
\description{
\code{fire_exp_map_cont()} produces a standardized map of exposure with a
continuous scale. An optional area of interest can be used as a mask. The
ggplot object returned can be further modified with the ggplot library.
}
\examples{

# read example hazard data ----------------------------------
filepath <- "extdata/hazard.tif"
haz <- terra::rast(system.file(filepath, package = "fireexposuR"))
# -------------------------------------------------------------

exp <- fire_exp(haz)

fire_exp_map_cont(exp)

}
