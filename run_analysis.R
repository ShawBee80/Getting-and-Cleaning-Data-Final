# Download file from link
  FinalUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
  getwd()
    # "C:/Users/Matt/Desktop/Data Science/Files/datasciencecoursera/Course 3 Final"
      ## Replace all 
      ## "C:/Users/Matt/Desktop/Data Science/Files/datasciencecoursera/Course 3 Final" 
      ## with your own getwd()
  download.file(FinalUrl, destfile = "C:/Users/Matt/Desktop/Data Science/Files/datasciencecoursera/Course 3 Final/Dataset.zip")

# Unzip file
  unzip("C:/Users/Matt/Desktop/Data Science/Files/datasciencecoursera/Course 3 Final/Dataset.zip", exdir = "C:/Users/Matt/Desktop/Data Science/Files/datasciencecoursera/Course 3 Final/Data")

# Define the file path
  list.files("C:/Users/Matt/Desktop/Data Science/Files/datasciencecoursera/Course 3 Final/Data")
# [1] "UCI HAR Dataset"
  DataPath <- file.path("C:/Users/Matt/Desktop/Data Science/Files/datasciencecoursera/Course 3 Final/Data", "UCI HAR Dataset")
  Files <- list.files(DataPath, recursive = TRUE)

# View "Files"
  Files


# First, read the train tables into R
  Xtrain <- read.table(file.path(DataPath, "train", "X_train.txt"), header = FALSE)
  Ytrain <- read.table(file.path(DataPath, "train", "Y_train.txt"), header = FALSE)
  Subject_train <- read.table(file.path(DataPath, "train", "subject_train.txt"), header = FALSE)

# Next, read the test tables into R
  Xtest <- read.table(file.path(DataPath, "test", "X_test.txt"), header = FALSE)
  Ytest <- read.table(file.path(DataPath, "test", "Y_test.txt"), header = FALSE)
  Subject_test <- read.table(file.path(DataPath, "test", "subject_test.txt"), header = FALSE)

# Next, read features and activity labels
  Features <- read.table(file.path(DataPath, "features.txt"), header = FALSE)
  Activity_labels <- read.table(file.path(DataPath, "activity_labels.txt"), header = FALSE)

# Create values 
  colnames(Xtrain) = Features[, 2]
  colnames(Ytrain) = "activityId"
  colnames(Subject_train) = "subjectId"
  colnames(Xtest) = Features[, 2]
  colnames(Ytest) = "activityId"
  colnames(Subject_test) = "subjectId"
  colnames(Activity_labels) <- c("activityId", "activityType")

# The following are the 5 steps required for the 
# Coursera "Getting and Cleaning data", Week 4 Course Project

# Step 1
# Merge the training and the test sets to create one data set.
  Merge_train <- cbind(Ytrain, Subject_train, Xtrain)
  Merge_test <- cbind(Ytest, Subject_test, Xtest)
  Main_data_table <- rbind(Merge_train, Merge_test)

# Step 2
# Extract only the measurements on the mean and standard deviation for each measurement.
  Col_Names <- colnames(Main_data_table)
  Mean_and_standard <- (grepl("activityId", Col_Names) | grepl("subjectId", Col_Names) | grepl("mean..", Col_Names) | grepl("std..", Col_Names))
  Subset_all <- Main_data_table[, Mean_and_standard == TRUE]

# Step 3
# Use descriptive activity names to name the activities in the data set
  Descriptive_names <- merge(Subset_all, Activity_labels, by = 'activityId', all.x = TRUE)

# Step 4
# Appropriately labels the data set with descriptive variable names.
  ## This was already done in "Create Values" prior to "Step 1", 
  ## Now we are just denoting that the vectors labeled Main_data_table and Subset_all
  ## are the outcomes and solutions

# Step 5
# From the data set in step 4, creates a second, independent tidy data set
# with the average of each variable for each activity and each subject.
  Tidy_dataset <- aggregate(. ~subjectId + activityId, Descriptive_names, mean)
  Tidy_dataset <- Tidy_dataset[order(Tidy_dataset$subjectId, Tidy_dataset$activityId), ]
  write.table(Tidy_dataset, "C:/Users/Matt/Desktop/Data Science/Files/datasciencecoursera/Course 3 Final/Tidy_dataset.txt", row.names = FALSE) 