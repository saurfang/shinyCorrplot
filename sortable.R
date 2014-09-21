#My custom checkboxGroupInput such that I don't need to temper with Shiny namespace
sortableCheckboxGroupInput <- function(inputId, ...) {
  # build jquery-ui dependency for sortable
  jqueryUIDep <- htmlDependency("jqueryui", "1.10.4", c(href="shared/jqueryui/1.10.4"),
                 script = "jquery-ui.min.js",
                 stylesheet = "jquery-ui.min.css")
  
  # return label and select tag
  attachDependencies(
    tagList(
      singleton(tags$head(tags$script(src="js/sortable.js"))),
      checkboxGroupInput(inputId, ...),
      tags$script(paste0("makeSortable($('#", inputId, "'));"))),
    jqueryUIDep)
}

sortableSelectizeInput <- function (..., options = NULL) 
{
  # build jquery-ui dependency for sortable
  jqueryUIDep <- htmlDependency("jqueryui", "1.10.4", c(href="shared/jqueryui/1.10.4"),
                                script = "jquery-ui.min.js",
                                stylesheet = "jquery-ui.min.css")
  
  # add drag_drop to plugin list
  options <- if (is.null(options)) list() else options
  options$plugins <- c(list("drag_drop"), options$plugins)
  
  # return label and select tag
  input <- selectizeInput(..., options = options)
  attachDependencies(input, c(htmlDependencies(input), list(jqueryUIDep)))
}