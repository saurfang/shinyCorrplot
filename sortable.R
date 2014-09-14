#My custom checkboxGroupInput such that I don't need to temper with Shiny namespace
sortableCheckboxGroupInput <- function(inputId, label, choices, selected = NULL, inline = FALSE) {
  # resolve names
  choices <- shiny:::choicesWithNames(choices)
  if (!is.null(selected))
    selected <- shiny:::validateSelected(selected, choices, inputId)
  
  options <- shiny:::generateOptions(inputId, choices, selected, inline)
  
  # build jquery-ui dependency for sortable
  jqueryUIDep <- htmlDependency("jqueryui", "1.10.4", c(href="shared/jqueryui/1.10.4"),
                 script = "jquery-ui.min.js",
                 stylesheet = "jquery-ui.min.css")
  
  # return label and select tag
  attachDependencies(
    tagList(
      singleton(tags$head(tags$script(src="sortable.js"))),
      tags$div(id = inputId,
               class = "control-group shiny-input-sortablecheckboxgroup",
               shiny:::controlLabel(inputId, label),
               options),
      tags$script(paste0("$('#", inputId, "').sortable({
        //propogate changes in position directly to the element being moved
        //TODO: How can we trigger the event correctly while the drag is in progress? (i.e. provide realtime update when desired)
        update: function( event, ui ) {
          $(event.target).trigger('change');
        }
      });"))),
    jqueryUIDep)
}