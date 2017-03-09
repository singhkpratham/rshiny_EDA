library(shiny)

library(shinydashboard)
library(plotly)
library(ggplot2)
# Define UI for application that draws a histogram
dashboardPage(
  dashboardHeader( title =  textOutput(paste('working on ' ,'title')), disable = T),
  dashboardSidebar(disable = T),
  dashboardBody(
    fluidPage(
      
      # Application title
      # Sidebar with a slider input for number of bins 
      sidebarLayout(
        sidebarPanel( width = 0
        ),
        
        # Show a plot of the generated distribution
        mainPanel(
          tabsetPanel(
            tabPanel('File Upload',
                     fileInput('file', 'upload dataset')
            ), 
            tabPanel( "Structure and summary",
                      dataTableOutput('head'),
                      verbatimTextOutput('str'),
                      radioButtons('rad','Choose Categorical or Continuous to see Summary',
                                   c("Continuous" , "Categorical" )),
                      conditionalPanel('input.rad == "Continuous"',tableOutput('summary')),
                      conditionalPanel('input.rad == "Categorical"',
                                       uiOutput('cat'), tableOutput('cattbl')
                                       )
                      
   #                   tableOutput('summary')
                      
            ),
            tabPanel("univariate" , 
                     uiOutput('uniSlide'),
                     uiOutput('uniColor'),
                     verbatimTextOutput("uniquant"),
                     fluidRow(plotlyOutput("uniplt"),
                     plotlyOutput('unibox') )
            ),
            tabPanel('bivariate',
                     uiOutput('biSelect'),
                     uiOutput('biColor'),
                     plotlyOutput('biPlt')
                     ),
            tabPanel('Statistical Tests',
                     fluidRow( "categorical variables",
                       uiOutput('statFac'),
                       verbatimTextOutput('statFacR')
                     ),fluidRow("Continuous Vars",
                       uiOutput('statCont'),
                       verbatimTextOutput('statContR')
                     ),fluidRow("Continuous vs Categorical",
                       uiOutput('statMix'),
                       verbatimTextOutput('statMixR')
                     )
                     
                     )
          )
        )
      )
    )
  )
)

