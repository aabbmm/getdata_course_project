# getdata_course_project#
    
      This repository includes the run_analysis.R script file to produce tidy data set and 
      the file Codebook.txt for data codebook
      
      The script assumes that the diectory "UCI HAR Dataset" is in the working direction. 

     The script will read all feature, subject, and label data for both train and test sets,
     re-label activities with their names, re-label measurement column names with descriptive names,
     keep only measurement data only those measurements with the word mean and std 
     and finally produce a tidy data set, output as "tidy_data_set.txt"
     Script will also produce a file "Codebook_pre.txt", with names of selected measurements, 
     to aid in construction of codebook.
