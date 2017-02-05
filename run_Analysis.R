###############################################################################
# Peer Graded Assignment for Gathering and Cleaning Data Course Project       #
# Create Tidy Data set and summarization of "Human Activity Recognition       #
# database built from the recordings of 30 subjects performing activities of  #
# daily living (ADL) while carrying a waist-mounted smartphone with embedded  #
# inertial sensors."
#

setupAnaylsis <- function() {
    # load libaries used for the analysis
    # library(dplyr)
    # libarry(reshape2)
}

# helper function to read in subject_train and subject_test files
# purpose is to encapsulate and reuse parameters specific to this file
# sets the name of column to subjectId
# expects to receive the path to the file and returns a data.frame
readSubjectFile <- function(pathToFile) {
    dfSubjects <- read.csv(pathToFile, col.names = "subjectId", header = FALSE, nrows = 10)
    return(dfSubjects)
}

# helper function to read in X_train and X_test files
# purpose is to encapsulate and reuse parameters specific to this file
# expects to receive the path to the file and returns a data.frame
readMeasurementFile <- function(pathtoFile) {
    # create a vector of column widths for this fixed width file, first column has an additional space of padding
    # -1.0000000e+000 looks to be the value for an NA measurement (leaving as is for the purpose of this analysis)
    fixedColWidths = c(17, rep.int(16, 515))
    dfMeasurements <- read.fwf(pathtoFile, widths = fixedColWidths, header = FALSE, n = 10)
    return(dfMeasurements)
}

# helper function to read in Y_train and Y_test files
# purpose is to encapsulate and reuse parameters specific to this file
# sets the name of column to activityId
# expects to receive the path to the file and returns a data.frame
readObservedActivityFile <- function(pathtoFile) {
    dfObservedActivities <- read.csv(pathtoFile, col.names = "activityId", header = FALSE, nrows = 10)
}

# primary function to create the required data set and output for this assignment
# input is the path to the root node of the analysis data "UCI HAR Dataset"
createTidyDataset <- function(pathtoRootDataDir) {
    
    # build path variables to data files in the correct way for the OS 
    X_trainFilePath <- file.path(pathtoRootDataDir, "train", "X_train.txt" )
    X_testFilePath <- file.path(pathtoRootDataDir, "test", "X_test.txt" )
    
    Y_trainFilePath = file.path(pathtoRootDataDir, "train", "Y_train.txt" )
    Y_testFilePath <- file.path(pathtoRootDataDir, "test", "Y_test.txt" )
    
    subject_trainFilePath <- file.path(pathtoRootDataDir, "train", "subject_train.txt" )
    subject_testFilePath <- file.path(pathtoRootDataDir, "test", "subject_test.txt" )
    
    activityLabelsFilePath <- file.path(pathtoRootDataDir, "activity_labels.txt" )
    
    featureNamesFilePath <- file.path(pathtoRootDataDir, "features.txt" )
    
    # create datafame from Measurements files
    dfX_train <- readMeasurementFile(X_trainFilePath)
    dfX_test <- readMeasurementFile(X_testFilePath)
    dfY_train <- readObservedActivityFile(Y_trainFilePath)
    dfY_test <- readObservedActivityFile(Y_testFilePath)
    dfSubject_train <- readSubjectFile(subject_trainFilePath)
    dfSubject_test <- readSubjectFile(subject_testFilePath)
    
    # create data.frame from Activity Labels and Feature Names files
    # no helper functions since these are only 1 time reads
    dfActivity_labels <- read.csv(activityLabelsFilePath, header = FALSE, sep = " ", col.names = c("activityId", "activityLabel"))
    dfFeatures <- read.csv(featureNamesFilePath, header = FALSE, sep = " ", col.names = c("featureId", "featureName"))
    
    # Create an identifier column that will be used later in the melted dataset to map feature column names to feature labels
    # This identifier is in the form of "V" + featureID
    dfFeatures <- mutate(dfFeatures, featureColName = paste0("V", dfFeatures$featureId))

    # Combine the three data.frames subject, measurement, activity into 1.
    # In that way, we'll create 1 row per observations
    dfTrain <- cbind.data.frame(dfSubject_train, dfY_train, dfX_train)
    dfTest <- cbind.data.frame(dfSubject_test, dfY_test, dfX_test)
    
    # Combine Training and Test into 1 data.frame
    dfTrainTest <- rbind.data.frame(dfTrain, dfTest)
    
    # Combine the merged dataset with the activity labels
    dfTrainTest <- merge.data.frame(dfActivity_labels, dfTrainTest, by.x = "activityId", by.y = "activityId")
    
    # Melt the measurement variables into pairs of measurement names and values
    colPrefix <- rep("V", 516)
    nums <- seq.int(516)
    featureColNames <- paste0(colPrefix, nums)
    
    dfTrainTestMelt <- melt(dfTrainTest, id = c("subjectId", "activityId", "activityLabel"), measure.vars = featureColNames,
                            variable.name = "featureColName", value.name = "sensorReading")
    
    # Combine the melted dataset with the feature names
    dfTrainTestMelt <- merge.data.frame(dfFeatures, dfTrainTestMelt, by.x = "featureColName", by.y = "featureColName")
    
    # Clean up the melted datafame to just the needed columns and rename feature column to measurementType
    dfTrainTestMelt <- select(dfTrainTestMelt, subjectId, activityLabel, featureName, sensorReading)
    dfTrainTestMelt <- rename(dfTrainTestMelt, measurementType = featureName)   
    
    # Per the instructions in this exercise, further filter the rows to just the mean() and std() calculations
    # there is a meanFreq() measurement and it is unclear whether or not to include it.  I've left it out.
    dfTrainTestMelt <- dfTrainTestMelt[ grepl("*mean()*" , dfTrainTestMelt$measurementType)  |
                                             grepl("*std()*" , dfTrainTestMelt$measurementType) , ]
    
    # Print out some information about the resulting data.frame
    View(dfTrainTestMelt)
    print(nrow(dfTrainTestMelt))
    
    # create a cross tab of average sensorReading by subject, activity and measurement type and rename the column to
    # averageSensorReading
    xtTrainTestMelt <- xtabs(sensorReading ~ subjectId  + activityLabel + measurementType, 
                data = aggregate(sensorReading ~ subjectId  + activityLabel + measurementType, dfTrainTestMelt, mean))
       
    View(xtTrainTestMelt)
    class(xtTrainTestMelt)
    
    dfAvgMeasures <- as.data.frame(xtTrainTestMelt)
    dfAvgMeasures <- rename(dfAvgMeasures, averageSensorReading = Freq)
    View(dfAvgMeasures)
}
