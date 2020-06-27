library(data.table)

# Activities and Features
activities <- fread("UCI HAR Dataset/activity_labels.txt", col.names = c("ActLabel", "Activity"))
features <- fread("UCI HAR Dataset/features.txt", col.names = c("index", "Feat"))

#Train Data
Xtrain <- fread("UCI HAR Dataset/train/X_train.txt", col.names = features$Feat )
WantFeats <-grep("-(mean|std)\\()",names(Xtrain))
Xtrain <- Xtrain[,WantFeats, with = F]

Ytrain <- fread("UCI HAR Dataset/train/y_train.txt", col.names = "ActLabel")
Subtrain <- fread("UCI HAR Dataset/train/subject_train.txt", col.names = "Sub")

train <- cbind(Subtrain,Ytrain,Xtrain)

#Test Data
Xtest <- fread("UCI HAR Dataset/test/X_test.txt", col.names = features$Feat)#[, featuresWanted, with = FALSE]
WantFeats <-grep("-(mean|std)\\()",names(Xtest))
Xtest <- Xtest[,WantFeats, with = F]

Ytest <- fread("UCI HAR Dataset/test/y_test.txt", col.names = "ActLabel")
Subtest <- fread("UCI HAR Dataset/test/subject_test.txt", col.names = "Sub")

test <- cbind(Subtest,Ytest,Xtest)

all.data <- rbind(train,test)
View(all.data)


mlt.data <- melt(all.data, id = c("Sub", "ActLabel"))
combined <- dcast(mlt.data, Sub + ActLabel ~ variable, mean)

fwrite(x = combined, file = "tidy.csv", quote = FALSE)

