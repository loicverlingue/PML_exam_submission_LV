#loading the data sets

testing<-read.csv("~/pml-testing.csv", row.names = "problem_id")
trainSet<-read.csv("~/pml-training.csv",na.strings= c('#DIV/0!','','NA'), stringsAsFactors = T)
trainSet$X<-NULL

# remove columns when constituted by more than 95% NAs
dim(trainSet)
trainSet<-trainSet[,as.numeric(colSums(is.na(trainSet))/nrow(trainSet))<0.95 ]
dim(trainSet)

# create cross validation dataset from training set
# this will be needed to evaluate the best method to use on the trainning set
inCV<-createDataPartition(trainSet$classe,p = 0.7,list = F)
training<-trainSet[inCV,]
crossval<-trainSet[-inCV,]

# A test for predicting with trees
Fit1<-train(classe~.,data=training,method="rpart")
Pred<-predict(Fit2,crossval)
confusionMatrix(crossval$classe,Pred)$overall

# cross validation accuracy and kappa are very low!
# note: as long as there seems to be many correlated value in the training set, a preprocessing could be performed using PCA
# however, the accuracy for prediction dont improve, therefore I have choose to discard this preprocessing method

# Another method may be performed:
# bagging is taking repeated samples from the single training set in order to generate B different bootstrapped training data sets, and average all the predictions.
# This moderates high variance and could allow better cross validation set prediction

Fit2<-train(classe~.,data=training,method="treebag")
Fit2$finalModel #high accuracy = 0.9976455

Pred<-predict(Fit2,crossval)
confusionMatrix(crossval$classe,Pred)$overall  #Even higher accuracy : 0.9986, 95% CI : (0.9973, 0.9994)

#just for fun trying with random forest, that add improvement over bagged trees by using a small tweak that decorrelates the trees.
# however with my laptop, the running time was too long to perform random forest on the training data
