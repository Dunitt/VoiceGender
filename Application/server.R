#
# This is the server logic of a Shiny web application. You can run the 
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#

library(shiny)
library(rpart.plot)
library(rmarkdown)
library(class)
library(randomForest)
library(foreach)
library(caret)
library(e1071)
library(rpart)
library(tree)
library(RWeka)
library(party)
library(C50)
library(shinythemes)
library(ggvis)

setwd("~/Escritorio/VoiceGender")

# Cargamos la data:
raw <- read.csv(file = "voice.csv", header = TRUE)
data <- raw

# Particionamos el dataset: 70% para entrenamiento y 30% para pruebas (esto se puede modificar para probar la precisión)
particion <- createDataPartition(y = data$gender, p = 0.7, list = FALSE, times = 1)
dataTraining <- data[particion,]
dataTest <- data[-particion,]
dataTestF <- dataTest
dataTestF$gender <- NULL


# Define server logic required to draw a histogram
shinyServer(function(input, output) {
  
  output$distPlot <- renderPlot({
  
    if(input$type_algorithms == "enable_KNN"){
    
      # print(dataTraining)
      
      # # Utilizamos como número de vecinos K=3 para el criterio del algoritmo.
      cl <- dataTraining$gender
      knnTraining <- dataTraining
      knnTraining$gender <- NULL
      # # En general con l = 3 funciona mejor, pero deja muchos casos sin clasificar.
      kvecinos.model <- knn(knnTraining, dataTestF, cl, k = 3, l = 0,  prob = TRUE)
      # # prob <- attr(kvecinos.model, "prob")
      # # prob <- ifelse(kvecinos.model == "1", prob, 1-prob)
      # # Obtenemos la matriz de confusión.
      kvecinos.confusion <- confusionMatrix(table(kvecinos.model, dataTest$gender))
      # print(kvecinos.model)
      # # print("PRUEBA")
      plot(kvecinos.model)
        
    }
    # else if(input$type_algorithms == "enable_J48"){
      
      # # -C Umbral de confianza para podar. (0.25)
      # # -M Mínimo de instancias por hoja. (2)
      # # No tiene mucho sentido asignar a la variable "control"
      # # los valores que ya se usan por defecto.
      # arbol <- J48(gender~., dataTraining, control = Weka_control(C = 0.25, M = 2))
      # # Innecesario porque J48 ya genera una matriz de confusión.
      # # A2 <- confusionMatrix(table(predict(arbol, dataTestF, type = "class"), dataTest$gender))
      # # A2$overall[1]
      # # print("ÁRBOL")
      # # print(A2$overall)
      # # print(arbol)
      # print(summary(arbol))
      # 
      # # Para generar una imagen del árbol resultante.
      # # if (require("party", quietly = TRUE)){
      #   plot(arbol)
      # # }
      
      
    # }
    
    
  })
  
  output$text3 <- renderText({
    "Seleccionaste la siguiente instancia:"
  })
  
  output$table1 <- renderTable({
    dataTestF[input$instance,]
  })
  
  output$text1 <- renderText({
    # paste("La instancia se clasificó como:", predict(arbol, dataTestF[input$instance,], type = "class"))
    
  })
  
  output$text2 <- renderText({
    paste("Y realmente es:", dataTest[input$instance,]$gender)
  })
  
})
