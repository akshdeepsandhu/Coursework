#Quiz 10
data <- read.table('404_quiz_10_data.txt', header=TRUE)

data$lot <- as.factor(data$lot)
data$roll <- as.factor(data$roll)

mu1 <- mean(data$porosity[data$lot == 1])
mu2 <- mean(data$porosity[data$lot == 2])
mu3 <- mean(data$porosity[data$lot == 3])


means <- tapply(data$porosity,data$lot,mean);

mu1;mu2;mu3

#preform Anova
fit <- lm(data$porosity~data$lot + roll%in%lot, data=data);
anova(fit)


sigmaRoll <- (4.1272 - 0.8647)/12

#get sd for variability question
tapply(data$porosity,data$lot,sd);tapply(data$porosity,data$lot,mean)




sigma <- c( 0.4699291, 0.8638796, 2.0727671  )
mu <- c(2.058333, 2.541667, 4.100000 )

data$porosity <- sqrt(data$porosity)
plot(data$porosity)
fit <- lm(data$porosity~data$lot + roll%in%lot, data=data);
anova(fit)

