#get data
g1 = c(25.3 ,27.0, 20.5, 31.3, 20.5, 27.8, 25.2, 27.1, 28.0)
g2 = c( 23.7, 24.9, 34.0, 26.2, 24.0, 23.7, 26.3, 17.1, 20.2)
g3 = c( 34.0, 35.6, 27.9, 29.5, 27.5, 26.2, 29.5, 30.0, 29.9)
g4 = c(32.9, 44.2, 34.1, 36.5, 34.1, 25.5, 33.1, 31.4 ,30.3)

#create a vector combing all variables
y = c(g1,g2,g3,g4)
#create groups 
n = rep(9,4)
group=rep(1:4,n)

#function to get mean and sd
tmpfn <- function(x) c(sum = sum(x), mean = mean(x), sd = sd(x))
tapply(y,group,tmpfn)

#make dataframe 
data <- data.frame(y=y,group=factor(group))
#creat a boxplot
boxplot(g1,g2,g3,g4)

#fit anova model
fit <- lm(y~group, data)
anova_model <- anova(fit)

#get residuals
residuals <- resid(anova_model)

#plot residuals 
plot(data$y, residuals, xlab="Measurement", ylab="Residuals")
abline(0,0)

#get SE of y_i - y_k
#se = t_val*sqrt(1/n1 + 1/n2)
s.pooled <- anova_model$`Mean Sq`[2] #note s.pooled = MSError
df <- 32
t.val <- qt(0.975,32)
n <- 9
se <- sqrt(s.pooled*(2/9))

#get Fisher LSD MOE and pairwise differences
lsd <- LSD.test(y,group,32,s.pooled)
#4 are different
moe_lsd <- t.val*se

#Bonferroni adjustment
bonf <- pairwise.t.test(y, group, p.adj ="bonf")
#3 are diferent
#bonf moe
t_bonf <- qt(0.05/12,32)

#tukey 
tuk <- TukeyHSD(aov(y~group,data))
#3
#tukey moe
tukey_t <- qtukey(1 - 0.05,4,32)/sqrt(2)
tuk_moe <- tukey_t*se

tuk

#scheffe
schef <- scheffe.test(y,group,32,s.pooled)
#2 diff
sch_moe <- 2.950146*se

