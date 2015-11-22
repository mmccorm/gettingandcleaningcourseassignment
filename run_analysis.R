# run_analysis.R
# last modified 11-22-15
# Course project assignment for Coursera "Getting and Cleaning Data" course.
# This course is part of the JHU Data Science Specialization series.

### INSTRUCTIONS ###
# You should create one R script called run_analysis.R that does the following. 
# 1. Merges the training and the test sets to create one data set.
# 2. Extracts only the measurements on the mean and standard deviation for each measurement. 
# 3. Uses descriptive activity names to name the activities in the data set
# 4. Appropriately labels the data set with descriptive variable names. 
# 5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

# clean the workspace
rm(list = ls())

# 1. Merges the training and the test sets to create one data set.

# set wd - ****** comment out this command later for evaluation ******.
# setwd("/home/mark/UCI_HAR_Dataset/")
# load the data. first load test data
subject_test<-as.data.frame(read.csv("test/subject_test.txt",header=FALSE))
y_test<-as.data.frame(read.csv("test/y_test.txt",header=FALSE))
x_test<-as.data.frame(read.table("test/X_test.txt", sep="",header=FALSE))
# then load training data
subject_train<-as.data.frame(read.csv("train/subject_train.txt",header=FALSE))
y_train<-as.data.frame(read.csv("train/y_train.txt",header=FALSE))
x_train<-as.data.frame(read.table("train/X_train.txt", sep="",header=FALSE))

# these instructions are a bit open ended.  I will assume step 1 only refers to merging the 561-feature rows
# from the published test set and from the published training set, and similarly the subject id and activity files from 
# the test and training sets, and does not refer to merging the subject id and activity id into the feature data frame, yet.
# This is my best guess as to what was intended and I don't see any further clarification on the forums.
# Six of one, half a dozen of the other, since we will do it all eventually.
# Note that I have arbitrarily chosen the order (training, test), since they were mentioned in this order in the instructions.
x_all<-rbind(x_train,x_test)
y_all<-rbind(y_train,y_test)
subject_all<-rbind(subject_train,subject_test)
# to be clear, by my reading of the instructions, x_all, y_all, and subject_all are the results for step 1.
# Explicit note for graders:I realize that we might want to preserve the information about which rows came from the training set and
# which from the test set!
# In my implementation here, I add that data to the mashed together data frame later, in step 5,
# But, note that the code I use in step 5 could be used to add a column delineating the test or training data rows
# in any of the earlier steps, including this one, but I thought it cleaner to postpone it.

# 2. Extracts only the measurements on the mean and standard deviation on each measurement.

# read in the features description file
features<-as.data.frame(read.table("features.txt", sep="",header=FALSE))
# identify which features contain the strings "mean" or "std".  These are the ones we want.  Make a subset of features with just these.
meansandstds<-features[grep("mean|std",features[,2]),]
# make a vector of the indices of the means and stds- we are kind of transposing next, in that we'll now select only the columns from
# our merged data that correspond to the rows in features subject_and_activity_labeled_means_and_stdssubject_and_activity_labeled_means_and_stdsthat were "mean" or "std" containing rows.
pickthese<-as.vector(meansandstds[,1])
# now make a subset of the merged training and test data that contains only the means and stds, using the pickthese vector we just created.
meanandstdfeatures<-x_all[,pickthese]
# to be clear, by my reading of the instructions, meanandstdfeatures is the result for step 2.

# 3. Uses descriptive activity names to name the activities in the data set

# The way that I've interpreted the instructions, we have two things to do here:
# assign the activity code to the row, and assign the activity name to the activity code. 
# We can do these in either order; I will translate the y_all numbers into activity names first,
# and then attach these activity names to the data as a new column in the data frame.
# The following is based on the decision that the names in activity_labels.txt are sufficiently descriptive
# and do not need to be lengthened or clarified.
# read in the activity labels
activity_labels<-as.data.frame(read.table("activity_labels.txt", sep="",header=FALSE))
# make a vector that is just an activity label for each row of the data set, corresponding to its numerical code.
y_levels <- factor(y_all[,1] ,levels = as.vector(activity_labels[,1]),labels = as.vector(activity_labels[,2]))

