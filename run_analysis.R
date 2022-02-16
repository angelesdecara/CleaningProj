library(dplyr)
download.file("https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip",destfile = "~/Downloads/")
feat=read.csv("~/Downloads/UCI HAR Dataset/features.txt",h=F,sep = " ")
#read training files
traindata<-read.table("~/Downloads/UCI HAR Dataset/train/X_train.txt",h=F)
trainsubj<-read.csv("~/Downloads/UCI HAR Dataset/train/subject_train.txt",h=F)
trainact<-read.csv("~/Downloads/UCI HAR Dataset/train/y_train.txt",h=F)
colnames(traindata)<-feat$V2
colnames(trainact)<-c("activity")
colnames(trainsubj)<-c("subject")
trainset<-cbind(trainsubj,trainact,traindata)
#same for testing files
testdata<-read.table("~/Downloads/UCI HAR Dataset/test/X_test.txt",h=F)
testsubj<-read.csv("~/Downloads/UCI HAR Dataset/test/subject_test.txt",h=F)
testact<-read.csv("~/Downloads/UCI HAR Dataset/test/y_test.txt",h=F)
colnames(testdata)<-feat$V2
colnames(testact)<-c("activity")
colnames(testsubj)<-c("subject")
testset<-cbind(testsubj,testact,testdata)
##now merged
mergedsets<-rbind(trainset,testset)
## but not tidy
## now get 
#Extracts only the measurements on the mean and standard deviation for each measurement. 
#so select only columns with mean or std in their names
meansstds<-mergedsets%>%select("subject","activity",ends_with("mean()"),ends_with("std()"))

# Uses descriptive activity names to name the activities in the data set
activities<-read.table("~/Downloads/UCI HAR Dataset/activity_labels.txt")
actgroup=factor(meansstds$activity) # group activities in table by factoring
levels(actgroup)<-activities$V2 #rename the levels
meansstds$activity<-actgroup # relabel

#Appropriately labels the data set with descriptive variable names. 
colnames(meansstds)<-gsub("tBody","MagnitudeBody",colnames(meansstds))
colnames(meansstds)<-gsub("tGravity","MagnitudeGravity",colnames(meansstds))
colnames(meansstds)<-gsub("Acc","Acceleration",colnames(meansstds))
colnames(meansstds)<-gsub("Gyro","AngularVelocity",colnames(meansstds))
colnames(meansstds)<-gsub("Jerk","JerkSignal",colnames(meansstds))
colnames(meansstds)<-gsub("^f","FFT",colnames(meansstds))

#From the data set in step 4, creates a second, independent tidy data set 
#with the average of each variable for each activity and each subject.
grouped<-meansstds%>%group_by(subject,activity)
averages<-summarise_each(grouped,funs = mean)

write.table(averages,file = "~/Desktop/CleaningProj/means.txt",row.names = FALSE)

