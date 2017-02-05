# Gathering Cleaning Data Course Project
Final Course Project for Coursera | Johns Hopkins Gathering and Cleaning Data

# Context
The objective of this analysis is to create a tidy dataset from "Human Activity Recognition database built from the recordings of 30 subjects performing activities of daily living (ADL) while carrying a waist-mounted smartphone with embedded inertial sensors."
http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones

# Output File
- The createTidyDataset() function in the run_Analysis.R script creates an output file called tableAvgMeasures.txt with the following fields
- subjectId - is sourced from the subject_train.txt and subject_test.txt files, represents the identifer of the person carrying/wearing the Samsung device
- activityLabel - is sourced from the Y_train.txt and Y_text.txt files, represents the observed activity of the person carrying/wereing the Samsung device
- the domain of values are:
-       WALKING
-       WALKING_UPSTAIRS
-       WALKING_DOWNSTAIRS
-       SITTING
-       STANDING
-       LAYING
- measurementType - is sourced from the X_train.txt and X_text.txt files, is a subset of the 516 measurements documented in feature_info.txt.  
-                   the subset are just the measurements that are the calculated mean() and std() of the individual measurements
- averageSensorReading - this is a calculated mean of the sensor readings grouped by subjectId, activityLabel, and measurementType

# Outline of Analysis
- Starting with the training dataset, combine all 3 files: subject_train, X_train, and y_train into a single data frame
- Repeat for the test dataset
- Combine training and test into a single data frame
- Transpose the resulting table into the structure described in Wide vs. Narrow section of this read.me.
- Replace the activity identifiers with the activity descriptions 
- Perform summarization and create output file