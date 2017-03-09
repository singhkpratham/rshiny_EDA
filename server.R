library(shiny)
library(plotly)
library(ggplot2)
library(broom)
library(stringr)
# Define server logic required to draw a histogram
function(input, output, session) {
   
   file = reactive({
     file1 = input$file
     if (is.null(file1)) return( read.csv("C:\\Users\\kumar.singh\\Desktop\\New folder\\Git\\R-Shiny\\iris.csv"))
      read.csv(file1$datapath )
     
     }
   )
   output$title = renderText(input$file$name)
   num = reactive({
     a = file()
     colnames(a)[sapply(a, function(x) length(unique(x))>20 & is.numeric(x))]
   })
   
   fac = reactive({
     a = file()
     colnames(a)[sapply(a, function(x) length(unique(x))<20 )]
   })
   
   output$str = renderPrint(str(file()))
   output$summary = renderTable({
     a = tidy(summary(file()[num()]))
     a$a = stringr::str_split(as.character(a$Freq), ":", simplify = T)[,1]
     a$b = stringr::str_split(as.character(a$Freq), ":", simplify = T)[,2]
     spread(a[,c(2,4,5)], a,b)
     })
   
   
   output$cat = renderUI({
     selectInput('q', "Selecte VArs", fac())


   })
   output$cattbl = renderTable(
     tidy(summary(file()[input$q]))[-1]
   )

   output$head = renderDataTable(file(),
                                 options = 
                                   list(lengthMenu = c(5, 30, 50), pageLength = 5))
   
########################################################
   #UNIVARIATE
   
   output$uniSlide = renderUI({
     selectInput('uniSld', 'select variables', choices = num())#choices = (colnames(file())) )
   })
   
   output$uniColor = renderUI({
     a = file()
     tagList(
       checkboxInput('uni','wanna color by some variable?'),
       conditionalPanel( 'input.uni == true', 
                         selectizeInput('c', 'Color by',c("None", fac()) , selected = NULL))
     )
   })
   
   output$uniplt = renderPlotly({
     a = file()
     if (input$c == "None"){ ggplotly(
       ggplot() + geom_histogram(aes(a[[input$uniSld]]))
       )
     }else{
       ggplotly(ggplot()+geom_histogram(aes(a[[input$uniSld]], fill = a[[input$c]])))
     }
     
   })
   
   output$unibox = renderPlotly({
     a = file()
     if(input$c == "None"){
       plot_ly(x = a[[input$uniSld]],type = 'box')
     }else{
       plot_ly(x = a[[input$uniSld]], color = a[[input$c]] , type = 'box')
       }
   })
   
   
   output$uniquant = renderPrint({
     a = file()
     quantile(a[[input$uniSld]], seq(0,1,.1), na.rm = T)
     })
   
 ######################################################
   #BIVAR##############
   output$biSelect = renderUI({
     a = file()
     tagList(
       selectInput('x', "X Axis", num()) ,
       selectInput('y', 'Y axis', num()[sample(length(num()))])
     )
   })
   
   output$biColor = renderUI({
     a = file()
     tagList(
       checkboxInput('b','wanna color by some variable?'),
       conditionalPanel( 'input.b == true', 
                         selectizeInput('a', 'Color by',c("None", fac()) , selected = NULL))
     )
   })
   
   output$biPlt = renderPlotly({
     a = file()
     if (input$a == "None") {ggplotly(
       ggplot() + geom_point(aes(x =a[[input$x]] , y = a[[input$y]]) ) 
       )
     }else{plot_ly(x =a[[input$x]] , y = a[[input$y]], color = a[[input$a]] )}
     
     })
   ##############################################3
   ##Statistical Tests
   output$statFac = renderUI({
     a = file()
     tagList(
       selectInput('xF', "X Axis", fac()) ,
       selectInput('yF', 'Y axis', fac())
     )
   })
   output$statFacR = renderPrint(chisq.test(file()[[input$xF]], file()[[input$yF]]))
   
   output$statCont = renderUI({
     a = file()
     tagList(
       selectInput('xC', "X Axis", num()) ,
       selectInput('yC', 'Y axis', num()[sample(length(num()))])
     )
   })
   output$statContR = renderPrint(cor.test(file()[[input$xC]], file()[[input$yC]]))
   
   output$statMix = renderUI({
     a = file()
     tagList(
       selectInput('xM', "X Axis", fac()) ,
       selectInput('yM', 'Y axis', num()[sample(length(num()))])
     )
   })
   output$statMixR = renderPrint(t.test(table(file()[[input$xM]], file()[[input$yM]])))
}










