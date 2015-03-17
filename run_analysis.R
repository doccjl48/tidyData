require(reshape2)
require(dplyr)

#DOWNLOAD RAW DATA:

subtrain<-read.table("./UCI HAR Dataset/train/subject_train.txt",header=TRUE)
xtrain<-read.table("./UCI HAR Dataset/train/X_train.txt",header=TRUE)
ytrain<-read.table("./UCI HAR Dataset/train/y_train.txt",header=TRUE)
subtest<-read.table("./UCI HAR Dataset/test/subject_test.txt",header=TRUE)
xtest<-read.table("./UCI HAR Dataset/test/X_test.txt",header=TRUE)
ytest<-read.table("./UCI HAR Dataset/test/y_test.txt",header=TRUE)
feature<-read.table("./UCI HAR Dataset/features.txt",header=FALSE)
activity<-read.table("./UCI HAR Dataset/activity_labels.txt",header=FALSE)

library(reshape2)
library(dplyr)

# MERGE THE DATA FRAMES IN THE PROPER ORDER(PART 1):

temp<-cbind(subtrain,ytrain)
names(temp)<-c("ID","Activity")
temp1<-cbind(subtest,ytest)
names(temp1)<-c("ID","Activity")
temp2<-rbind(temp,temp1)
dim(temp2)
 
#DEVELOP COLUMN NAMES:
featurecolnames<-feature[,2]
names(xtrain)<-as.character(featurecolnames)
names(xtest)<-as.character(featurecolnames)
temp3<-rbind(xtrain,xtest)
dfstep1<-cbind(temp2,temp3)

#SELECT THE PORPER COLUMNS FROM THE RAW DATA:
dfstep2<-dfstep1[, grep("^ID$|^Activity$|-mean|-std",names(dfstep1))]
dfstep2$Activity<-as.factor(as.character(dfstep2$Activity))

#CHANGE VARIABLE NAMES:
levels(dfstep2$Activity)<-c("Walking","WalkingUpstairs","WalkingDownstairs","Sitting","Standing","Laying")

#ORDER BY ID AND THEN BY ACTVITY:
tdydf<-arrange(dfstep2,ID,Activity)

#AVERAGE THE VARIABLES WITH RESHAPE2:
reshapevariable<-dfstep1[, grep("-mean|-std",names(dfstep1))]
final<-melt(tdydf,id=c("ID","Activity"),measure.vars=c(names(reshapevariable)))
myData<-dcast(final, ID + Activity ~ variable, mean)

#FINAL ANALYSIS:
myData
# write.table(myData,file="myData.txt",row.names=FALSE)
