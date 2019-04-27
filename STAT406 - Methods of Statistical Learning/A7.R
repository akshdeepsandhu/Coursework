packageurl <- "https://cran.r-project.org/src/contrib/Archive/randomForest/randomForest_4.6-12.tar.gz"
install.packages(packageurl, repos=NULL, type="source")

library(randomForest)
setwd("~/desktop")
data <- read.table("training.txt", header=TRUE)
data$V1 <- as.factor(data$V1)

set.seed( 96353)
a.rf <- randomForest(V1~., data=data, ntree=50)
b1 <- predict(a.rf, type='class') 
b2 <- predict(a.rf, newdata=data, type='class')

table(b1, data$V1)

