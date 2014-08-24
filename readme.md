
The R script(run_analysis.R) does the following
Merges the training and the test sets to create one data set.
Extracts only the measurements on the mean and standard deviation for each measurement. 
Uses descriptive activity names to name the activities in the data set
Appropriately labels the data set with descriptive variable names. 
Creates a second, independent tidy data set with the average of each variable for each activity and each subject. 

#Input data
https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip
Input datasets used for the analysis is listed as follows
- 'features.txt': List of all 561 features
- 'activity_labels.txt': Links the activityID with their activity description.

##Training data
- 'train/X_train.txt': Data(refer features.txt) on each of the test subjects
- 'train/y_train.txt': Each row identifies the activityID(1 through 6) performed
- 'train/subject_train.txt': Each row identifies the subject who performed the activity for each window sample.

##Test data
- 'test/X_test.txt': Data(refer features.txt) on each of the test subjects
- 'test/y_test.txt': Each row identifies the activityID(1 through 6) performed
- 'test/subject_test.txt': Each row identifies the subject who performed the activity for each window sample

##More information on the data
http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones 



#Output file
tidydata.csv - Has a header with the variable names. Can be read using read.table()


#Processing logic
Read the input files mentioned above.  
Note: The X_test and X_train files are read correctly using read.table() - the data in the file is without separators and doesn't read correctly when using read.csv().
After checking the dimensions of the files, proceeded to separately create dataframe for the training and test data, by binding the activityID, subjectID and the corresponding observations.  Named the columns of the dataframe with the content of the features.txt file
Combined the training and test dataframe
Using grep, selected the columns which contains either "mean" or "std" in their names.
Introduced a column to include the activity description, which was obtained by matching the activityID with the activity names in the file activity_labels.txt

Column names: Replaced parenthesis and hyphen with "", and retained the Camel case to ensure readability. I felt converting to lowercase affects readability.

Used the ddply in the plyr package, to get the mean of all the columns for each activity and subject and stored it to the tidydata

Named the columns of the tidydata. I prefixed the variables with "mean_". I felt the underscore makes it more readable.

Created a tidydata.csv file using write.table function.
