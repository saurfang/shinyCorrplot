
# This is the user-interface definition of a Shiny web application.
# You can find out more about building applications with Shiny here:
#
# http://shiny.rstudio.com
#

library(shiny)
library(markdown)

shinyUI(fluidPage(

  # Application title
  titlePanel(list("Correlation Matrix with", tags$i("corrplot"))),

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
                  c(eval(formals(corrplot)$order), "manual")),
      conditionalPanel("input.plotOrder === 'hclust'",
                       wellPanel(
                         selectInput("plotHclustMethod", "Method",
                                     eval(formals(corrplot)$hclust.method)),
                         numericInput("plotHclustAddrect", "Number of Rectangles", 3, 0, NA))),
      
      hr(),
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
                 plotOutput("corrPlot"),
                 uiOutput("warning")),
        tabPanel("Data",
                 dataTableOutput("dataTable")),
        tabPanel("About",
                 includeMarkdown("README.md"))
        )
    )
  )
))
