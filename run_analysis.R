# run analysis script
# downloading the file and unziping the file
if(!file.exists("./data")){dir.create("./data")}
fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(fileUrl,destfile="./data/Dataset.zip")
unzip(zipfile="./data/Dataset.zip",exdir="./data")
    
# step 01 merging files 

# read files

# reading the testing and trainingstable
x_train <- read.table("./data/UCI HAR Dataset/train/X_train.txt")
y_train <- read.table("./data/UCI HAR Dataset/train/y_train.txt")
subject_train <- read.table("./data/UCI HAR Dataset/train/subject_train.txt")

x_test <- read.table("./data/UCI HAR Dataset/test/X_test.txt")
y_test <- read.table("./data/UCI HAR Dataset/test/y_test.txt")
subject_test <- read.table("./data/UCI HAR Dataset/test/subject_test.txt")

# reading vectors and labels 
features <- read.table('./data/UCI HAR Dataset/features.txt')
activityLabels = read.table('./data/UCI HAR Dataset/activity_labels.txt')

# assigning colnames for to be merged dataset
colnames(x_train) <- features[,2]
colnames(y_train) <-"activityId"
colnames(subject_train) <- "subjectId"

colnames(x_test) <- features[,2] 
colnames(y_test) <- "activityId"
colnames(subject_test) <- "subjectId"

colnames(activityLabels) <- c('activityId','activityType')

# merging all the data 
mrg_train <- cbind(y_train, subject_train, x_train)
mrg_test <- cbind(y_test, subject_test, x_test)
setAllInOne <- rbind(mrg_train, mrg_test)

# step 02 extracting measurements of mean and std deviation 
# creating col names
colNames <- colnames(setAllInOne)

# creating vector for defining id, mean and sd
mean_and_std <- (grepl("activityId" , colNames) | 
                     grepl("subjectId" , colNames) | 
                     grepl("mean.." , colNames) | 
                     grepl("std.." , colNames) 
)
# creating subset 
setForMeanAndStd <- setAllInOne[ , mean_and_std == TRUE]

# srep 03 using descriptive activity names to name the activities 
setWithActivityNames <- merge(setForMeanAndStd, activityLabels,
                              by='activityId',
                              all.x=TRUE)
# srep 4 completed in step one (creatin indivvidual labels)
# step 05 creating tidy data set 
secTidySet <- aggregate(. ~subjectId + activityId, setWithActivityNames, mean)
secTidySet <- secTidySet[order(secTidySet$subjectId, secTidySet$activityId),]
# writing second tidy data set 
write.table(secTidySet, "secTidySet.txt", row.name=FALSE
            