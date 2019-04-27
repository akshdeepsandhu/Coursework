#Stat 406 Assignment 6
setwd("~/desktop")
library(randomForest)
library(rpart)

#Get data

data.tr <- read.table("Training.txt", header=TRUE)
data.pred <- read.table('Prediction.txt', header = TRUE)

data.tr$V1 <- as.factor(data.tr$V1)
con <- rpart.control(minsplit=3, cp=1e-8, xval=10)
tree <- rpart(V1~. , data=data.tr, method='class',  parms=list(split='gini'), control=con)
plot(tree, compress=TRUE)

(b <- tree$cptable[which.min(tree$cptable[,"xerror"]),"CP"] )
plot(tree, margin=0.05)

pruned <- prune(tree, cp=b)
plot(pruned, uniform=FALSE, margin=0.01)

xerr <- tree$cptable[which.min(tree$cptable[,"xerror"]),"xerror"] 
xerr

#build randomForest
rF <- randomForest(V1~., data=data.tr, ntree=500) 
rF
#get predictions
preds <- predict(rF, newdata = data.pred, predict.all = TRUE)
cat(as.character(preds$aggregate), sep=",")
