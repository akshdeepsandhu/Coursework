#Quiz 4 
library(rpart)
#Get data
setwd("~/desktop")
dat.tr <- read.table('training.txt', header = TRUE)
dat.te <- read.table('test.txt', header=TRUE)

#Q1
#given control parameter
set.seed(193166)
control = rpart.control(minsplit = 2, cp = 1e-8, xval = 20)

#Create a tree
crime.to = rpart(dat.tr$ViolentCrimesPerPop ~ ., data=dat.tr, method='anova', control = control)
plot(crime.to, compress=TRUE)

#get best CP and prune tree
(c <- crime.to$cptable[which.min(crime.to$cptable[,'xerror']), "CP"])
crime.pr <- prune(crime.to, cp=c)


plot(crime.pr,margin=0.1)

#Q2
#get MSPE
pred.pr <- predict(crime.pr, newdata = dat.te,type ='vector')
mspe.tree <- with(dat.te, mean((ViolentCrimesPerPop - pred.pr)^2))
round(mspe.tree,4)


library(glmnet)
#given lambdas
#Test and training vectors
lambdas = exp(seq(-10, 5, length=100))
y <- as.vector(dat.tr$ViolentCrimesPerPop)
xm <- as.matrix(subset(dat.tr, select = -c(ViolentCrimesPerPop)))

y.te = as.vector(dat.te$ViolentCrimesPerPop)
xm.te <- as.matrix(subset(dat.te, select = -c(ViolentCrimesPerPop)))

set.seed(522019)
n=95
k=10
#10 fold CV to get best lambda and get MSPE for LASSO
fit <- cv.glmnet(x=xm, y=y, lambda = lambdas, nfolds = k, alpha=1,family='gaussian', intercept=TRUE)
pred.fit <- predict(fit, s='lambda.min', newx = xm.te)
mspe.fit <- with(dat.te, mean((ViolentCrimesPerPop - pred.fit)^2))
round(mspe.fit,4)

#Q3
#value of 10th prediction
BagOfTrees <- readRDS('BagOfTrees.rds')
tenth <- dat.tr[10,]
tenth.obs <- subset(tenth, select = -c(ViolentCrimesPerPop))

#Loop vs rowMeans
pr.bagg1 <- rep(0, nrow(dat.tr))
for(j in 1:20)
  pr.bagg1 <- pr.bagg1 + predict(BagOfTrees[[j]], newdata=dat.tr) / 20

with(dat.tr, mean( (ViolentCrimesPerPop- pr.bagg1)^2 ) )

pr.bagg <- rowMeans(sapply(BagOfTrees, predict,newdata=dat.tr))
round(pr.bagg[10],2)
#Q4
#get MSE
mse.bagg <- with(dat.tr, mean( (ViolentCrimesPerPop- pr.bagg)^2 ) )
round(mse.bagg,3)

#Q5
#get MSPE
pr.bagg2 <- rowMeans(sapply(BagOfTrees, predict,newdata=dat.te))
mspe.bagg2 <- with(dat.te, mean((ViolentCrimesPerPop - pr.bagg2)^2))
round(mspe.bagg2,4)

#Q6
N <- 50
mybag <- vector('list', N)

for(j in 1:N) {
  ii <- sample(nrow(dat.tr), replace=TRUE)
  mybag[[j]] <- rpart(ViolentCrimesPerPop ~ ., data=dat.tr[ii, ], method='anova', control=control)
}

pr.bagg3 <- rowMeans(sapply(mybag, predict,newdata=dat.te))
mspe.bagg3 <- with(dat.te, mean((ViolentCrimesPerPop - pr.bagg3)^2))
round(mspe.bagg3,4)
