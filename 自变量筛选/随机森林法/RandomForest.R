library('randomForest')

filename= 'SampleCW_species_rmUnclassified.csv'
ProbSet <- read.csv(file=filename, header=T)
x = as.matrix(ProbSet[,c(2:432)])
y = as.factor(ProbSet$Outcome)

# 调试最适合的mtry
n <- length(names(ProbSet))
set.seed(998)
a <- c()
for (i in 1:(n-1)){
    model <- randomForest(x=x,y=y,, mtry = i)
    err <- mean(model$err.rate)
    a <- append(a, err)
  }

min(a)
which.min(a)


lm.rf <-randomForest(x=x,y=y,
                     replace=F,
                     localImp=T,
                     nodesize=1,
                     nPerm=100000,)
lm.rf


which.min(lm.rf$err.rate[1])

log.rf <-randomForest(x=x,y=y,
                      ntree=which.min(lm.rf$err.rate[1]),
                      mtry=49,
                     replace=TRUE,
                     localImp=TRUE,
                     nodesize=1,
                     nPerm=100000,)
log.rf
# varImpPlot(log.rf)
importance(log.rf)

RF_coef_matrix <- as(importance(log.rf), "matrix")
write.csv(RF_coef_matrix, file = "RF_coef_rmUnclassified.csv")


