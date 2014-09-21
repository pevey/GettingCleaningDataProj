
## download and unzip the data
fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(fileUrl, destfile="datafile.zip")
unzip("datafile.zip")


## read the data
labels = read.csv("UCI HAR Dataset/activity_labels.txt", sep="", header=FALSE)
training = read.csv("UCI HAR Dataset/train/X_train.txt", sep="", header=FALSE)
training[,562] = read.csv("UCI HAR Dataset/train/Y_train.txt", sep="", header=FALSE)
training[,563] = read.csv("UCI HAR Dataset/train/subject_train.txt", sep="", header=FALSE)
testing = read.csv("UCI HAR Dataset/test/X_test.txt", sep="", header=FALSE)
testing[,562] = read.csv("UCI HAR Dataset/test/Y_test.txt", sep="", header=FALSE)
testing[,563] = read.csv("UCI HAR Dataset/test/subject_test.txt", sep="", header=FALSE)
features = read.csv("UCI HAR Dataset/features.txt", sep="", header=FALSE)
features[,2] = gsub('-mean', 'Mean', features[,2])
features[,2] = gsub('-std', 'Std', features[,2])
features[,2] = gsub('[-()]', '', features[,2])

## merge and subset the data
combined <- rbind(training, testing)
combined <- combined[, c(grep(".*Mean.*|.*Std.*", features[,2]), 562, 563)]
features <- features[grep(".*Mean.*|.*Std.*", features[,2]),]

## give the columns useful labels
colnames(combined) <- c(features$V2, "Activity", "Subject")
colnames(combined) <- tolower(colnames(combined))
i <- 1
for (label in labels$V2) {
    combined$activity <- gsub(i, label, combined$activity)
    i <- i + 1
}
combined$activity <- as.factor(combined$activity)
combined$subject <- as.factor(combined$subject)
tidy <- aggregate(combined, by=list(activity = combined$activity, subject=combined$subject), mean)
write.table(tidy, "tidy.txt", sep="\t")