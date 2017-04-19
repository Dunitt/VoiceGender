#Incluímos las librerias necesarias por el servidor
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


# Cargamos la data:
data <- read.csv(file = "../data/voice.csv", header = TRUE)

# Particionamos el dataset: 70% para entrenamiento y 30% para pruebas (esto se puede modificar para probar la precisión)
particion <- createDataPartition(y = data$label, p = 0.7, list = FALSE, times = 1)
dataTraining <- data[particion,]
dataTest <- data[-particion,]
dataTestF <- dataTest
dataTestF$label <- NULL
cl <- dataTraining$label
knnTraining <- dataTraining
knnTraining$label <- NULL

shinyServer(function(input, output) {
  
   output$summary <- renderPrint({
    summary(data)
  })
  
	output$plot <- renderPlot({
	x <- data[,input$xvar]
	y <- data[,input$yvar]
	plot(x,y,pch=19,col= c("pink", "blue"),xlab=input$xvar, ylab=input$yvar)})
	
	output$boxplot <- renderPlot({
	x <- data[,input$xvar]
	y <- data[,input$yvar]
	boxplot(x,y,pch=19,col= c("pink", "blue"),xlab=input$xvar, ylab=input$yvar)})
	
	
	output$table <- renderTable({
    data})
	
	
  output$resumen <- renderPrint({
	#Muestra el resumen adecuado para cada algoritmo
    if(input$type_algorithms == "enable_KNN"){
    	kvecinos <- knn(knnTraining, dataTestF, cl, k = input$number_neighbours, l = 0)
		A1 <- confusionMatrix(table(kvecinos, dataTest$label))
		print(A1)
    }

	if(input$type_algorithms == "enable_J48"){
		arbol <- J48(label~., dataTraining, control = Weka_control(C = input$threshold_pruning, M = input$instances_leaf))
		A2 <- confusionMatrix(table(predict(arbol, dataTestF, type = "class"), dataTest$label))
		print(A2)		
    }

	if(input$type_algorithms == "enable_RandomForest"){
		tree <- randomForest(label~., dataTraining, importance = TRUE, proximity = TRUE,  ntree = input$number_trees, norm.votes = FALSE)
		A3 <- confusionMatrix(table(predict(tree, dataTestF, type = "class"), dataTest$label))
		print(A3)
    }
    
	if(input$type_algorithms == "enable_SVM"){
		svm <- svm(label~., dataTraining, kernel = input$kernel, cost = 62.5, gamma = 0.5, coef0 = 3, degree = 3)
		A4 <- confusionMatrix(table(predict(svm, dataTestF, type = "class"), dataTest$label))
		print(A4)
    }

	if(input$type_algorithms == "enable_NaiveBayes"){
		naiveBayes<- naiveBayes(label~., dataTraining, laplace = input$laplace)
		A5 <- confusionMatrix(table(predict(naiveBayes, dataTestF, type = "class"), dataTest$label))
		print(A5)
    }
    
    
  })
  
  output$text3 <- renderText({
    "Seleccionaste la siguiente instancia:"
  })
  
  output$table1 <- renderTable({
    dataTestF[input$instance,]
  })
  
  output$text1 <- renderText({
	#Muestra la clasiificación de acuerdo al algoritmo seleccionado
	if(input$type_algorithms == "enable_KNN"){
		kvecinos <- knn(knnTraining, dataTestF[input$instance,], cl, k = input$number_neighbours, l = 0)
		paste("La instancia se clasificó como:", kvecinos)
    }

	else if(input$type_algorithms == "enable_J48"){
		arbol <- J48(label~., dataTraining, control = Weka_control(C = input$threshold_pruning, M = input$instances_leaf))
		paste("La instancia se clasificó como:", predict(arbol, dataTestF[input$instance,], type = "class"))
    }

	else if(input$type_algorithms == "enable_RandomForest"){
		tree <- randomForest(label~., dataTraining, importance = TRUE, proximity = TRUE,  ntree = input$number_trees, norm.votes = FALSE)
		paste("La instancia se clasificó como:", predict(tree, dataTestF[input$instance,], type = "class"))
    }
    
	else if(input$type_algorithms == "enable_SVM"){
		svm<- svm(label~., dataTraining, kernel = input$kernel, cost = 62.5, gamma = 0.5, coef0 = 3, degree = 3)
		paste("La instancia se clasificó como:", predict(svm, dataTestF[input$instance,], type = "class"))
    }

	else if(input$type_algorithms == "enable_NaiveBayes"){
		naiveBayes<- naiveBayes(label~., dataTraining, laplace = input$laplace)
		paste("La instancia se clasificó como:", predict(naiveBayes, dataTestF[input$instance,], type = "class"))
    }

    
  })
  
  output$text2 <- renderText({
    paste("Y realmente es:", dataTest[input$instance,]$label)
  })
  
   
})
