#Hwk 8 stat 404

setwd('~/desktop')
data <- read.table('data.txt')
#trt is cutting speed with: 1 = 1000, 2 = 1200 , 3 = 1400
colnames(data) <- c('trt','hardness', 'y')
data$trt <- as.factor(data$trt)

plot(data$hardness[data$trt == 3], data$y[data$trt == 3], col='green', pch=15)
points(data$hardness[data$trt == 2], data$y[data$trt == 2], col='red', pch=15)
points(data$hardness[data$trt == 1], data$y[data$trt == 1], col='black', pch=15)


legend('bottomright', legend=c("Factor 1", "Factor 2", "Factor 3"), col=c('black', 'red', 'green'), pch=15) 

fit1 <- lm(data$y ~ data$hardness + data$trt)
anova1 <- anova(fit1)


#To get Type II SS
fit2 <- lm(data$y ~ data$hardness*data$trt)
anova(fit2)
