#
#     This script assumes that the diectory "UCI HAR Dataset" is in the working direction. 
#
#     The script will read all feature, subject, and label data for both train and test sets,
#     re-label activities with their names, re-label measurement column names with descriptive names,
#     keep only measurement data only those measurements with the word mean and std 
#     and finally produce a tidy data set, output as "tidy_data_set.txt"
#     Script will also produce a file "Codebook_pre.txt", with names of selected measurements, 
#     to aid in construction of codebook.

# read train and test features data and merge from
Xtraindata <-fread("./UCI HAR Dataset/train/X_train.txt")
Xtestdata <- fread("./UCI HAR Dataset/test/X_test.txt")
X_merged_data <-rbindlist(list(Xtraindata,Xtestdata)) 
rm(Xtraindata,Xtestdata)

# read train and test labels data and merge
Ytraindata <- fread("./UCI HAR Dataset/train/Y_train.txt")
Ytestdata <- fread("./UCI HAR Dataset/test/Y_test.txt")
Y_merged_data <- rbindlist(list(Ytraindata,Ytestdata))
names(Y_merged_data) <- c("Activity")
rm(Ytraindata,Ytestdata)

# read train and test subject data and merge
subject_train_data <- fread("./UCI HAR Dataset/train/subject_train.txt")
subject_test_data <- fread("./UCI HAR Dataset/test/subject_test.txt")
subject_merged_data <- rbindlist(list(subject_train_data,subject_test_data))
names(subject_merged_data) <- c("Subject")
rm(subject_train_data,subject_test_data)

# Rename feature columns
features_names = as.character(read.table("./UCI HAR Dataset/features.txt")$V2)
names(X_merged_data) <- features_names

# Relabel activities
activities_labels = fread("./UCI HAR Dataset/activity_labels.txt")$V2
Y_merged_data[, Activity:=activities_labels[Activity]]

# select features
selected_feats =features_names[grepl("mean",features_names) | grepl("std",features_names)]
X_selected_data=X_merged_data[,selected_feats,with=F]

# merge all
final_merged_data <- cbind(subject_merged_data,Y_merged_data,X_selected_data)

# tidy data, grouped by Subject and Activity, then computed averages of all columns, 
# and finally sorted by Subject and the Activity (in alphabetical order)
tidy_data <- final_merged_data %>% 
      group_by(Subject,Activity) %>% 
      summarize_each(funs(mean)) %>% 
      arrange(Subject,Activity)

# write tidy set
write.table(tidy_data,file="tidy_data_set.txt",row.name=FALSE)

# write variables for Codebook preparation
codefile <- file("Codebook_pre.txt")
writeLines(selected_feats,codefile)
close(codefile)

