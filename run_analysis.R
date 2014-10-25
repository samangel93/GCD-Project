library(data.table);
library(plyr);
# read features
features <- read.table("./features.txt", header = FALSE, sep = " ", 
                       stringsAsFactors = FALSE);
# read train set
xtrainset <- read.table("./train/X_train.txt", header = FALSE);
# read test set
xtestset <- read.table("./test/X_test.txt", header = FALSE);
# 1.Merges the training and the test sets to create one data set
fullset <- merge(xtrainset, xtestset, all = TRUE);
# name the set
names(fullset) <- features[, 2];
# the names with "mean()" or "std()"
namems <- names(fullset)[names(fullset) %like% "mean\\()" | 
                           names(fullset) %like% "std\\()"];
# 2.Extracts only the measurements on the mean and standard deviation for each measurement
msset <- fullset[, namems, drop = FALSE];
# read activity labels
actrLNames <- read.table("./train/y_train.txt", header = FALSE);
acteLNames <- read.table("./test/y_test.txt", header = FALSE);
# 3.Uses descriptive activity names to name the activities in the data set
msset$activitylabels <- rbind(actrLNames, acteLNames)[, 1];
names(msset$activitylabels) = "activitylabels";
# read activity names
acLables <- read.table("./activity_labels.txt", header = FALSE, sep = " ");
# 4.Appropriately lables the data set with descriptive variable names
msset$activitylabnames <- as.charactor(acLables[
  as.numeric(msset$activitylabels[, 1]), 2]);
# read subject
trsubject <- read.table("./train/subject_train.txt", header = FALSE);
tesubject <- read.table("./test/subject_test.txt", header = FALSE);
msset$subject <- rbind(trsubject, tesubject)[, 1];
names(msset$subject) = "subject";
# 5.From the data set in step4, creates a second, independent tidy set with 
#     the average of each variable for each activity and each subject
tidyset <- ddply(msset, .(subject, activitylabels), numcolwise(mean));
# save tidyset
write.table(tidyset, file = "./TidyData.txt", append = FALSE, quote = FALSE,
            sep = " ", na = "NA", row.names = FALSE);
