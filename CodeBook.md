# Gathering Cleaning Data Course Project
Final Course Project for Coursera | Johns Hopkins Gathering and Cleaning Data

# Context
The objective of this analysis is to create a tidy dataset from "Human Activity Recognition database built from the recordings of 30 subjects performing activities of daily living (ADL) while carrying a waist-mounted smartphone with embedded inertial sensors."
http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones

# Output File
- The createTidyDataset() function in the run_Analysis.R script creates an output file called tableAvgMeasures.txt with the following fields:
1. subjectId - is sourced from the subject_train.txt and subject_test.txt files, represents the identifer of the person carrying/wearing the Samsung device
2. activityLabel - the id sourced from the Y_train.txt and Y_text.txt files, represents the observed activity of the person carrying/wereing the Samsung device.  The domain of values are:
  *       WALKING
  *       WALKING_UPSTAIRS
  *       WALKING_DOWNSTAIRS
  *       SITTING
  *       STANDING
  *       LAYING
3. measurementType - is sourced from the X_train.txt and X_text.txt files, is a subset of the 516 measurements documented in feature_info.txt.  The subset are just the measurements that are the calculated mean() and std() of the individual measurements.  I elected to not include the meanFreq() statistics. It appears that there are no NA's in the data, however, there are spuratic readings of -1.0000000e+000 which seems odd.  There is nothing in the documentation that indicates this is an NA so I left these values as is.
4. averageSensorReading - this is a calculated mean of the sensor readings / statistics grouped by subjectId, activityLabel, and measurementType. 

# Outline of Analysis
- Starting with the training dataset, combine all 3 files: subject_train, X_train, and y_train into a single data frame
- Repeat for the test dataset
- Combine training and test into a single data frame
- Transpose the resulting table into the structure described in Wide vs. Narrow section of this read.me.
- Replace the activity identifiers with the activity descriptions 
- Perform summarization and create output file