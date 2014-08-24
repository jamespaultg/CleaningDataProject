## Coursera - Data science specialisation
## Course - Getting and Cleaning Data
## Project - Analysis of data gathered from Wearable computing
## Version 1.0
## Date : 24-Aug-2014
##
## The R script does the following
##  Merges the training and the test sets to create one data set.
##  Extracts only the measurements on the mean and standard deviation for each measurement. 
##  Uses descriptive activity names to name the activities in the data set
##  Appropriately labels the data set with descriptive variable names. 
##  Creates a second, independent tidy data set with the average of 
##  each variable for each activity and each subject. 
##
## Check out the "readme.md" file on the input, output and processing logic for this script
## Assumed that the files are available in the working directory.
## 
# Read the input files
activity_labels <- read.csv("activity_labels.txt",header=FALSE,sep=" ")
features <- read.csv("features.txt",header=FALSE,sep=" ")

# Read the test files
y_test <- read.csv("test//y_test.txt",header=FALSE,sep=" ")
X_test <- read.table("test//X_test.txt",header=FALSE)
subject_test <- read.csv("test//subject_test.txt",header=FALSE,sep=" ")

# Check the dimensions of the datasets read
dim(activity_labels)
dim(features)
dim(y_test)
dim(X_test)
dim(subject_test)

# Assign column names
# the features.txt file contains the names of the 561 columns read # from the X_test/train file
names(y_test) <- "activityID"
names(subject_test) <- "subjectID"
names(X_test) <- features$V2
# Bind the columns and create dataframe for the test data
test_df <- cbind(subject_test,y_test,X_test)

# Read the training files
y_train <- read.csv("train//y_train.txt",header=FALSE,sep=" ")
X_train <- read.table("train//X_train.txt",header=FALSE)
subject_train <- read.csv("train//subject_train.txt",header=FALSE,sep=" ")
# Check the dimensions of the datasets read
dim(y_train)
dim(X_train)
dim(subject_train)

# Assign column names
names(y_train) <- "activityID"
names(subject_train) <- "subjectID"
names(X_train) <- features$V2
# Bind the columns and create dataframe for the training data
train_df <- cbind(subject_train,y_train,X_train)

###############################################################################################
# 1. Merges the training and the test sets to create one data set.
###############################################################################################
combined_df <- rbind(test_df,train_df)
print(object.size(combined_df),units="Mb")

###############################################################################################
# 2. Extracts only the measurements on the mean and standard deviation for each measurement
###############################################################################################
meancols <- grep("mean",names(combined_df))
stdcols <- grep("std",names(combined_df))
finaldf <- combined_df[,c(1,2,meancols,stdcols)]
dim(finaldf)

###############################################################################################
# 3. Uses descriptive activity names to name the activities in the data set
###############################################################################################
finaldf$ActivityDesc <- activity_labels$V2[match(finaldf$activityID,activity_labels$V1)]
dim(finaldf)

###############################################################################################
# 4. Appropriately labels the data set with descriptive variable names
###############################################################################################To
namelist <- names(finaldf)
namelist <- gsub("-m","-M",namelist)
namelist <- gsub("-s","-S",namelist)
namelist <- gsub("\\()|-","",namelist)
names(finaldf) <- namelist

###############################################################################################
# 5. Creates a second, independent tidy data set with the average of each variable for each activity and each subject
###############################################################################################
install.packages("plyr")
library(plyr)
tidydata <- ddply(finaldf, .(activityID, ActivityDesc, subjectID), colwise(mean))
namelist <- names(tidydata)
namelist[4:length(namelist)] <- paste("mean",namelist[4:length(namelist)],sep="_")
names(tidydata) <- namelist

write.table(tidydata,"tidydata.txt")
