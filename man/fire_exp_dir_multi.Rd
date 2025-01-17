% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/fire_exp_dir_multi.R
\name{fire_exp_dir_multi}
\alias{fire_exp_dir_multi}
\title{Summarize or plot directional load for multiple values}
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
\code{fire_exp_dir_multi()} summarizes the directional vulnerability
load for multiple points in a study area in a table or a plot.
}
\details{
\strong{DOCUMENTATION IN DEVELOPMENT}
}
\examples{
# read example hazard data
hazard_file_path <- "extdata/hazard.tif"
hazard <- terra::rast(system.file(hazard_file_path, package = "fireexposuR"))

# generate 10 random example points within the hazard extent
e <- terra::buffer(terra::vect(terra::ext(hazard), crs = hazard), -15500)
points <- terra::spatSample(e, 10)

# compute exposure metric
exposure <- fire_exp(hazard)

# plot directional load for multiple points
fire_exp_dir_multi(exposure, points, plot = TRUE)
}
