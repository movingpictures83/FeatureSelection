library(affy)
library(limma)
library(matrixStats)

input <- function(inputfile) {
parameters <<- read.table(inputfile, as.is=T);
  rownames(parameters) <<- parameters[,1];
  print("READING INPUT FILES...");
  my_rma <<- read.table(toString(parameters["training",2]), sep = "\t", header =FALSE, stringsAsFactors=FALSE)#, nrow=20000)
  t1 <<- read.table(toString(parameters["clinical",2]), sep="\t", header = TRUE, stringsAsFactors=FALSE)
  joinby <<- toString(parameters["joinby", 2])
  case <<- toString(parameters["case", 2])
  control <<- toString(parameters["control", 2])
  targetcol <<- toString(parameters["targetcol", 2])
  targetval <<- toString(parameters["targetval", 2])
  timecol <<- toString(parameters["timecol", 2])
  timestart <<- as.double(toString(parameters["timestart", 2]))
  timeend <<- as.double(toString(parameters["timeend", 2]))
  print("DONE");
  my_rma <<- as.data.frame(t(my_rma))
} 

run <- function() {
case_number=20
control_number=20

#threshold values
pv=0.9
fch=2

g1=rep(case,case_number)
g2=rep(control,control_number)

groups=as.factor(c(g1,g2))
design<-model.matrix(~groups)
v1 <- t1[t1[,targetcol] == targetval,]
v11 <- v1[v1[,timecol]==timeend,]
v12 <- v1[v1[,timecol]==timestart,]
v13 <- rbind(v11, v12)
colnames(my_rma)[1] <- joinby
fin<-merge(v13, my_rma, by = joinby)
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


