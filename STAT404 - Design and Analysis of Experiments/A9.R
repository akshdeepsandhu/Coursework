chem1 <- c(77.3, 82.9, 92.8, 76.1 )
chem2 <- c(79.3, 81.8, 80.3, 80.5 )
chem3 <- c(91.6, 80.7, 80.6, 79.5 )
chem4 <- c(77.4, 78.5, 77.6, 77.9 )

#Create a response variable
y = c(chem1,chem2,chem3,chem4)

#create factor labels
factors <- factor(rep(1:4,each=4))

#create a dataframe
df <- data.frame(y,factors)


#get mean and SD for each data vector
mu1 <- mean(chem1)
sd1 <- sd(chem1)

mu2 <- mean(chem2)
sd2 <- sd(chem2)

mu3 <- mean(chem3)
sd3 <- sd(chem3)

mu4 <- mean(chem4)
sd4 <- sd(chem4)

mu1;mu2;mu3;mu4
sd1;sd2;sd3;sd4

#fit anova model 
fit <- aov(y~factors,data=df)
summary(fit)

#confidence interval
n <- 4
a <- 4
N <- 16
(1/n)*(0.943/qf(0.05/2, a-1, N-a)-1)
#Questio 2, power calculations
a = 4
gamma = 1.2
n = c(3:15)
cv=qf(0.95,a-1,a*(n - 1))
w=cv/(1 + n*gamma)
power=1-pf(w,a-1,a*(n - 1))
powertable <- data.frame(n,power)
powertable
