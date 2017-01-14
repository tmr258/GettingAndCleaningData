# GettingAndCleaningData
Repo for the final assignment for the Getting and Cleaning Data module of the Coursera Data Science Specialisation

The repo contains an R script run_analysis.R, this readme file with a specification of the R code and a code book that descibed the variables used in run_analysis.R

1	BACKGROUND

run_analysis.R is the result of the programming assignment of Week 4 for the 
"Getting and Cleaning Data" module of the Coursera Data Science Specialisation offered
by the Johns Hopkins University

2	DATA SET ORIGIN
 
==================================================================
Human Activity Recognition Using Smartphones Dataset
Version 1.0
==================================================================
Jorge L. Reyes-Ortiz, Davide Anguita, Alessandro Ghio, Luca Oneto.
Smartlab - Non Linear Complex Systems Laboratory
DITEN - Università degli Studi di Genova.
Via Opera Pia 11A, I-16145, Genoa, Italy.
activityrecognition@smartlab.ws
www.smartlab.ws
==================================================================

The experiments have been carried out with a group of 30 volunteers within an age bracket of 19-48 years. Each person performed six activities (WALKING, WALKING_UPSTAIRS, WALKING_DOWNSTAIRS, SITTING, STANDING, LAYING) wearing a smartphone (Samsung Galaxy S II) on the waist. Using its embedded accelerometer and gyroscope, we captured 3-axial linear acceleration and 3-axial angular velocity at a constant rate of 50Hz. The experiments have been video-recorded to label the data manually. The obtained dataset has been randomly partitioned into two sets, where 70% of the volunteers was selected for generating the training data and 30% the test data. 

The sensor signals (accelerometer and gyroscope) were pre-processed by applying noise filters and then sampled in fixed-width sliding windows of 2.56 sec and 50% overlap (128 readings/window). The sensor acceleration signal, which has gravitational and body motion components, was separated using a Butterworth low-pass filter into body acceleration and gravity. The gravitational force is assumed to have only low frequency components, therefore a filter with 0.3 Hz cutoff frequency was used. From each window, a vector of features was obtained by calculating variables from the time and frequency domain. See 'features_info.txt' for more details. 

For each record it is provided:
======================================

- Triaxial acceleration from the accelerometer (total acceleration) and the estimated body acceleration.
- Triaxial Angular velocity from the gyroscope. 
- A 561-feature vector with time and frequency domain variables. 
- Its activity label. 
- An identifier of the subject who carried out the experiment.

The dataset includes the following files:
=========================================

- 'README.txt'

- 'features_info.txt': Shows information about the variables used on the feature vector.

- 'features.txt': List of all features.

- 'activity_labels.txt': Links the class labels with their activity name.

- 'train/X_train.txt': Training set.

- 'train/y_train.txt': Training labels.

- 'test/X_test.txt': Test set.

- 'test/y_test.txt': Test labels.

The following files are available for the train and test data. Their descriptions are equivalent. 

- 'train/subject_train.txt': Each row identifies the subject who performed the activity for each window sample. Its range is from 1 to 30. 

- 'train/Inertial Signals/total_acc_x_train.txt': The acceleration signal from the smartphone accelerometer X axis in standard gravity units 'g'. Every row shows a 128 element vector. The same description applies for the 'total_acc_x_train.txt' and 'total_acc_z_train.txt' files for the Y and Z axis. 

- 'train/Inertial Signals/body_acc_x_train.txt': The body acceleration signal obtained by subtracting the gravity from the total acceleration. 

- 'train/Inertial Signals/body_gyro_x_train.txt': The angular velocity vector measured by the gyroscope for each window sample. The units are radians/second. 

Notes: 
======
- Features are normalized and bounded within [-1,1].
- Each feature vector is a row on the text file.

For more information about this dataset contact: activityrecognition@smartlab.ws

3	FUNCTIONAL SPECIFICATION OR RUN_ANALYSIS.R

