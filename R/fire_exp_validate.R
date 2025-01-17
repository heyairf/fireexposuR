#' Validate exposure with observed fires
#'
#' @description For advanced users. `fire_exp_validate()` compares the
#'   proportion of exposure classes in a the study area to the proportion of
#'   exposure classes within burned areas. A random sample is taken to account
#'   for spatial autocorrelation.
#'
#' @details
#' **DOCUMENTATION IN DEVELOPMENT**
#'
#'
#' @param burnableexposure A SpatRaster of exposure, non-burnable cells should
#'    be removed using optional parameter in [fire_exp()].
#' @param fires A SpatVector of observed fire perimeters
#' @param aoi (Optional) A SpatVector that delineates an area of interest
#' @param samplesize Proportion of area to sample. The default is `0.005` (0.5%)
#' @param plot Boolean, when `TRUE`: returns a plot of expected and observed
#'   exposure class proportions within entire extent and sampled areas. The
#'   default is `FALSE`.
#'
#' @return table or plot
#'
#' @export
#'
#' @examples
#' # read example hazard data
#' hazard_file_path <- "extdata/hazard.tif"
#' hazard <- terra::rast(system.file(hazard_file_path, package = "fireexposuR"))
#'
#' # generate example non-burnable cells data
#' geom_file_path <- "extdata/polygon_geometry.csv"
#' geom <- read.csv(system.file(geom_file_path, package = "fireexposuR"))
#' polygon <- terra::vect(as.matrix(geom), "polygons", crs = hazard)
#' no_burn <- terra::rasterize(polygon, hazard)
#'
#' # generate example fire polygons by buffering random points
#' points <- terra::spatSample(terra::rescale(hazard, 0.8),
#'                             30, as.points = TRUE)
#' fires <- terra::buffer(points, 800)

#' # PLEASE NOTE THIS RANDOMLY GENERATED DATA DOES NOT GIVE MEANINGFUL RESULTS
#'
#' # compute exposure and remove non-burnable cells
#' exposure <- fire_exp(hazard, nonburnable = no_burn)
#'
#' # results as table
#' fire_exp_validate(exposure, fires)
#'
#' # results as bar chart
#' fire_exp_validate(exposure, fires, plot = TRUE)
#'

fire_exp_validate <- function(burnableexposure, fires, aoi, samplesize = 0.005,
                        plot = FALSE) {
  names(burnableexposure) <- "exposure"
  expb <- burnableexposure
  stopifnot("`burnableexposure` must be a SpatRaster object"
            = class(expb) == "SpatRaster")
  stopifnot("`fires` must be a SpatVector object"
            = class(fires) == "SpatVector")
  if (!missing(aoi)) {
    stopifnot("`aoi` must be a SpatVector object"
              = class(aoi) == "SpatVector")
  }

  rcmat <- matrix(c(0, 0.2, 1,
                    0.2, 0.4, 2,
                    0.4, 0.6, 3,
                    0.6, 0.8, 4,
                    0.8, 1, 5), ncol = 3, byrow = TRUE)

  classexp <- terra::classify(expb, rcmat, include.lowest = TRUE)

  if (missing(aoi)) {
    studyarea <- classexp
    studyareafires <- fires
  } else {
    studyarea <- terra::crop(classexp, aoi, overwrite = TRUE) %>%
      terra::mask(aoi)
    studyareafires <- terra::crop(fires, aoi)
  }

  firesarea <- terra::crop(studyarea, studyareafires, overwrite = TRUE) %>%
    terra::mask(studyareafires)

  df1 <- dplyr::count(as.data.frame(studyarea), .data$exposure) %>%
    dplyr::mutate(of = "Total") %>%
    dplyr::mutate(group = "Expected") %>%
    dplyr::mutate(prop = .data$n / sum(.data$n))


  df2 <- dplyr::count(as.data.frame(firesarea), .data$exposure) %>%
    dplyr::mutate(of = "Total") %>%
    dplyr::mutate(group = "Observed") %>%
    dplyr::mutate(prop = .data$n / sum(.data$n))

  samplestudyareasize <- round(sum(df1$n) * samplesize)
  samplefiresareasize <- round(sum(df2$n) * samplesize)

  props <- rbind(df1, df2)

  df3 <- dplyr::count(terra::spatSample(studyarea,
                                        samplestudyareasize,
                                        na.rm = TRUE,
                                        as.df = TRUE,
                                        method = "random"),
                      .data$exposure) %>%
    dplyr::mutate(of = "Sample") %>%
    dplyr::mutate(group = "Expected") %>%
    dplyr::mutate(prop = .data$n / sum(.data$n))

  props <- rbind(props, df3)

  df4 <- dplyr::count(terra::spatSample(firesarea,
                                        samplefiresareasize,
                                        na.rm = TRUE,
                                        as.df = TRUE,
                                        method = "random"),
                      .data$exposure) %>%
    dplyr::mutate(of = "Sample") %>%
    dplyr::mutate(group = "Observed") %>%
    dplyr::mutate(prop = .data$n / sum(.data$n))

  lut <- 1:5
  names(lut) <- c("Low", "Moderate", "High", "Very High", "Extreme")

  props <- rbind(props, df4) %>%
    dplyr::mutate(classexp = names(lut)[match(.data$exposure, lut)]) %>%
    dplyr::select("exposure", "classexp",
                  "of", "group", "n", "prop")


  if (plot == TRUE) {
    props <- dplyr::arrange(props, dplyr::desc(.data$group))

    props$exposure <- as.factor(props$exposure)

    labs <- unique(props$classexp)
    brks <- unique(props$exposure)


    plt <- ggplot2::ggplot(props, ggplot2::aes(x = .data$exposure,
                                               y = .data$prop,
                                               fill = .data$group,
                                               color = .data$group)) +
      ggplot2::geom_col(position = "identity", linetype = 2, linewidth = 0.8) +
      ggplot2::facet_grid(~.data$of) +
      ggplot2::scale_fill_manual(values = c("transparent", "gray")) +
      ggplot2::scale_color_manual(values = c("black", "transparent")) +
      ggplot2::scale_y_continuous(expand =
                                    ggplot2::expansion(mult = c(0, 0.1))) +
      ggplot2::scale_x_discrete(name = "Exposure Class",
                                breaks = brks,
                                labels = labs) +
      ggplot2::labs(y = "Proportion") +
      ggplot2::theme_classic() +
      ggplot2::theme(legend.title = ggplot2::element_blank())
    return(plt)
  } else {
    return(props)
  }
}

