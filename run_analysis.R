# IMPORTANT: This script, 'run_analysis.R', works under one requirement: 
#                 A folder with name 'UCI HAR Dataset' , 
#                 is present in the working directory 
#                 that contains the following data files: 
#                   - UCI HAR Dataset/activity_labels.txt 
#                   - UCI HAR Dataset/features.txt 
#                   - UCI HAR Dataset/test/subject_test.txt 
#                   - UCI HAR Dataset/test/X_test.txt 
#                   - UCI HAR Dataset/test/y_test.txt 
#                   - UCI HAR Dataset/train/subject_train.txt 
#                   - UCI HAR Dataset/train/X_train.txt 
#                   - UCI HAR Dataset/train/y_train.txt 
#                 from 'Human Activity Recognition Using 
#                       Smartphones Dataset Version 1.0' 
#                 which can be downloaded from the following url: 
#                 "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip" 




# DESCRIPTION: The script 'run_analysis.R' follows strictly the instruction 
#              given by assignment, in a simple straightforward way. 
#                 0. Loads the data in R. 
#              Then 5 main steps are executed in order. 
#                 1. Merges the training and the test sets 
#                    to create one data set. 
#                 2. Extracts only the measurements on the mean 
#                    and standard deviation for each measurement. 
#                 3. Uses descriptive activity names 
#                    to name the activities in the data set. 
#                 4. Appropriately labels the data set 
#                    with descriptive variable names. 
#                 5. From the data set in step 4, 
#                    creates a second, independent tidy data set 
#                    with the average of each variable 
#                    for each activity and each subject. 



# RESULT:   The result is to create the 'tidy_data_summary' data table 
#           with the average values for the target features, 
#           which is saved as 'tidy_data_summary.txt' in the working directory. 




library(dplyr)


# Step 1
# Merge the training and test sets to create one data set 
 
x_train <- read.table("train/X_train.txt")
y_train <- read.table("train/y_train.txt")
subject_train <- read.table("train/subject_train.txt")

x_test <- read.table("test/X_test.txt") 
y_test <- read.table("test/y_test.txt") 
subject_test <- read.table("test/subject_test.txt") 

# create 'x' data set
x_data <- rbind(x_train, x_test)

# create 'y' data set 
y_data <- rbind(y_train, y_test) 

# create 'subject' data set 
subject_data <- rbind(subject_train, subject_test) 

# Step 2 
# Extract only the measurements on the mean and standard deviation for each measurement 

features <- read.table("features.txt")

# get only columns with mean() or std() in their names 
mean_and_std_features <- grep("-(mean|std)\\(\\)", features[, 2]) 


# subset the desired columns 
x_data <- x_data[, mean_and_std_features] 
 

# correct the column names 
names(x_data) <- features[mean_and_std_features, 2] 


#Step 3 
# Use descriptive activity names to name the activities in the data set 

activities <- read.table("activity_labels.txt") 


# update values with correct activity names 
y_data[, 1] <- activities[y_data[, 1], 2] 
 

# correct column name 
names(y_data) <- "activity" 


# Step 4 
# Appropriately label the data set with descriptive variable names 

# correct column name 
names(subject_data) <- "subject" 


# bind all the data in a single data set 
all_data <- cbind(x_data, y_data, subject_data) 


# Step 5 
# Create a second, independent tidy data set with the average of each variable 
# for each activity and each subject 

# 66 <- 68 columns but last two (activity & subject) 
tidy_data_set <- all_data %>%
              group_by(subject, activity) %>%
              summarise_all(funs(mean)) %>%
              ungroup()
              

write.table(tidy_data_set, "tidy_data_set.txt", row.name=FALSE)













