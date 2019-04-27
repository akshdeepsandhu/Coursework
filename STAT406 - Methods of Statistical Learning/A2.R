dat <- read.table("quiz_2_dat.txt", header = TRUE)
null <- lm(MORT~ 1, data=dat)
full <- lm(MORT~., data=dat) # needed for stepwise

step.forward.lm <- stepAIC(null, scope=list(lower=null, upper=full), trace=FALSE,direction = 'forward')
step.backward.lm <- stepAIC(full, trace=FALSE,direction = 'backward')

model.given <- lm(MORT ~ POOR + HC + HOUS + NONW, data=dat)

#Get AIC
extractAIC(full);extractAIC(model.given);extractAIC(step.forward.lm);extractAIC(step.backward.lm);

#Leave one out 
n <- nrow(dat)
pr.full <- pr.reduced <- pr.step.forward <- pr.step.backward <- rep(0, n)
for(i in 1:n) {
  full.model <-  lm(MORT~., data=dat[-i,])
  reduced.model <- lm(MORT ~  POOR + HC + HOUS + NONW,data=dat[-i,])
  #stepwise
  null.step <- lm(MORT~ 1, data=dat[-i,])
  forward.model <- stepAIC(null.step, scope=list(lower=null, upper=full), trace=FALSE,direction = 'forward')
  backward.model <- stepAIC(full.model, trace = F,direction = 'backward')
  #get predictions
  pr.full[i] <- predict(full.model,newdata=dat[i,])
  pr.reduced[i] <- predict(reduced.model,newdata=dat[i,])
  pr.step.forward[i] <- predict(forward.model, newdata=dat[i,])
  pr.step.backward[i] <- predict(backward.model, newdata=dat[i,])
}

mspe.full <- mean((dat$MORT - pr.full)^2)
mspe.reduced <- mean((dat$MORT - pr.reduced)^2)
mspe.forward <- mean((dat$MORT - pr.step.forward)^2)
mspe.backward <- mean((dat$MORT - pr.step.backward)^2)

round(mspe.full);round(mspe.backward);round(mspe.forward);round(mspe.reduced)



