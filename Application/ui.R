#Incluimos las librerias necesarias por el cliente
library(ggvis)
library(shiny)
library(shinythemes)

#Aquí comienza el cliente
shinyUI(fluidPage(

  titlePanel("RECONOCIMIENTO DE GÉNERO POR VOZ"), theme = shinytheme("flatly"),
  
  
  h3("Análisis exploratorio"),
  
  tabsetPanel(type = "tabs", 
        tabPanel("Gráficos", plotOutput("plot")), 
        tabPanel("Resumen", verbatimTextOutput("summary")), 
        tabPanel("Set de Datos", tableOutput("table")),
        tabPanel("Boxplots", plotOutput("boxplot"))
      ),
	  
  fluidRow(
    column(width = 5,
          div(class = "well",
               selectInput("xvar", "Eje X", axis_vars, selected = "meanfreq"),
               selectInput("yvar", "Eje Y", axis_vars, selected = "median")
          )
    )
  ),
  
  h3("Configuración"),
  fluidRow(
    column(width = 3,
           div(class = "well", 
               
               
               radioButtons(inputId="type_algorithms", "Seleccione Algoritmo:", algorithms, selected = "enable_J48")
               
               
           ),
           
           div(class = "well", strong("Opciones"),
               
               
               conditionalPanel(condition = "input.type_algorithms == 'enable_KNN'",
                                
                                sliderInput(inputId = "number_neighbours", label = "Número de Vecinos:", min = 1, max = 50, value = 3, step = 1),
                                tags$hr()
                                
               ), 
               
               conditionalPanel(condition = "input.type_algorithms == 'enable_J48'",
                                
                                sliderInput(inputId = "threshold_pruning", label = "Umbral de confianza:", min = 0.01, max = 1, value = 0.25, step = 0.01),
                                sliderInput(inputId = "instances_leaf", label = "Número de instancias por hoja:", min = 1, max = 1500, value = 2, step = 1),
                                tags$hr()
                                
               ),
               
               conditionalPanel(condition = "input.type_algorithms == 'enable_RandomForest'",
                                
                                sliderInput(inputId = "number_trees", label = "Número de árboles:", min = 1, max = 100, value = 20, step = 1),
                                tags$hr()
                                
               ),
               
               conditionalPanel(condition = "input.type_algorithms == 'enable_SVM'",
                                
                                selectInput("kernel", "Tipo de kernel",
                                            c("Linear" = "linear", 
                                              "Polynomial" = "polynomial",
                                              "Radial basis" = "radial",
                                              "Sigmoid" = "sigmoid")
                                ),
                                tags$hr()
                                
               ),
               
               conditionalPanel(condition = "input.type_algorithms == 'enable_NaiveBayes'",
                                
                                sliderInput(inputId = "laplace", label = "Laplace:", min = 1, max = 100, value = 3, step = 1)
                                
               )
               
           ),
		   
		   h4("Clasificador"),
		   div(class = "well",

               numericInput("instance", label = h4("Seleccione una instancia:"), value = 1, min = 1, max = 950)

           )
    ),
    
    column(width = 9,
          div(class = "well", strong("Información del Algoritmo"),
            verbatimTextOutput("resumen")
          )
           
    )
  ),
  #h3("Clasificador"),
  fluidRow(
    column(width = 12,
           div(class = "well",

               h2(textOutput("text3")),
               tableOutput("table1"),
               h4(textOutput("text1")),
               h4(textOutput("text2"))
           )
    )
           
  )
  
))
