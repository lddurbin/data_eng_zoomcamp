# Use an official R base image
FROM rocker/r-ver:latest

# Install Linux dependencies if any (you can add or remove as per your script's needs)
RUN apt-get update && apt-get install -y \
    libcurl4-gnutls-dev \
    libssl-dev \
    libxml2-dev \
    libpq-dev \
    wget

# Set the working directory in the container
WORKDIR /app

# Copy the R script into the container
COPY ingest_data.R ingest_data.R

# Set the entrypoint to run the R script
ENTRYPOINT ["Rscript", "ingest_data.R"]
