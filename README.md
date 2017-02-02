# Gathering Cleaning Data Course Project
Final Course Project for Coursera | Johns Hopkins Gathering and Cleaning Data

# Context
The objective of this analysis is to create a tidy dataset from "Human Activity Recognition database built from the recordings of 30 subjects performing activities of daily living (ADL) while carrying a waist-mounted smartphone with embedded inertial sensors."
http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones

# The Challenge
A tidy dataset is characterized by 3 priciples:
- Each variable forms a column
- Each observation forms a row
- Each type of observation unit forms a table

The first challenge with the data from this study is that it violates the 3rd principle.  The data from 1 observation is spread across 3 tables.  Specifically, the subject of the observation, the sensor measurements, and the activity the subject was performing at the time of the measurement.

# Approach
## Wide vs. Narrow
The measurement data as provided is wide, 561 sensor readings / calculations on those readings per observations.  I believe the right approach is to melt the dataset into a narrow format that has the following columns:
- subjectID
- measurementType
- sensorReading
- activity
There are a couple of advantages to this approach.  The first is no having to deal with the measurement types as column names, there are a number of special characters in those descriptions that will need to be cleaned up using make.names() function in R.  So the output of that will be somewhat different than the descriptions used in the published data.

This approach will make further summarizations by measurementType and Activity straighforward

# Outline of Analysis
- Starting with the training dataset, combine all 3 files: subject_train, X_train, and y_train into a single table
- Transpose the resulting table into the structure listed above in Wide vs. Narrow section of this readme.
- Replace the activity identifiers with the activity descriptions 
- Repeat for the text data files
- Combine training and text data
- Perform summarization and create output file

# Files In This Repo
- README.md - this file.
- CodeBook.md - data dictionary for both the source files as well as the data sets produced in the course of this analysis
- run_analysis.R - the R scipt that performs the analysis as specified in the course project description.  

# Key Assumptions for Repeating this Analysis
- The source files provided by Coursera are in a .zip archive with a defined directory tree structure.  It is assumed that this structure is maintained.  The root directory for this structure is named "UCI HAR Dataset".  The analysis script takes as input the absolute path to this root director, so that the location of the R script is not relevant.
