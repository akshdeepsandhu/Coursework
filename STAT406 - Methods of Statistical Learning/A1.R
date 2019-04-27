#R-script for stat 406 assignment 1
data.tr = read.table("training.txt", header=TRUE)
#create a full linear regression model
full= lm(MORT~., data=data.tr)
reduced = lm(MORT ~ POOR + HC + NOX + HOUS + NONW, data=data.tr)

#get test data
data.tst = read.table("test.txt", header=TRUE)

#get prediction 
pred.full = predict(full, newdata = data.tst)
pred.reduced = predict(reduced, newdata = data.tst)

#Use these predictions to get MSPE
MSPE_full = with(data.tst, mean((MORT - pred.full)^2))
MSPE_reduced = with(data.tst, mean((MORT - pred.reduced)^2))

#Get a better model
reduced_2 = lm(MORT ~ PREC + DENS + SO + NONW , data=data.tr)
pred.reduced_2 = predict(reduced_2, newdata=data.tst)
with(data.tst, mean((MORT-pred.reduced_2)^2))




