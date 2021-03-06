##' These functions allow one to explore spatial proteomics data
##' interactively.
##'
##' The function \code{pRolocVis} is a wrapper for
##' \code{pRolocVis_pca}, \code{pRolocVis_compare}.
##' and \code{pRolocVis_aggregate}. These Shiny apps allow to explore and
##' analyse interactively spatial proteomics data.
##'
##' The \code{explore} Shiny app allows exploration of quantitative data
##' (1) visually through a projection of the dataset, (2)
##' protein profiles, and (3) a searchable feature data table,
##' allowing visualisation of sets of proteins of interest. 
##'
##' The \code{compare} Shiny app is meant for comparing protein
##' localisation between two conditions, or two different experiments,
##' replicates etc.
##'
##' The \code{aggregation} Shiny app displays a scatter plot of the
##' maximum or mean distances within each feature (e.g. protein group)
##' according to its components (e.g. peptides) defined by the
##' \code{groupBy} argument. A PCA plot of the components is also
##' displayed. It can be used for visualising peptides, PSMs or any
##' other features defined in the feature data of the \code{MSnSet}
##' and their distributions.
##'
##' @title Interactive visualisation of spatial proteomics data
##' @rdname pRolocVis-apps
##' @param object An instance of class \code{MSnSet}, or an
##'     \code{MSnSetList} of length 2 if using \code{"compare"}
##'     application.
##' @param app The type of application requested: \code{"explore"}
##'     (default), \code{"compare"} or
##'     \code{"aggregate"}. See description below.
##' @param fcol The feature meta-data label (\code{fData} column name)
##'     to be used for colouring. Default is \code{"markers"}. If set
##'     to \code{NULL}, no annotation is expected. For the
##'     \code{"compare"} app, a character vector of length 2 is
##'     allowed to set different labels for each dataset. If
##'     only one label is specified, then this single label 
##'     will be used to identify the annotation column in both datasets. 
##'     Please see example herein.
##' @param fig.height Height of the figure. Default is \code{"700px"}.
##' @param nchar Maximum number of characters of the subcellular class
##'     names, before their names are truncated. Default is 25.
##' @param ... Additional parameters passed to \code{plot2D} for the
##'     \code{"explore"} (such as the dimensionality reduction
##'     technique, and methods), \code{"compare"} apps. For 
##'     the \code{"aggregate"} app this is for additional parameters 
##'     to be passed to \code{combineFeatures}.
##' @author Lisa Breckels, Thomas Naake and Laurent Gatto
##' @seealso The package vignette: \code{vignette("pRolocGUI")}.
##' @examples
##' library("pRoloc")
##' library("pRolocdata")
##' 
##' ## Load the Explore app
##' data(hyperLOPIT2015)
##' if (interactive()) {
##'   pRolocVis(hyperLOPIT2015)
##'   pRolocVis(hyperLOPIT2015, method = "t-SNE")
##'   ## store the t-SNE coords and pass a matrix to pRolocVis
##'   xx <- plot2D(hyperLOPIT2015, method = "t-SNE")
##'   pRolocVis(xx, method = "none", methargs = list(hyperLOPIT2015))
##' }
##'
##' ## Load the Compare app
##' data("hyperLOPITU2OS2018")
##' data("lopitdcU2OS2018")
##' xx <- MSnSetList(list(hyperLOPITU2OS2018, lopitdcU2OS2018))
##' if (interactive()) {
##'   pRolocVis(xx, app = "compare", fcol = c("markers", "final.assignment"))
##' }
##' 
##' ## Visualise the location and distribution of peptides per protein group
##' data("hyperLOPIT2015ms2psm")
##' if (interactive()) {
##'   ## Combine PSM data to peptides
##'   hl <- combineFeatures(hyperLOPIT2015ms2psm,
##'                         groupBy = fData(hyperLOPIT2015ms2psm)$Sequence,
##'                         method = median)
##'   ## Visualise peptides according to protein group
##'   pRolocVis(hl, app = "aggregate", fcol = "markers",
##'             groupBy = "Protein.Group.Accessions")
##' }
pRolocVis <- function(object, app = "explore", fcol = "markers", ...) {
  res <- NULL
  app <- match.arg(app, c("explore", "compare", "aggregate"))
  if (inherits(object, "MSnSetList"))
    app <- "compare"
  if (missing(app))
    app <- "explore"
  if (app == "explore")
    res <- pRolocVis_explore(object, fcol, ...)
  if (app == "compare")
    res <- pRolocVis_compare(object, fcol, ...)
  if (app == "aggregate")
    res <- pRolocVis_aggregate(object, fcol, ...)
  invisible(res)
}