# these activity descriptions will end up in our tidy final data, and tidying them does not make them unwieldy or super long
# so let's do it now.
# remove underscores and make all lowercase
y_levels<-tolower(gsub("_","",y_levels))

# append this tidied y_levels as a new first column in the data frame, containing the means and stds that we have selected
activity_labeled_means_and_stds<-cbind(y_levels,meanandstdfeatures)
# to be clear, by my reading of the instructions, activity_labeled_means_and_stds is the result for step 3.

# 4. Appropriately labels the data set vector_of_most_col_names with descriptive variable names. 

# we already have a set of descriptive variable names in the meansandstds data frame, from step 2.
# they are only missing the newly added first cvector_of_most_col_namesolumn, describing the activity.
# this version of step 4 assumes that the variable names already given are sufficiently descriptive.
# For me, shorter and more parseable names are better than extremely long ones in data sets with this many very
# conceptually similar variables.
# 
# Because some (most?) people will interpret these instructions to mean that we should turn the terse variable names into very long
# verbose names during this step, I've added an alternative second version of step 4 that demonstrates this 
# alternative method as well, by using gsub to "tidy" and extend the variable names, as will be done in step 5.

# get most of the col names (except "activity") from meansandstds dataset_subject_and_activity_labeled_means_and_stdsdataset_subject_and_activity_labeled_means_and_stdsfrom step 2.
vector_of_most_col_names<-as.vector(meansandstds[,2])
# this (vector_of_most_col_names) is the terse set of variable names.

# NOW TO MAKE LONGER NAMES FOR THE ALTERNATIVE STEP 4, AND FOR USE IN STEP 5
# there are some "Freq" abbrevations I want to change to "frequency"
# have to do that before changing leading f's to frequency as well to make it easiest
longer_most_names<-gsub("Freq","frequency",vector_of_most_col_names)
# replace t or f at the beginning with time or frequency respectively, to more clearly delinate the time domain
# and frequency domain (FFT transfcourse_project_for_gettingcleaning.txtormed) data.
longer_most_names<-gsub("^t","time",longer_most_names)
longer_most_names<-gsub("^f","frequency",longer_most_names)
# get rid of parentheses in names
longer_most_names<-gsub("\\(","",longer_most_names)
longer_most_names<-gsub("\\)","",longer_most_names)
# replace the abbreviations "Gyro", "Acc", "Mag", and "std" with gyroscope, accelerometer, magnitude, and standarddeviation, respectively.
longer_most_names<-gsub("Gyro","gyroscope",longer_most_names)
longer_most_names<-gsub("Acc","accelerometer",longer_most_names)
longer_most_names<-gsub("Mag","magnitude",longer_most_names)
longer_most_names<-gsub("std","standarddeviation",longer_most_names)
# get rid of hyphens
longer_most_names<-gsub("-","",longer_most_names)
# change names to all lower case as explicitly mentioned in week 4 lectures
longer_most_names<-tolower(longer_most_names)

# Now to label! add "activity" to the beginning
col_names<-c("activity",vector_of_most_col_names)
# save our data frame under a new name before adding column names, so we still have the intermediate version if needed later
variable_and_activity_labeled_means_and_stds<-activity_labeled_means_and_stds
# add column names to it now
colnames(variable_and_activity_labeled_means_and_stds)<-col_names

# ALTERNATIVE VERSION WITH THE LONGER MORE DESCRIPTIVE NAMES THAT WILL BE USED IN STEP 5:
longer_col_names<-c("activity",longer_most_names)
# save our data frame under a vector_of_most_col_namesvector_of_most_col_namesvector_of_most_col_namesvector_of_most_col_namesnew name before adding column names, so we still have the intermediate version if needed later
long_variable_and_activity_labeled_means_and_stds<-activity_labeled_means_and_stds
# add column names to it now
colnames(long_variable_and_activity_labeled_means_and_stds)<-longer_col_names
# to be clear, by my reading of the instructions, the last version of variable_and_activity_labeled_means_and_stds, with the colnames added,
# is the result for step 4.  If you want a version with the vriable names already prettied up, that is in the latest
# version of long_variable_and_activity_labeled_means_and_stds.
#
# Explicit note to graders: if what you prefer as an optimal answer for step 4 is the data from variable_and_activity_labeled_means_and_stds
# in a tidier form, you will find it below in activity_data_melt in step 5.

