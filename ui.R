
# This is the user-interface definition of a Shiny web application.
# You can find out more about building applications with Shiny here:
#
# http://shiny.rstudio.com
#

library(shiny)
library(markdown)
library(corrplot)

shinyUI(fluidPage(

  # Application title
  titlePanel(list("Correlation Matrix with", tags$i("corrplot"))),
  
  # Fork me Ribbon
  tags$a(href="https://github.com/saurfang/shinyCorrplot",
         tags$img(style="position: absolute; top: 0; right: 0; border: 0;",
                  src="https://camo.githubusercontent.com/652c5b9acfaddf3a9c326fa6bde407b87f7be0f4/68747470733a2f2f73332e616d617a6f6e6177732e636f6d2f6769746875622f726962626f6e732f666f726b6d655f72696768745f6f72616e67655f6666373630302e706e67",
                  alt="Fork me on GitHub",
                  `data-canonical-src`="https://s3.amazonaws.com/github/ribbons/forkme_right_orange_ff7600.png")),

  # Sidebar with a slider input for number of bins
  sidebarLayout(
    sidebarPanel(
      selectInput("dataset", "Dataset", 
                  c("mtcars", "airquality", "movies", "upload my own")),
      conditionalPanel("input.dataset === 'upload my own'",
                       fileInput("datafile", ""), 
                       textInput("datafile_sep", "Field Seperator", value = ",")),
      tags$hr(),
      
      selectInput("corMethod", "Correlation Method",
                  eval(formals(cor)$method)),
      selectInput("corUse", "NA Action",
                  c("everything", "all.obs", "complete.obs", "na.or.complete", "pairwise.complete.obs")),
      tags$hr(),
      
      #Only works if we are not showing confidence interval
      conditionalPanel("!input.showConf",
                       selectInput("plotMethod", "Plot Method",
                                   list("mixed", all = eval(formals(corrplot)$method)), "circle"),
                       conditionalPanel("input.plotMethod === 'mixed'",
                                        wellPanel(
                                          selectInput("plotLower", "Lower Method", eval(formals(corrplot)$method)),
                                          selectInput("plotUpper", "Upper Method", eval(formals(corrplot)$method)))
                                        )
                       ),
      conditionalPanel("input.showConf || input.plotMethod !== 'mixed'",
                       selectInput("plotType", "Plot Type",
                                   eval(formals(corrplot)$type))),
      
      selectInput("plotOrder", "Reorder Correlation",
                  eval(formals(corrplot)$order)),
      conditionalPanel("input.plotOrder === 'hclust'",
                       wellPanel(
                         selectInput("plotHclustMethod", "Method",
                                     eval(formals(corrplot)$hclust.method)),
                         numericInput("plotHclustAddrect", "Number of Rectangles", 3, 0, NA))),
      
      tags$hr(),
      checkboxInput("sigTest", "Significance Test"),
      conditionalPanel("input.sigTest",
                       numericInput("sigLevel", "Significane Level",
                                    0.05, 0, 1, 0.01),
                       selectInput("sigAction", "Insignificant Action",
                                   eval(formals(corrplot)$insig))),
      checkboxInput("showConf", "Show Confidence Interval"),
      conditionalPanel("input.showConf",
                       selectInput("confPlot", "Ploting Method",
                                   eval(formals(corrplot)$plotCI)[-1]),
                       numericInput("confLevel", "Confidence Level",
                                  0.95, 0, 1, 0.01))
    ),

    # Show a plot of the generated correlation
    mainPanel(
      tabsetPanel(
        tabPanel("Correlation", 
                 column(3, 
                        radioButtons("variablesStyle", "Variable Selection Style", c("Checkbox", "Selectize"), inline = T),
                        helpText("Choose the variables to display. Drag and drop to reorder."), 
                        conditionalPanel("input.variablesStyle === 'Checkbox'",
                                         sortableCheckboxGroupInput("variablesCheckbox", "", c("Loading..."))),
                        conditionalPanel("input.variablesStyle === 'Selectize'",
                                         sortableSelectizeInput("variables", "", c("Loading..."), multiple = T, options = list(plugins = list("remove_button"))))),
                 column(9, 
                        plotOutput("corrPlot", height = 600),
                        uiOutput("warning"))
                 ),
        tabPanel("Data",
                 dataTableOutput("dataTable")),
        tabPanel("About",
                 includeMarkdown("README.md"))
        )
    )
  )
))
