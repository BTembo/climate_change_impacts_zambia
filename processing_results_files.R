
# Makes the packages below are installed. Run:
#install.packages(c("stringr", "dplyr", "RSQLite"))

library(stringr)
library(dplyr)
library(RSQLite)


###
# Set the working directory -- this is a critical step. Note, I am assuming that you are using RStudio as your IDE.
wdir <- setwd(dirname(rstudioapi::getActiveDocumentContext()$path))
getwd()


# What database do you want to write your data to?
database_name <- 'rawdata_combined_ccZambia.db'    #This is where the results will be written to.

# database_name2 <- 'combined_ccZambia_withcolnames.db'    # This is where the results will be written to.


###


# Function is for adding column names to the data files
insert_table_headers <- function(fileName, tableInput){
  
  tableData <- tableInput
  
  if(fileName == "resultsB"){
    tableData <- tableData %>% 
      rename(variable = V1, commodity = V2, todrop1 = V3,
             todrop2 = V4, scenario = V5, climate = V6,
             year = V7, value = V8)
      
      tableData <- tableData %>%  select(-todrop1, -todrop2)
      
      } else if(fileName == "resultsA"){
        tableData <- tableData %>% 
          rename(variable = V1, scenario = V2, 
                 climate = V3, year = V4, value = V5)
        
      } else if(fileName == "QVAreg"){
        tableData <- tableData %>% 
          rename(variable = V1, sector = V2, region = V3,
                 scenario = V4, climate = V5,
                 year = V6, value = V7)
        
      } else if(fileName == "QFAgg"){
        tableData <- tableData %>% 
          rename(variable = V1, labourtype = V2, sector = V3,
                 scenario = V4, climate = V5,
                 year = V6, value = V7)
        
      } else if(fileName == "HExpend"){
        tableData <- tableData %>% 
          rename(variable = V1, household = V2, scenario = V3,
                 climate = V4, year = V5, value = V6)
        
      } else if(fileName == "GDP"){
        tableData <- tableData %>% 
          rename(variable = V1, scenario = V2, climate = V3, 
                 year = V4, value = V5)
        
      } else if(fileName == "Agshr"){
        tableData <- tableData %>% 
          rename(variable = V1, scenario = V2, climate = V3,
                 year = V4, value = V5)
      
      } else{
        print("This is a new table!")
        }
    
}


###

# Function for collating all the results data.
get_results_files <- function(getwdInput, dbName){
  
  start.time2 <- Sys.time()
  
  # Create a database where the combined data will be stored. This over-writes if the file already exists.
  dB_file <- dplyr::src_sqlite(dbName, create = T) 
  
  writeToDB <- dbConnect(SQLite(), dbname = dbName)
  
  all_directories <- list.dirs()
  
  for(directory in all_directories){
    
    if(stringr::str_detect(directory, "/results/") == T){
      
      files <- list.files(path = directory, pattern = '.csv')
      
      for (file in files) {
        
        file_path <- paste(directory, file, sep = '/')
        
        tableName <- stringr::str_replace(file, "[0-9]", "")
        tableName <- stringr::str_replace(tableName, "_", "")
        tableName <- stringr::str_replace(tableName, ".csv", "")
        print(tableName)
        
        start.time <- Sys.time()
        
        df_data <- read.csv(file_path, header = F)
        
        df_data <- insert_table_headers(tableName, df_data)
        
        # the file path was included for easy auditing purposes.
        df_data <- cbind.data.frame(df_data, filePath = file_path)
        
        df_data <- dplyr::distinct(df_data)
        # print((df_data))
        
        dbWriteTable(conn = writeToDB, name = tableName,
                     df_data, append = T, row.names = F)
        
        end.time <- Sys.time()
        time.taken <- end.time - start.time
        print(time.taken)
      }
    }
  }
  
  end.time2 <- Sys.time()
  time.taken2 <- end.time2 - start.time2
  print(time.taken2)
  
  dbDisconnect(writeToDB)
  
}


get_results_files(wdir, database_name)



### Only run this code -- below -- if you want to convert the db tables into other file formats.

# Function for converting all database tables into .csv files
dbTable_to_csv_file <- function(dbName){
  
  start.time2 <- Sys.time()
  
  conn_db_file <- dplyr::src_sqlite(dbName, create = FALSE) # connect to database
  dbTables <- src_tbls(conn_db_file) # List the tables in the database
  
  for(dbTable in dbTables){
    
    start.time <- Sys.time()
    
    tableData <- dplyr::tbl(conn_db_file, dbTable)
    # tableData <- head(tableData)
    tableData <- dplyr::distinct(dplyr::tbl_df(tableData))

    print(dim(tableData))
    
    fileName <- paste0(dbTable, ".csv")
    # fileName <- paste0(dbTable, '_head', ".csv")

    write.csv(tableData, file = fileName, row.names=F)
    
    print(dbTable)
    print(fileName)
    
    end.time <- Sys.time()
    time.taken <- end.time - start.time
    print(time.taken)
  }
  
  end.time2 <- Sys.time()
  time.taken2 <- end.time2 - start.time2
  print(time.taken2)
  
}


dbTable_to_csv_file(database_name)

###
