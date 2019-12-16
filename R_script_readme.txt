General guide when using the R scripts that I have developed for the project:

1. Use RStudio when running the scripts (Download RStudio Desktop -- https://rstudio.com/products/rstudio/download/).
2. These script basically looks through all the 'results' folders to check if there are any files (in this case, '.csv' files) that contain model results.
3. By using a database, the makes it easier to access and work with these results that are more than 1680 results files in different locations (folders). These files (in the 'zambia' folder) were collated into 7 tables of the database.
4. There are numerous advantages of using databases when analysing data, particularly the multi-file data arrangements under this project. These advantages are beyond the scope of this work.
5. The 'get_results_files' function in 'processing_results_files.R' is used for collating all the results into a database.
6. The 'dbTable_to_csv_file' function in 'processing_results_files.R' is used for converting each of the database tables (from the newly created database) into '.csv' files. Note tables vary in size: 'Agshr.csv' - 48.2MB, 'GDP.csv' - 48.6MB, 'HExpend.csv' - 1.6GB, 'QFAgg.csv' - 1.4GB, 'QVAreg.csv' - 3.8GB, 'resultsA.csv' - 707.2MB, and 'resultsB.csv' - 3.8GB.
7. The database created can be read into R, Python, Stata and SPSS, to name but a few. However, by converting the database table into '.csv', one can eaily read the data into an software of their preference.
8. A start up script for reading the database in R is given (i.e. data_analysis.R).
