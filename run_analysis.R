## This R script is created to solve the Assignment of Getting and Clean
## Data coursera course

## Setting working directory 
setwd("~/Desktop/GetCleanData/data/UCI_HAR_Dataset")
library(dplyr)
library(stringr)
library(dplyr)

## Step 1 Merging Data Sets

## Reading Original Data

dtactLabels<-read.table("./activity_labels.txt",stringsAsFactors = FALSE)
dttestlabels<-read.table("./test/y_test.txt",stringsAsFactors = FALSE)
dttestset<-read.table("./test/X_test.txt",stringsAsFactors = FALSE)
dttrainset<-read.table("./train/X_train.txt",stringsAsFactors = FALSE)
dttrainlabels<-read.table("./train/y_train.txt",stringsAsFactors = FALSE)
dttestsubject<-read.table("./test/subject_test.txt",stringsAsFactors = FALSE)
dttrainsubject<-read.table("./train/subject_train.txt",stringsAsFactors = FALSE)
dtfeatures<-read.table("./features.txt")

### Converting  tables in order to manage them with dplyr

## Combining Test & Training Data sets to Two DT
testDataSet<-as.tbl(cbind(dttestlabels,dttestset))
testDataSet<-as.tbl(cbind(dttestsubject,testDataSet))
trainDataSet<-as.tbl(cbind(dttrainlabels,dttrainset))
trainDataSet<-as.tbl(cbind(dttrainsubject,trainDataSet))

## Step 4 Appropriately labels the data set with descriptive variable names.
## fixing Columns Names & Assingin Columns Names
## Removing dots,underscores,...
mynames<-dtfeatures$V2
mynames<-tolower(mynames)
mynames<-gsub("[[:punct:]]","",mynames)


##fixing duplicate feature Names by adding "d" as separatro character
mynames<-make.unique(mynames,"d")
## Assigning colnames
colnames(trainDataSet)<-c("Subject","Activity",mynames)
colnames(testDataSet)<-c("Subject","Activity",mynames)
colnames(dtactLabels)<-c("Activity","Description")
## Step 1 Merging Training & Test DataSet

DataSet<-merge(trainDataSet,testDataSet,all=TRUE)

## Step 2 Extracts only the measurements on the mean and standard deviation
## for each measurement

DataSet_2<-select(DataSet,Subject,Activity,contains("mean"),contains("std"))

## Step 3 Uses descriptive activity names to name the activities in the data set
lev <- c(-1,dtactLabels$Activity)
lab <- dtactLabels$Description
DataSet_3<-mutate(DataSet,Activity = cut(Activity, lev, labels = lab))


## Already done!

## Step 5 average of each variable for each activity and each subject
DataSet_5<-as.tbl(group_by(DataSet_3,Activity,Subject))
DataSet_5<-summarise_each(DataSet_5,funs(mean),c(3:563))
write.table(DataSet_5,file ="../../tidy.txt")

