library(data.table)

# Activities and Features
activities <- fread("UCI HAR Dataset/activity_labels.txt", col.names = c("ActLabel", "Activity"))
features <- fread("UCI HAR Dataset/features.txt", col.names = c("index", "Feat"))

#Train Data
Xtrain <- fread("UCI HAR Dataset/train/X_train.txt", col.names = features$Feat )
WantFeats <-grep("-(mean|std)\\()",names(Xtrain))
Xtrain <- Xtrain[,WantFeats, with = F]

Ytrain <- fread("UCI HAR Dataset/train/y_train.txt", col.names = "Activity")
Ytrain <- factor(Ytrain[[1]]       
       , levels = activities[["ActLabel"]]
       , labels = activities[["Activity"]])


Subtrain <- fread("UCI HAR Dataset/train/subject_train.txt", col.names = "Subject")

train <- cbind(Subtrain,"Activity" =Ytrain,Xtrain)

#Test Data
Xtest <- fread("UCI HAR Dataset/test/X_test.txt", col.names = features$Feat)#[, featuresWanted, with = FALSE]
WantFeats <-grep("-(mean|std)\\()",names(Xtest))
Xtest <- Xtest[,WantFeats, with = F]

Ytest <- fread("UCI HAR Dataset/test/y_test.txt", col.names = "ActLabel")
Ytest <- factor(Ytest[[1]]       
                 , levels = activities[["ActLabel"]]
                 , labels = activities[["Activity"]])

Subtest <- fread("UCI HAR Dataset/test/subject_test.txt", col.names = "Subject")

test <- cbind(Subtest,"Activity" =Ytest,Xtest)

all.data <- rbind(train,test)



mlt.data <- melt(all.data, id = c("Subject", "Activity"))
combined <- dcast(mlt.data, Subject + Activity ~ variable, mean)

fwrite(x = combined, file = "tidy.txt", quote = FALSE)
