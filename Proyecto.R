# Queremos saber el sexo de una persona de acuerdo a las propiedades acústicas de su voz
# install.packages("caret")
# install.packages("class")
setwd("~/Escritorio/VoiceGender")
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

# Cargamos la data:
raw <- read.csv(file = "voice.csv", header = TRUE)
data <- raw
# [,c("meanfreq","sd","median","skew","kurt","sp.ent","sfm","mode","centroid","meanfun","meandom","dfrange","modindx","gender")]
# KNN funciona mejor con:
# data<-raw[,c("IQR","sd","sp.ent","gender")]

# Particionamos el dataset: 70% para entrenamiento y 30% para pruebas (esto se puede modificar para probar la precisión)
particion <- createDataPartition(y = data$gender, p = 0.7, list = FALSE, times = 1)
dataTraining <- data[particion,]
dataTest <- data[-particion,]
dataTestF <- dataTest
dataTestF$gender <- NULL

# Utilizamos como número de vecinos K=3 para el criterio del algoritmo.

cl <- dataTraining$gender
knnTraining <- dataTraining
knnTraining$gender <- NULL
# En general con l = 3 funciona mejor, pero deja muchos casos sin clasificar.
kvecinos.model <- knn(knnTraining, dataTestF, cl, k = 3, l = 0)

kvecinos.confusion <- confusionMatrix(table(kvecinos, dataTest$gender))
# A1$overall[1]
print("KNN [l = 3]")
print(kvecinos.confusion$overall[1])

# -C Umbral de confianza para podar. (0.25)
# -M Mínimo de instancias por hoja. (2)
# No tiene mucho sentido asignar a la variable "control"
# los valores que ya se usan por defecto.
arbol <- J48(gender~., dataTraining, control = Weka_control(C = 0.25, M = 2))
# Innecesario porque J48 ya genera una matriz de confusión.
# A2 <- confusionMatrix(table(predict(arbol, dataTestF, type = "class"), dataTest$gender))
# A2$overall[1]
print("ÁRBOL")
# print(A2$overall)
# print(arbol)
print(summary(arbol))

# Para generar una imagen del árbol resultante.
# if (require("party", quietly = TRUE)){
#   plot(arbol)
# }


# Desconozco la utilidad de "norm.votes".
tree <- randomForest(gender~., dataTraining, importance = TRUE, proximity = TRUE,  ntree = 20, norm.votes = FALSE)
A3 <- confusionMatrix(table(predict(tree, dataTestF, type = "class"), dataTest$gender))
# A3$overall[1]
print("BOSQUE ALEATORIO")
print(tree$confusion)
print(A3$overall[1])
# Prefiero calcular la precisión de esta manera porque no tiene sentido usar métodos
# externos cuando el paquete te ofrece la matriz de confusión (tree$confusion).
mt <- as.data.frame(tree$confusion)
mt[,"class.error"] <- NULL
mt <- as.matrix(mt)
print(sum(diag(mt))/sum(mt))



# No se observa una diferencia significativa entre los tipos de kernel,
# excepto por "sigmoid" que degrada notablemente la precisión.
# (Con "radial" se obtiene el mejor resultado)
# degree parámetro necesario para el kernel polinomial (por defecto: 3)
# gamma parámetro necesario para todos los kernels, excepto el lineal (por defecto: 1/(data dimension))
# coef0 parámetro necesario para los kernels polinomial y sigmoid (por defecto: 0)
# kernel:
# linear: u'v
# polynomial: (γu'v + coef0)^degree
# radial basis: e^(− γ|u − v|^2)
# sigmoid: tanh(γu'v + coef0)
svm.model <- svm(gender~., dataTraining, kernel = "radial", cost = 62.5, gamma = 0.5, coef0 = 3, degree = 3)
A4 <- confusionMatrix(table(predict(svm.model, dataTestF, type = "class"), dataTest$gender))
#A4$overall[1]
print("SVM")
print(A4$overall[1])


# Seguro este método sumará puntos con el profesor, porque él dijo que tenía un error
# y nosotros lo tenemos funcionando.
# Nuevo método agregado, si quieres dedicar tiempo a probar los parámetros sería genial.
# Desconozco la utilidad del parámetro "laplace", pero afecta notablemente la precisión.
naiveBayes.model <- naiveBayes(gender~., dataTraining, laplace = 4)
A5 <- confusionMatrix(table(predict(naiveBayes.model, dataTestF, type = "class"), dataTest$gender))
print("NAIVE BAYES")
print(A5$overall[1])


# No sé por qué, pero no me agradan los números impares, 
# si el tiempo me alcanza -lo dudo-, agrego un nuevo método.


# Conclusión: Usaremos Random Forest
# Yo concluí que J48 era ligeramente mejor.