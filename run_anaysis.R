library(dplyr)
#############################################################################
#  Reading all files

x_train <- read.table("train/X_train.txt")
y_train <- read.table("train/y_train.txt")
subject_train <- read.table("train/subject_train.txt")

x_test <- read.table("test/X_test.txt")
y_test <- read.table("test/y_test.txt")
subject_test <- read.table("test/subject_test.txt")

features <- read.table("features.txt")
activities <- read.table("activity_labels.txt")
 
##  Merges the train and the test
###############################################################################
DATA <- rbind(x_train, x_test)

## Extracts only the measurments on the mean and standard deviation for each measurement
# get only columns with mean() or std() in their names
##   And
## Uses descriptive activity names to name the activites in the data set
##################################################################################
## choosing features which contain mean and standard deviation
mean_std_features <- grep("-(mean|std)\\(\\)", features$V2)
# subset the desired columns
DATA <- select(DATA,mean_std_features)
# correct the column names
names(DATA) <- features[mean_std_features, 2]

ydata <- rbind(y_train,y_test) 
ydata <- as.data.frame(activities[ydata$V1,2])
names(ydata) <- "Activity"            


## Appropriately labels the data set with descriptive variable names
###################################################################################
subject <- as.data.frame(rbind(subject_train,subject_test))
names(subject) <- "Subject"

 
##  From the data set in step 4, creates the second, independent tiday data set 
##  with the average of each vriable for each activity and each subject
######################################################################################
DATA <- cbind(subject,ydata,DATA) %>%
        group_by(Subject,Activity)%>%
        summarise_each(funs(mean))

##  saving Tidy data set as a txt file

write.table(DATA, "tidy.txt", row.name=FALSE)
