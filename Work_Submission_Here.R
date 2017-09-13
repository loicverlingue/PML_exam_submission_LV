#loading the data sets

testing<-read.csv("~/pml-testing.csv", row.names = "problem_id")
trainSet<-read.csv("~/pml-training.csv",na.strings= c('#DIV/0!','','NA'), stringsAsFactors = T)
trainSet$X<-NULL

# remove columns when constituted by more than 95% NAs
dim(trainSet)
trainSet<-trainSet[,as.numeric(colSums(is.na(trainSet))/nrow(trainSet))<0.95 ]
dim(trainSet)
