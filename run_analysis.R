### set working directory to right location and create directory in Project
setwd('~/Desktop/RStudio/Cleaning data Projet')
dir.create('UCI HAR Dataset')

### download data from website and unzip 
fileUrl <- 'https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip'
download.file(fileUrl, 'UCI-HAR-dataset.zip', method='curl')
unzip('./UCI-HAR-dataset.zip')


# Read and bind the rows of the training and test set 
X.train <- read.table('./UCI HAR Dataset/train/X_train.txt')
X.test <- read.table('./UCI HAR Dataset/test/X_test.txt')
X <- rbind(X.train, X.test)

## read and combine subject identifiers 
## also inspect corresponding number of rows
subject.train <- read.table('./UCI HAR Dataset/train/subject_train.txt')
subject.test <- read.table('./UCI HAR Dataset/test/subject_test.txt')
subject <- rbind(subject.train, subject.test)
# Assign column name
colnames(subject) <- 'subject_id'

## read and combine conditions and inspect number of rows
y.train <- read.table('./UCI HAR Dataset/train/y_train.txt')
y.test <- read.table('./UCI HAR Dataset/test/y_test.txt')
y <- rbind(y.train, y.test)

## take the info on activities to generate the data labes
activity_labels <- read.table('./UCI HAR Dataset/activity_labels.txt')
y[, 1] = activity_labels[y[, 1],2]
colnames(y) <- 'type_activity'

## select only the mean and SD for each measurement on the basis of features
features <- read.table('./UCI HAR Dataset/features.txt')
mean.SD <- grep("mean|std", features$V2)
# select columns on the basis of these two features
X.mean.SD <- X[, mean.SD]

## take the info on the features to assign verbal labels
names(X.mean.SD) <- features[mean.SD, 2]

## combine all
projectdata <- cbind(subject,y, X.mean.SD)


################
# Creates a second, independent tidy data set with the average of each variable for each activity and each subject. 
variable_activity_averaged <- aggregate(x=projectdata, by=list(typeofactivity=projectdata$type_activity, subjectid=projectdata$subject_id), FUN=mean)
write.table(variable_activity_averaged, './variable_activity_averaged.txt', row.names = F)