# 5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

# As I mentioned in step 1, these instructions are extremely open ended.  Some people may have bolted the subject ID's onto the 
# feature data back in step 1, but since it was not specifically mentioned or necessary, I did not, which means I need to add it now in order
# to complete step 5.
# To do this I will go back to our data before we added column names, so I can first add a column for the subject ID and then name the columns.
# the precedent file that I want is activity_labeled_means_and_stds, from step 3.
# add new column for subject number to activity_labeled_means_and_stds
subject_and_activity_labeled_means_and_stds<-cbind(subject_all,activity_labeled_means_and_stds)
# Maaaaybe we might want to know which data originally came from the test set and which from the training set.
# Can't hurt, since we are going full TIDY all up in here.
# Remember, we rbound them in the order (training,test) in step 1.
# make a vector that says "training" as many times as there were rows in the training set
trainvect<-rep("training",nrow(x_train))
# make a vector that says "test" as many times as there were rows in the test set
testvect<-rep("test",nrow(x_test))
# stick them together in the order (training, test)
train_or_test<-c(trainvect,testvect)
# add this column at the beginning of subject_and_activity_labeled_means_and_stds
dataset_subject_and_activity_labeled_means_and_stds<-cbind(train_or_test,subject_and_activity_labeled_means_and_stds)
# we've added two new columns, subject and dataset, to the data frame, so now we need to add them to the column names
# that we made in step 4.
final_long_col_names<-c("dataset","subject",longer_col_names)
# now let's add these column names to this data frame.
colnames(dataset_subject_and_activity_labeled_means_and_stds)<-final_long_col_names

head(dataset_subject_and_activity_labeled_means_and_stds,2)

# We're all done except for the tidying, I think.
# There are some options here, if I am reading Hadley Wickham correctly.
# I am going with a "long" version, where I will take each of the mean and std features that we extracted from
# test/X_test.txt and from train/X_train.txt, and assign them to their own rows.
# There is at least one other pretty tidy way to represent these data, but I think this one does the trick.

# load reshape2
library(reshape2)
# let's melt the data.  Also bring the name back to a manageable size.
# here we can take advantage of the fact that longer_most_names from step 4 is already just the measure.vars we need for the melt
activity_data_melt <- melt(dataset_subject_and_activity_labeled_means_and_stds,id=c("subject","activity","dataset"),measure.vars=longer_most_names)
# I think this, i.e. activity_data_melt, is an acceptable tidy form of these data, although not the only one.

# Let's now summarize our total tidy data, using ddply.
# load plyr
library(plyr)
# summarize the average values of each variable for each subject/activity combination, by subject, activity, and variable in that order.
summary_with_averages<-ddply(activity_data_melt,.(subject,activity,variable),summarize,average=mean(value))
# to be clear, by my reading of the instructions, summary_with_averages is the result for step 5.
# we could cast it into other formats that might seem more readable to some users (or not), but this is specifically a tidy data form
# of the described summary, which is what was asked for.

# check it
# View(summary_with_averages)
# looks OK

# doublecheck the str of summary_with_averages to be sure all factors are factors, ints are ints, nums are nums, etc.
# str(summary_with_averages)
# looks OK

# export deliverable result
# first a specific directory version for my testing
# write.table(summary_with_averages,file ="/home/mark/course_project_for_gettingcleaning.txt", row.names=FALSE)
# now a generic version for evaluation
write.table(summary_with_averages,file ="course_project_for_gettingcleaning.txt", row.names=FALSE)
# read and view to check again
# doublecheck<-read.table("/home/mark/course_project_for_gettingcleaning.txt",header=TRUE)
# View(doublecheck)
# looks OK
