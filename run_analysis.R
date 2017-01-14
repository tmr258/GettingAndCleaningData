# run_analysis.R is the result of the programming assignment of Week 4 for the 
# "Getting and Cleaning Data" module of the Coursera Data Science Specialisation offered
# by the Johns Hopkins University
#
# The functionality of run_analysis is:
#
# 1.	It merges the training and the test sets to create one data set.
# 2.	It extracts only the measurements on the mean and standard deviation for each measurement. 
# 3.	It uses descriptive activity names to name the activities in the data set
# 4.	It appropriately labels the data set with descriptive variable names. 
# 5.	From the data set in step 4, it creates a second, independent tidy data set with the 
#     average of each variable for each activity and each subject.

# Step 1: merging the training and test set to one set

# Setting the working directory for the metadata files

setwd("~/Datasciencecoursera/Module3week4/UCI HAR Dataset")

# Reading the features file to later use in the names for the columns of the total_rundata_set

features <- read.table("features.txt")

# Setting the working directory for the training set

setwd("~/Datasciencecoursera/Module3week4/UCI HAR Dataset/train")

# read the training data from the files in the train directory

X_train_df <- read.table("X_train.txt", sep = "", quote="", stringsAsFactors = FALSE)
y_train_df <- read.table("y_train.txt", sep = "", quote="", stringsAsFactors = FALSE)
subject_train_df <- read.table("subject_train.txt", sep = "" , stringsAsFactors=FALSE)

# Setting the working directory for the test set

setwd("~/Datasciencecoursera/Module3week4/UCI HAR Dataset/test")

# read the training data from the files in the test directory

X_test_df <- read.table("X_test.txt", sep = "" , stringsAsFactors=FALSE)
y_test_df <- read.table("y_test.txt", sep = "", stringsAsFactors=FALSE)
subject_test_df <- read.table("subject_test.txt", sep = "" , stringsAsFactors=FALSE)

# In the next steps the training data and test data are bound together in one data frame for the training
# data and one data frame for the test data.

train_df <- cbind.data.frame(X_train_df, subject_train_df, y_train_df)
test_df  <- cbind.data.frame(X_test_df,  subject_test_df,  y_test_df)

# Now to complete all the merging the total_rundata_set is created bij adding all rows together
# all the Samsung run data are now in one data frame

total_rundata_set <- rbind.data.frame(train_df, test_df)

# Create variable labels 
# The variable labels have been read from the features.txt file and are contained in the features object
# in a for loop all the features are added to the columns as names
# In an additional action the unique ID's for the testpersons (ranging from 1-30), and the activities are 
# added as column name, in columns 562 ans 563

for (i in 1:561) {
  colnames(total_rundata_set)[i] <- as.character(features[i,2])
} 
colnames(total_rundata_set)[562] <- "Unique_ID_of_testperson"
colnames(total_rundata_set)[563] <- "Activity_of_the_testperson"

# Remove the temporary objects to free up memory for the next steps
rm(X_test_df)
rm(X_train_df)
rm(y_test_df)
rm(y_train_df)
rm(subject_test_df)
rm(subject_train_df)
rm(train_df)
rm(test_df)
rm(features)

# The next for loop is done to replace the values in the column for the Activity for 
# the testperson with understandable wording. This data is contained in activity_names.txt
# but the choice for efficiency reasons was to implement this with a simple for loop and 
# not by reading the file and programming code for that

for (i in 1:length(total_rundata_set[,1])) { 
  if (total_rundata_set[i,"Activity_of_the_testperson"] == 1) 
    { total_rundata_set[i,"Activity_of_the_testperson"] <- "Walking"}
  if (total_rundata_set[i,"Activity_of_the_testperson"] == 2) 
    { total_rundata_set[i,"Activity_of_the_testperson"] <- "Walking upstairs"}
  if (total_rundata_set[i,"Activity_of_the_testperson"] == 3) 
    { total_rundata_set[i,"Activity_of_the_testperson"] <- "Walking downstairs"}
  if (total_rundata_set[i,"Activity_of_the_testperson"] == 4) 
    { total_rundata_set[i,"Activity_of_the_testperson"] <- "Sitting"}
  if (total_rundata_set[i,"Activity_of_the_testperson"] == 5) 
    { total_rundata_set[i,"Activity_of_the_testperson"] <- "Standing"}
  if (total_rundata_set[i,"Activity_of_the_testperson"] == 6) 
    { total_rundata_set[i,"Activity_of_the_testperson"] <- "Laying"}
}
# Extract the variables containing a mean or standard deviation, first the mean and then the std

column_index_containing_mean <- grep("mean", colnames(total_rundata_set))
column_index_containing_std <- grep("std", colnames(total_rundata_set))                                     

# make one vector with all the mean and std variables in it
selection_of_columns_with_mean_or_std <- sort(c(column_index_containing_std, column_index_containing_mean))

# also include the columns with the testperson IDs and activity level to make the selection 
# from the total_rundata_set variables.

all_selected_colums <- c(selection_of_columns_with_mean_or_std, 562, 563) 

# Now that we have the set of columns containing an std or mean variable, the final resultset 
# can be generated

final_rundata_set <- total_rundata_set[,all_selected_colums]

# The final_rundata_set is the data frame that contains the mean and std related variables,
# the measurements from the train and test set, the activity levels of the testpersons in 
# descriptive text (instead of the numbers 1-6) and descriptive labels for the measurement
# variables. This fulfills requirements 1-4 of the assignment

# again cleanup temporary variables in the run_analysis script
rm(total_rundata_set)
rm(column_index_containing_std)
rm(column_index_containing_mean)
rm(selection_of_columns_with_mean_or_std)
rm(all_selected_colums)

# Now the tidy data set has to be made containing the averages for the variables per person and per activity
# First is to produce the long and narrow data set, using the melt() function. This results in 
# a long set of 813,621 rows and 4 columns, "Unique_ID_of_testperson", "Activity_of_the_testperson", Variable 
# and the values of the variables.

dataMelt <- melt(final_rundata_set, id = c("Unique_ID_of_testperson", "Activity_of_the_testperson"), measure.vars = c(colnames(final_rundata_set[1:79])))

# the vars temporary object is used to make the statement to generate the tidyDataset more compact
# it contains the variable names tBodyAcc-mean()-X to fBodyBodyGyroJerkMag-meanFreq()

vars <- colnames(final_rundata_set[,1:79])

# Now produce the tidy data set with the means of the variable for the activities per test person

tidyDataset <- dcast(dataMelt, Unique_ID_of_testperson + Activity_of_the_testperson ~vars,mean)

# To export the resulting tidt data frame

setwd("~/Datasciencecoursera/Module3week4")

write.table(tidyDataset, file = "tidyDataset.txt", row.names = FALSE)

# Again remove the temporary object to leave just the tidyDataset in memory as result.

rm(dataMelt)
rm(vars)
rm(final_rundata_set)