The functionality of run_analysis is:

1.	It merges the training and the test sets to create one data set.
2.	It extracts only the measurements on the mean and standard deviation for each measurement. 
3.	It uses descriptive activity names to name the activities in the data set
4.	It appropriately labels the data set with descriptive variable names. 
5.	From the data set in step 4, it creates a second, independent tidy data set with the 
    average of each variable for each activity and each subject.

Part 1: merging the training and test set to one set

Order of processing

- Setting the working directory for the metadata files by using setwd
- Then reading the features file to later use in the names for the columns of the total_rundata_set
- Setting the working directory for the training set by using setwd
- Read the training data from the files in the train directory
- Setting the working directory for the test set
- Read the training data from the files in the test directory
- The training data and test data are bound together in one data frame for the training data and one data frame for the test data.
- To complete all the merging the total_rundata_set is created bij adding all rows together

Result:  all the Samsung run data are now in one data frame called total_rundata_set.

Part 2: assigning variable labels and replace the activity ID's with the more descriptive names that are given in
activity_names.txt 

Order of processing

- Create variable labels. The variable labels have been read from the features.txt file and are contained in the features object. In a for loop all the features are added to the columns as names. In an additional action the unique ID's for the testpersons (ranging from 1-30), and the activities are added as column name, in columns 562 ans 563
- As intermediate step the temporary objects are removed to free up memory for the next steps. These are X_test_df, X_train_df, y_test_df, y_train_df, subject_test_df, subject_train_df, train_df, test_df, features.
- The next for loop in the lines 83-95 is done to replace the values in the column for the Activity for the testperson with understandable wording. This data is contained in activity_names.txt but the choice for efficiency reasons was to implement this with a simple for loop and not by reading the file and programming code for that
- Extract the variables containing a mean or standard deviation, first the mean and then the std
- Make one vector with all the mean and std variables in it
- Also include the columns with the testperson IDs and activity level to make the selection from the total_rundata_set variables.
- Now that we have the set of columns containing an std or mean variable, the final resultset can be generated, in variable final_rundata_set. The final_rundata_set is the data frame that contains the mean and std related variables, the measurements from the train and test set, the activity levels of the testpersons in descriptive text (instead of the numbers 1-6) and descriptive labels for the measurement variables. This fulfills requirements 1-4 of the assignment
- To conclude this part again cleanup temporary variables in the run_analysis script. The variables total_rundata_set, column_index_containing_std, column_index_containing_mean, selection_of_columns_with_mean_or_std, all_selected_colums are removed.

Part 3: Produce the tidy data set.

Tidy data fullfills:

1. Each variable forms a column.
2. Each observation forms a row.
3. Each type of observational unit forms a table.
4. if you have multiple tables , they should contain a column in the table that enables them to be linked

Order of processing

- Now the tidy data set has to be made containing the averages for the variables per person and per activity. First is to produce the long and narrow data set, using the melt() function. This results in dataMelt, a long set of 813,621 rows and 4 columns, "Unique_ID_of_testperson", "Activity_of_the_testperson", Variable and the values of the variables.
- Create the vars temporary object that is used to make the statement to generate the tidyDataset more compact. It contains the variable names tBodyAcc-mean()-X to fBodyBodyGyroJerkMag-meanFreq()
- Finally the tidy data set is created with the means of the variable for the activities per test person

tidyDataset <- dcast(dataMelt, Unique_ID_of_testperson + Activity_of_the_testperson ~vars,mean)

This produces a data set which fullfils the criteria for tidy data, each measurement a row, each variable a column. It is
Narrow and long.

- Final step is to export the data frame by using write.table(tidyDataset, file = "tidyDataset.txt", row.names = FALSE)
- Last part of the script is to again remove the temporary objects to leave just the tidyDataset in memory as result. The variables dataMelt, vars, final_rundata_set are removed.

END OF DOCUMENT
