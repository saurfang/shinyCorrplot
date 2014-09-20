#My custom checkboxGroupInput such that I don't need to temper with Shiny namespace
sortableCheckboxGroupInput <- function(inputId, ...) {
  # build jquery-ui dependency for sortable
  jqueryUIDep <- htmlDependency("jqueryui", "1.10.4", c(href="shared/jqueryui/1.10.4"),
                 script = "jquery-ui.min.js",
                 stylesheet = "jquery-ui.min.css")
  
  # return label and select tag
  attachDependencies(
    tagList(
      checkboxGroupInput(inputId, ...),
      tags$script(paste0("$('#", inputId, "').sortable({
        //propogate changes in position directly to the element being moved
        //TODO: How can we trigger the event correctly while the drag is in progress? (i.e. provide realtime update when desired)
        update: function( event, ui ) {
          $(event.target).trigger('change');
        }
      });"))),
    jqueryUIDep)
}

sortableSelectizeInput <- function (inputId, ..., options = NULL, width = NULL) 
{
  # build jquery-ui dependency for sortable
  jqueryUIDep <- htmlDependency("jqueryui", "1.10.4", c(href="shared/jqueryui/1.10.4"),
                                script = "jquery-ui.min.js",
                                stylesheet = "jquery-ui.min.css")
  
  # add drag_drop to plugin list
  options <- if (is.null(options)) list() else options
  options$plugins <- c(list("drag_drop"), options$plugins)
  
  # return label and select tag
  attachDependencies(
    tagList(
      shiny:::selectizeIt(inputId, selectInput(inputId, ..., selectize = FALSE), options, width),
      tags$script(paste0("$('#", inputId, "').on(
        //propogate changes in position directly to the element being moved
        //TODO: How can we trigger the event correctly while the drag is in progress? (i.e. provide realtime update when desired)
        'sortupdate', function( event, ui ) {
          $(event.target).trigger('change');
        });"))),
    jqueryUIDep)
}