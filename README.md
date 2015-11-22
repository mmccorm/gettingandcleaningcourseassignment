# Getting and Cleaning Data Course Project

## run_analysis.R

This R script

1. Merges the training and the test sets to create one data set.
2. Extracts only the measurements on the mean and standard deviation for each measurement. 
3. Uses descriptive activity names to name the activities in the data set
4. Appropriately labels the data set with descriptive activity names. 
5. Creates a second, independent tidy data set with the average of each variable for each activity and each subject. 

This implementation actually performs these steps in the listed order, so that there is a uniquely named data frame at each step which shows the correct incremental progress. Incremental data frames are not written as output files.

## Running the run_analysis.R script

To run, source `run_analysis.R`.

This script will then output a text file using write.table with row.names = FALSE, called course_project_for_gettingcleaning.txt .
```

## Process

1. Read in and merge the training and test datasets, training and test subject lists, and training and test activity lists, in the order (training, test).  The merged dataset is stored in the x_all data frame.
2. Read in features.txt, grep to identify mean and standard deviation features, and select only these features from the dataset.  The selected features subset is stored in the meanandstdfeatures data frame.
3. Read in activity_labels.txt, convert the numerical activity labels vector (y_all) to factors describing the correct acitivity, and then clean up the activity names by removing underscores and converting to lower case.  The activity-labeled data frame containing the selected features is stored in the activity_labeled_means_and_stds data frame.
4. Using the selection vector from step 2 used to select the features that contained means and standard deviations, extract the names of all of these features, and convert them to better variable names by removing parentheses, converting to all lower case, and lengthening multiple abbreviations ised in the original names.  Append our new column name "activity" to the begining of this list. Add these labels to the columns as column names.  The extended and de-abbreviated column labeled data is stored in the long_variable_and_activity_labeled_means_and_stds data frame, and the original feature labels are also applied to an intermediate result that is not used further in this exercise, the variable_and_activity_labeled_means_and_stds data frame.
5. Create a vector of which observations are from the training set and which from the test set.  Append this column, and a column labeling which subject was measured, to the extended variable named data set from step 4.  Reshape this into a long tidy format, which is stored in the activity_data_melt data frame.  Next, summarize this data for the average of each feature type for each (subject and activity) combination.  The resulting summarized tidy data is stored in the summary_with_averages data frame, and is output to the file "course_project_for_gettingcleaning.txt" using write.table with row.names=FALSE.  To view this output in R, read.table with headers=TRUE and then View.

## Cleaned Data

The summarized tidy data set is in this repository at: 'course_project_for_gettingcleaning.txt'.  The code book describing this file is at 'code_book.txt'

# gettingandcleaningcourseassignment
