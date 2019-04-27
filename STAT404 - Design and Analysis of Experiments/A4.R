setwd('~/desktop')
#https://mcfromnz.wordpress.com/2011/03/02/anova-type-iiiiii-ss-explained/ reference
data = read.table('ww5.txt', sep='')

data$V1 <- as.factor(data$V1)
data$V2 <- as.factor(data$V2)

plot.design(data)
interaction.plot(data$V1,data$V2, data$V3)
fit <- lm(V3 ~ V1*V2, data=data)
anova(fit)
#Type 2
fit2 <- lm(V3 ~ V2*V1, data = data)
anova(fit2)
