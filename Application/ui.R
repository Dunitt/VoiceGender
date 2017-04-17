#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#

library(ggvis)
library(shiny)
library(shinythemes)

# Define UI for application that draws a histogram
shinyUI(fluidPage(
  titlePanel("RECONOCIMIENTO DE GÉNERO POR VOZ"), theme = shinytheme("flatly"),
  
  
  # # Some custom CSS
  # tags$head(
  #   tags$style(HTML("
  #       /* Smaller font for preformatted text */
  #       pre, table.table {
  #         font-size: smaller;
  #       }
  # 
  #       body {
  #         min-height: 2000px;
  #       }
  # 
  #       .option-group {
  #         border: 1px solid #ccc;
  #         border-radius: 6px;
  #         padding: 0px 5px;
  #         margin: 5px -10px;
  #         background-color: #f5f5f5;
  #       }
  # 
  #       .option-header {
  #         color: #79d;
  #         text-transform: uppercase;
  #         margin-bottom: 5px;
  #       }
  #     "))
  # ),
  # shinythemes::shinytheme("flatly"),
  
  # Application title
  # titlePanel("Reconocimiento de género por voz"),
  h3("Análisis exploratorio"),
  fluidRow(
    column(width = 5,
          div(class = "well",
               selectInput("xvar", "X-axis variable", axis_vars, selected = "meanfreq"),
               selectInput("yvar", "Y-axis variable", axis_vars, selected = "median")
          )
    ),
    column(width = 7,
           ggvisOutput("analysis")
    )
  ),
  
  h3("Configuración"),
  fluidRow(
    column(width = 3,
           div(class = "well", 
               
               
               radioButtons(inputId="type_algorithms", "Seleccione Algoritmo:", algorithms, selected = "enable_J48")
               
               # checkboxInput(inputId = "enable_KNN", label = strong("Use KNN"), value = FALSE),
               # 
               # checkboxInput(inputId = "enable_J48", label = strong("Use J48"), value = TRUE),
               # 
               # checkboxInput(inputId = "enable_RandomForest", label = strong("Use Random Forest"), value = FALSE),
               # 
               # checkboxInput(inputId = "enable_SVM", label = strong("Use SVM"), value = FALSE),
               # 
               # checkboxInput(inputId = "enable_NaiveBayes", label = strong("Use NaiveBayes"),  value = FALSE),
               # 
               # checkboxInput(inputId = "enable_SIN_DEFINIR", label = strong("Use SIN_DEFINIR"), value = FALSE)
               
           ),
           
           div(class = "well", strong("Options"),
               
               conditionalPanel(condition = "input.type_algorithms == 'enable_KNN'",
                                
                                sliderInput(inputId = "number_neighbours", label = "Number of neighbours:", min = 0, max = 50, value = 3, step = 1),
                                tags$hr()
                                
                                # Seleccionar mínima cantidad de votos.
                                # sliderInput(inputId = "minimum_vote", label = "Minimum vote:", min = 0, max = 50, value = 0, step = 1)
               ), 
               
               conditionalPanel(condition = "input.type_algorithms == 'enable_J48'",
                                
                                sliderInput(inputId = "threshold_pruning", label = "Confidence threshold for pruning:", min = 0.01, max = 1, value = 0.25, step = 0.01),
                                sliderInput(inputId = "instances_leaf", label = "Number of instances per leaf:", min = 1, max = 1500, value = 2, step = 1),
                                tags$hr()
                                
               ),
               
               conditionalPanel(condition = "input.type_algorithms == 'enable_RandomForest'",
                                
                                sliderInput(inputId = "number_trees", label = "Number of trees grown:", min = 1, max = 100, value = 20, step = 1),
                                tags$hr()
                                
               ),
               
               conditionalPanel(condition = "input.type_algorithms == 'enable_SVM'",
                                
                                selectInput("kernel", "Kernel type",
                                            c("Linear" = "linear", 
                                              "Polynomial" = "polynomial",
                                              "Radial basis" = "radial",
                                              "Sigmoid" = "sigmoid")
                                ),
                                tags$hr()
                                
               ),
               
               conditionalPanel(condition = "input.type_algorithms == 'enable_NaiveBayes'",
                                
                                sliderInput(inputId = "laplace", label = "Laplace:", min = 1, max = 100, value = 0, step = 1)
                                
               )
               
           )
    ),
    
    column(width = 9,
          div(class = "well", strong("Graphic"),
              
              # conditionalPanel(condition = "input.type_algorithms == 'enable_KNN'",
                               plotOutput("distPlot")
              # )
              
          )
           
    )
  ),
  h3("Clasificador"),
  fluidRow(
    column(width = 3,
           div(class = "well",

               numericInput("instance", label = h4("Introduce una instancia:"), value = 1, min = 1, max = 950)
               # submitButton("Submit")

           )
    ),
    column(width = 9,
           div(class = "well",

               h2(textOutput("text3")),
               tableOutput("table1"),
               h4(textOutput("text1")),
               h4(textOutput("text2"))
           )
    )
           
  )
  
))
