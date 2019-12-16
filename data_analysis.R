

library(dplyr)

##############

# What database do you want to read?
database_name <- 'rawdata_combined_ccZambia.db'    #This is same name as in the 'processing_results_files.R' script
dB_file <- dplyr::src_sqlite(database_name, create = FALSE) 
src_tbls(dB_file) # List the tables in the database


# Get database tables with data of interest

Agshr_Data <- dplyr::tbl(dB_file, "Agshr") # Agshr data is the data from all the "X_Agshr.csv" files
GDP_Data <- dplyr::tbl(dB_file, "GDP") # GDP data is the data from all the "X_GDP.csv" files
HExpend_Data <- dplyr::tbl(dB_file, "HExpend") # HExpend data is the data from all the "X_HExpend.csv" files
QFAgg_Data <- dplyr::tbl(dB_file, "QFAgg") # QFAgg data is the data from all the "X_QFAgg.csv" files

QVAreg_Data <- dplyr::tbl(dB_file, "QVAreg") # QVAreg data is the data from all the "X_QVAreg.csv" files
resultsA_Data <- dplyr::tbl(dB_file, "resultsA") # resultsA data is the data from all the "X_resultsA.csv" files
resultsB_Data <- dplyr::tbl(dB_file, "resultsB") # resultsB data is the data from all the "X_resultsB.csv" files


Agshr_Data <- dplyr::tbl_df(Agshr_Data) # etc # same for other tables
# This converts a database table into a standard dataframe table. 
# This process is not necessary. It is better you only convert the data after you have processed or selected
# the variables of interest from the table.
# to get more information, just read up on dplyr packages.



