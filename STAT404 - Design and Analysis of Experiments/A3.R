#Load yeilds
G1 <- c(25.3, 27.4, 33.7, 31)
G2 <- c(30.1 ,31.6, 37.1, 30.7)
G3 <- c(26.2, 31.1, 33.9, 32)
G4 <- c(32.2, 35.5, 41.9, 35.3)
G5 <- c(24, 33, 35.7, 31.4)
G6 <- c(23.2, 24.9, 26.6, 26.7) #G6 = control

#Create a response var with all of the data
y = c(G1,G2,G3,G4,G5,G6)


#4 blocks, 6 plots 
blocks <- factor(rep(1:4, times=6))
plots <- factor(rep(1:6, each=4))

#Create a dataframe 
data <- data.frame(y,plots,blocks)

#Fit the model
fit <- aov(y ~ plots + blocks,data = data )
anova <- anova(fit)
summary(fit)

mstrt <- anova["plots", "Mean Sq"]
mse <- anova["Residuals", "Mean Sq"]
f_ratio <- anova["plots", "F value"]

#se: sqrt(mse)sqrt(2/b)
b <-  4
se <- sqrt(mse)*sqrt(2/b)


se#Tukey
tukey <- TukeyHSD(fit)
#critica value for Tukey
tukey_val <- qtukey(1 - 0.05,6,15)/sqrt(2)

#one way layout
n = rep(4,6)
group <-rep(1:6,n)
data_one_way <- data.frame(y=y,group=factor(group))

fit_2 <- lm(y~group, data_one_way)
anova_model_2 <- anova(fit_2)

s.pooled <- anova_model_2$`Mean Sq`[2] #note s.pooled = MSError
df <- 18
se <- sqrt(s.pooled*(2/4))


#Ratio 
ratio <- (anova["blocks", "Mean Sq"] / mse)
ratio


#Question 4
#a
alpha_t <- 0.05
ans <- 6-(alpha_t)*6
#b ans = expected_ci - (alpha/replications)*(treatments)
alpha_tuk <- 6-(0.05/4)*6

