% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/extractexp.R
\name{extractexp}
\alias{extractexp}
\title{Extract exposure values to features}
\usage{
extractexp(
  exposure,
  values,
  method = c("max", "mean"),
  classify = c("local", "landscape"),
  summary = FALSE,
  map = FALSE
)
}
\arguments{
\item{exposure}{SpatRaster (e.g. from \code{\link[=exposure]{exposure()}})}

\item{values}{Spatvector of points or polygons}

\item{method}{character, either \code{"max"} or \code{"mean"}. required when values are
polygons. The default is \code{"max"}.}

\item{classify}{character, either \code{"local"} or \code{"landscape"} to specify
classification scheme to use.}

\item{summary}{boolean, if \code{TRUE}: returns a summary table as a data frame.
Default is \code{FALSE}.}

\item{map}{boolean, if \code{TRUE}: returns a ggplot map of values coloured by
class. Default is \code{FALSE}.}
}
\value{
a SpatVector object with added fields. Unless:
\itemize{
\item \code{summary = TRUE}: a summary table is returned as a data frame object
\item \code{map = TRUE}: a map is returned as a ggplot object
}
}
\description{
\code{extractexp()} extracts the underlying exposure value for each
feature in the values provided. Values can be provided as either points or
polygons, and must be singlepart features (i.e. the attribute table has one
row per value). If the values are polygon features the method parameter must
be set to "max" or "mean", the method parameter is ignored if values are
points. The function retuns a SpatVector with an added exposure field. If the
classify parameter is provided, an additional field "classexp" is added.

Landscape classification breaks are:
\itemize{
\item Low (0-20\%)
\item Moderate (20-40\%)
\item High (40-60\%),
\item Very High (60-80\%)
\item Extreme (80-100\%)
}

Local classification breaks are:
\itemize{
\item Nil (0\%)
\item Low (>0-15\%)
\item Moderate (15-30\%)
\item High (30-45\%)
\item Extreme (45\%+)
}

When either summary or map are set to \code{TRUE}, the classify parameter is
required. Setting \code{summary = TRUE} will return a summary table of exposure by
the user specified classification scheme. The table reports the number of
values and proportions by class. Setting \code{map = TRUE} will return a
standardized map of the values with a neutral base map and values symbolized
by the user specified classification scheme. The ggplot object returned can
be further modified with ggplot functions.
}
\examples{
# generate example hazard data -----------------------------
set.seed(0)
e <- c(45,55,495,505) * 10000
r <- terra::rast(resolution = 100, extent = terra::ext(e))
terra::values(r) <- sample(c(0,1), terra::ncell(r), replace = TRUE)
terra::crs(r) <- "EPSG:32608"
r <- terra::sieve(r, threshold = 50, directions = 4)
haz <- terra::sieve(r, threshold = 500, directions = 4)
# generate example AOI polygon -----------------------------
filepath <- "extdata/builtsimpleexamplegeom.csv"
g <- read.csv(system.file(filepath, package = "fireexposuR"))
m <- as.matrix(g)
v <- terra::vect(m, "polygons", crs = haz)
# generate example point values within polygon -------------
pts <- terra::spatSample(v, 200)
# ----------------------------------------------------------

exp <- exposure(haz)

# summarize values by class in a table ---------------------
extractexp(exp, pts, classify = "local", summary = TRUE)

# map example points with local classification -------------
extractexp(exp, pts, classify = "local", map = TRUE)

}
\seealso{
\code{\link[=exposure]{exposure()}}, \code{\link[=summexp]{summexp()}}, \code{\link[ggplot2:ggplot]{ggplot2::ggplot()}}
}
