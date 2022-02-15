---
title: "CodeBook.md"
author: "Angeles Rodriguez de Cara"
date: "2/15/2022"
output: html_document
---

```{r setup, include=FALSE}
knitr::opts_chunk$set(echo = TRUE)
```

## Code Book for project of Getting and Cleaning data coursera

Using the UCI dataset downloaded from <https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip>

Firstly, it is downloaded into my ~/Downloads/ folder. There I unzipped on the command line, but alternatively, we could have used unzip() on R. 

```
download.file("https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip",destfile = "~/Downloads/")
```

Features are read into variable feat.
```
feat=read.csv("~/Downloads/UCI HAR Dataset/features.txt",h=F,sep = " ")
```


The training data are read separately from the testing data (traindata and testdata, respectively), and using the subject and activity files (read into trainsubj, trainact, testsubj and testact respectively for the training and testing data), we provide names for each individual/subject and for each activity they performed applying colnames. In that way, the data are more complete, and every row represents one observation. The data are merged with the subject id and the activity id using cbind (trainset and testset for the training data and the testing data, respectively).

```
traindata<-read.table("~/Downloads/UCI HAR Dataset/train/X_train.txt",h=F)
trainsubj<-read.csv("~/Downloads/UCI HAR Dataset/train/subject_train.txt",h=F)
trainact<-read.csv("~/Downloads/UCI HAR Dataset/train/y_train.txt",h=F)
colnames(traindata)<-feat$V2
colnames(trainact)<-c("activity")
colnames(trainsubj)<-c("subject")
trainset<-cbind(trainsubj,trainact,traindata)
#
testdata<-read.table("~/Downloads/UCI HAR Dataset/test/X_test.txt",h=F)
testsubj<-read.csv("~/Downloads/UCI HAR Dataset/test/subject_test.txt",h=F)
testact<-read.csv("~/Downloads/UCI HAR Dataset/test/y_test.txt",h=F)
colnames(testdata)<-feat$V2
colnames(testact)<-c("activity")
colnames(testsubj)<-c("subject")
testset<-cbind(testsubj,testact,testdata)
```

The training dataset and the testing dataset can be merged using rbind as they have the same columns (merged into variable mergedsets).

```
mergedsets<-rbind(trainset,testset)
```

Then, in order, to select the columns with mean and std we used select() and selected the columns with subject and activity ids and those columns that ended with mean() and std(), into variable meansstds. 

```
meansstds<-mergedsets%>%select("subject","activity",ends_with("mean()"),ends_with("std()"))
```

The activity id was replaced with its description after reading the file with the description into variable activities, grouping the activity ids as a factor (actgroup) which levels are then renamed as the description so that they can then be copied directly.

```
activities<-read.table("~/Downloads/UCI HAR Dataset/activity_labels.txt")
actgroup=factor(meansstds$activity) # group activities in table by factoring
levels(actgroup)<-activities$V2 #rename the levels
meansstds$activity<-actgroup # relabel
```

The description of the variables was added using **gsub**.
```
#Appropriately labels the data set with descriptive variable names. 
colnames(meansstds)<-gsub("tBody","MagnitudeBody",colnames(meansstds))
colnames(meansstds)<-gsub("tGravity","MagnitudeGravity",colnames(meansstds))
colnames(meansstds)<-gsub("Acc","Acceleration",colnames(meansstds))
colnames(meansstds)<-gsub("Gyro","AngularVelocity",colnames(meansstds))
colnames(meansstds)<-gsub("Jerk","JerkSignal",colnames(meansstds))
colnames(meansstds)<-gsub("^f","FFT",colnames(meansstds))
```

Finally, a tidy dataset called averages was created with the means of each variable after having grouped by subject and activity (variable grouped).

```
grouped<-meansstds%>%group_by(subject,activity)
averages<-summarise_each(grouped,funs = mean)
```

And we write it to a file to upload it to the repository.
```
write.table(averages,file = "~/Desktop/CleaningProj/MeansIndivsActivity.csv")
```


