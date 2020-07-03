library(affy)
library(limma)
library(matrixStats)

input <- function(inputfile) {
parameters <<- read.table(inputfile, as.is=T);
  rownames(parameters) <<- parameters[,1];
  print("READING INPUT FILES...");
  t1 <<- read.table(toString(parameters["training",2]), sep = "\t", header =FALSE, stringsAsFactors=FALSE)#, nrow=20000)
  my_rma <<- read.table(toString(parameters["clinical",2]), sep="\t", header = FALSE)
  print("DONE");
  my_rma <<- as.data.frame(t(my_rma))
} 

run <- function() {
case_number=20
control_number=20

#threshold values
pv=0.9
fch=2

g1=rep("T",case_number)
g2=rep("N",control_number)

groups=as.factor(c(g1,g2))
design<-model.matrix(~groups)

v1 <- t1[t1[,"STUDYID"] == "DEE1 RSV",]
v11 <- v1[v1[,"TIMEHOURS"]==0,]
v12 <- v1[v1[,"TIMEHOURS"]==-24,]
v13 <- rbind(v11, v12)
colnames(my_rma)[1] <- "CEL"
fin<-merge(v13, my_rma, by = "CEL")
cor <- fin[,13:ncol(fin)]

cor <- sapply(cor, as.numeric)
class(cor)

cor<-log2(cor)
cor <- t(cor)
li<- my_rma[1,2:ncol(my_rma)]
li= as.matrix(li)
row.names(cor)<-li
fit<-lmFit(cor, design)
fit<-eBayes(fit)
tt<<-topTable(fit,coef=2,number=nrow(cor), adjust.method="BH",sort.by="B",p.value=pv,lfc=fch)
}

output <- function(outputfile) {
write.table(tt, file = outputfile, row.names=TRUE)
}
#chosen_genes <- row.names(tt)

#Combining Age, Gender and Shedding param and doing a Random Forest

#fin2 <- merge(t1, my_rma, by = "CEL")
#genes <- fin2[,c(4, 13:ncol(fin2), 8)]
#AGES <- t1[, c(3, 4, 5, 7)]
#AGES[is.na(AGES)]<-0

#library(randomForest)
#library(rpart)
#library(rattle)

#smp_size <- floor(0.75 * nrow(AGES))
#train_ind <- sample(seq_len(nrow(AGES)), size = smp_size)

#train <- AGES[train_ind, ]
#test <- AGES[-train_ind, ]
#fit<- randomForest(as.factor(SHEDDING_SC1)~ AGE + GENDER + EARLYTX, data = train, importance = TRUE, ntree = 10 )
#my_prediction <- predict(fit,test)
#fit$confusion
#fancyRpartPlot(fit)


