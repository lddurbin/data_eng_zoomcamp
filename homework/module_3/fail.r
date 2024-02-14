slug <- "https://d37ci6vzurychx.cloudfront.net/trip-data/green_tripdata_2022-"
filedest <- here::here("data")

purrr::walk(
  paste0(slug, sprintf("%02d", 1:12), ".parquet"),
  ~download.file(.x, paste0(filedest, "/", basename(.x)), "libcurl")
)

con <- DBI::dbConnect(duckdb::duckdb(), "nyc_taxi.duckdb")
DBI::dbExecute(con, "CREATE TABLE green_taxi_2022 AS SELECT * FROM read_parquet('data/*.parquet')")

DBI::dbGetQuery(con, "SELECT COUNT(*) FROM green_taxi_2022") # 840,402 records


DBI::dbGetQuery(con, "SELECT COUNT(*) FROM green_taxi_2022 WHERE fare_amount=0") # 1622 records