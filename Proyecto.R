##Queremos saber el sexo de una persona de acuerdo a las propiedades acústicas de su voz
#install.packages("caret")
#install.packages("class")
setwd("~/Escritorio/VoiceGender")
library(shiny)
library(rmarkdown)
library(class)
library(randomForest)
library(foreach)
library(caret)
library(e1071)
library(rpart)
library(tree)
library(RWeka)
library(C50)

##Cargamos la data:
raw = read.csv(file="voice.csv", header=TRUE)
data = raw
##[,c("meanfreq","sd","median","skew","kurt","sp.ent","sfm","mode","centroid","meanfun","meandom","dfrange","modindx","gender")]
## KNN funciona mejor con:
##data=raw[,c("IQR","sd","sp.ent","gender")]

##Particionamos el dataset: 70% para entrenamiento y 30% para pruebas (esto se puede modificar para probar la precisión)
particion = createDataPartition(y=data$gender, p=0.7, list=FALSE, times=1)
dataTraining <- data[particion,]
dataTest <- data[-particion,]
dataTestF <- dataTest
dataTestF$gender = NULL

##Utilizamos como número de vecinos K=3 para el criterio del algoritmo.

cl=dataTraining$gender
knnTraining = dataTraining
knnTraining$gender=NULL
kvecinos = knn(knnTraining, dataTestF, cl, k = 3)
A1 = confusionMatrix(table(kvecinos,dataTest$gender))
A1$overall[1]

arbol <- J48(gender~.,dataTraining,control=Weka_control(C = 0.25, M=2))
A2 = confusionMatrix(table(predict(arbol,dataTestF,type="class"), dataTest$gender))
A2$overall[1]

tree <- randomForest(gender~.,dataTraining, ntree=20,norm.votes=FALSE)
A3 = confusionMatrix(table(predict(tree,dataTestF,type="class"), dataTest$gender))
A3$overall[1]

svm.model <- svm(gender~.,dataTraining,cost=62.5,gamma=0.5)
A4= confusionMatrix(table(predict(svm.model,dataTestF,type="class"),dataTest$gender))
A4$overall[1]

##Conclusión: Usaremos Random Forest