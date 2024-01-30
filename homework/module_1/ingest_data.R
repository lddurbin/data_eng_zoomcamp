library(readr)
library(DBI)
library(RPostgres)
library(dplyr)

# Database connection parameters
db <- Sys.getenv("db")
host <- Sys.getenv("host")
port <- Sys.getenv("port")
user <- Sys.getenv("user")
password <- Sys.getenv("password")
table_name <- Sys.getenv("table_name")

# Define the chunk size
chunk_size <- 10000  # Adjust the size based on your system's capability

# Callback function to process and upload each chunk
process_and_upload <- function(chunk, pos) {
  print(paste("Processing chunk:", pos))
  
  if(Sys.getenv("table_name") != "zones") {
      # Assuming you need to process the data
  chunk <- chunk %>%
    mutate(lpep_pickup_datetime = as.POSIXct(lpep_pickup_datetime),
           lpep_dropoff_datetime = as.POSIXct(lpep_dropoff_datetime))
  }

  # Append data to PostgreSQL
  dbWriteTable(con, table_name, chunk, append = TRUE, row.names = FALSE)
}

# Create a connection to the PostgreSQL database
con <- dbConnect(RPostgres::Postgres(), 
                 dbname = db, 
                 host = host, 
                 port = port, 
                 user = user, 
                 password = password)

# Read and process the file in chunks
readr::read_csv_chunked("taxi+_zone_lookup.csv", 
                        chunk_size, 
                        callback = SideEffectChunkCallback$new(process_and_upload),
                        col_types = cols())

# Close the connection
dbDisconnect(con)
