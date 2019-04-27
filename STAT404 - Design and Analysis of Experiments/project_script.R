#Read in both data tables
#data from sheet 2
df= read.csv("Data.csv")
data = df
#data from sheet 1
data2 = read.csv('Data2.csv')
data2 = data2[-1]

#change col names
names(data)[1] = 'y'
names(data)[2]= 'Weight'
names(data)[3]= 'Clip'
names(data)[4]= 'Length'
names(data)[5] = 'Width'

#make factors



#y is average response used for plots
y=data2$Average

#get appropriate rows from data2
Pwidth <- y[c(1,2,3,4,9,10,11,12)]
Nwidth <- y[c(5,6,7,8,13,14,15,16)]

Pweight <- y[c(9,10,11,12,13,14,15,16)]
Nweight <- y[c(1,2,3,4,5,6,7,8)]

Pbody <- y[c(1,2,7,8,9,10,15,16)]
Nbody <- y[c(3,4,5,6,11,12,13,14)]

Pclip <- y[c(1,3,5,7,9,11,13,15)]
Nclip <- y[c(2,4,6,8,10,12,14,16)]

#initial box plots 
width_plot <- boxplot(Pwidth,Nwidth, names=c('+', '-'))
weight_plot <- boxplot(Pweight, Nweight,names=c('+', '-'))
body_plot <- boxplot(Pbody, Nbody,names=c('+', '-'))
clip_plot <- boxplot(Pclip, Nclip,names=c('+', '-'))

#interaction plots

weight_clip <- interaction.plot(data2$Weight,data2$Clip,y)
weight_width <-interaction.plot(data2$Weight,data2$Width,y) 
weight_body <- interaction.plot(data2$Weight,data2$Length, y)

body_clip <- interaction.plot(data2$Length,data2$Clip,y)
body_width <- interaction.plot(data2$Length,data2$Width,y)
width_clip <- interaction.plot(data2$Width,data2$Clip,y)

#ANOVA model
fit <- lm(data$y ~ data$Weight*data$Clip*data$Length*data$Width)
anova_result <- anova(fit)


#Get qq plot
plot(fit)

#plot residuals 
redid_fit <- plot(data$y,fit$residuals)
abline(0,0)
weight_resid <- plot(data$Weight,fit$residuals)
abline(0,0)
clip_reid <- plot(data$Clip, fit$residuals)
abline(0,0)
length_resid <- plot(data$Length, fit$residuals)
abline(0,0)
width_resid <- plot(data$Width, fit$residuals)
abline(0,0)


