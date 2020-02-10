# Coursera_Getting_and_Cleaning_Data_Week_4_Assignment

# Criteria... 
# 1 The submitted data set is tidy.
# 2 The Github repo contains the required scripts.
# 3 GitHub contains a code book that modifies and updates the available codebooks with the data to indicate all the variables and summaries calculated, along with units, and any other relevant information.
# 4 The README that explains the analysis files is clear and understandable.
# 5 The work submitted for this project is the work of the student who submitted it.

# Here are the data for the project:
  
# https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip

# You should create one R script called run_analysis.R that does the following.

# 1 Merges the training and the test sets to create one data set.
# 2 Extracts only the measurements on the mean and standard deviation for each measurement.
# 3 Uses descriptive activity names to name the activities in the data set
# 4 Appropriately labels the data set with descriptive variable names.
# 5 From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

# load necessary packages
library(dplyr)

# download the file
filename <- "GACD_W4_File"
fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(fileUrl, filename, method = "curl")
unzip(filename)

# load data into data frames
activity_labels <- read.table("UCI HAR Dataset/activity_labels.txt", col.names = c("code", "activity"))
features <- read.table("UCI HAR Dataset/features.txt", col.names = c("n","functions"))
subject_test <- read.table("UCI HAR Dataset/test/subject_test.txt", col.names = "subject")
x_test <- read.table("UCI HAR Dataset/test/X_test.txt", col.names = features$functions)
y_test <- read.table("UCI HAR Dataset/test/y_test.txt", col.names = "code")
subject_train <- read.table("UCI HAR Dataset/train/subject_train.txt", col.names = "subject")
x_train <- read.table("UCI HAR Dataset/train/X_train.txt", col.names = features$functions)
y_train <- read.table("UCI HAR Dataset/train/y_train.txt", col.names = "code")

# 1 Merges the training and the test sets to create one data set.
x_merged <- rbind(x_train, x_test)
y_merged <- rbind(y_train, y_test)
subject_merged <- rbind(subject_train, subject_test)
final_merged <- cbind(subject_merged, y_merged, x_merged)

# 2 Extracts only the measurements on the mean and standard deviation for each measurement.
mean_and_std <- final_merged %>% select(subject, code, contains("mean"), contains("std"))

# 3 Uses descriptive activity names to name the activities in the data set
mean_and_std$code <- activity_labels[mean_and_std$code, 2]

# 4 Appropriately labels the data set with descriptive variable names.
names(mean_and_std)[2] = "activity"
names(mean_and_std)<-gsub("Acc", "Accelerometer", names(mean_and_std))
names(mean_and_std)<-gsub("Gyro", "Gyroscope", names(mean_and_std))
names(mean_and_std)<-gsub("BodyBody", "Body", names(mean_and_std))
names(mean_and_std)<-gsub("Mag", "Magnitude", names(mean_and_std))
names(mean_and_std)<-gsub("^t", "Time", names(mean_and_std))
names(mean_and_std)<-gsub("^f", "Frequency", names(mean_and_std))
names(mean_and_std)<-gsub("tBody", "TimeBody", names(mean_and_std))
names(mean_and_std)<-gsub("-mean()", "Mean", names(mean_and_std), ignore.case = TRUE)
names(mean_and_std)<-gsub("-std()", "STD", names(mean_and_std), ignore.case = TRUE)
names(mean_and_std)<-gsub("-freq()", "Frequency", names(mean_and_std), ignore.case = TRUE)
names(mean_and_std)<-gsub("angle", "Angle", names(mean_and_std))
names(mean_and_std)<-gsub("gravity", "Gravity", names(mean_and_std))

# 5 From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.
Data_5 <- mean_and_std %>%
  group_by(subject, activity) %>%
  summarise_all(funs(mean))
write.table(Data_5, "Data_5.txt", row.name=FALSE)
