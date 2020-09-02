#This code allows you to find out with species you have observed on iNat.

#Replace the following text with your iNat username
user <- "your_username"

#Load required packages
library(httr)
library(rlist)
library(reactable)
library(dplyr)

#API set-up
x <- 1
resp <- GET(paste("https://api.inaturalist.org/v1/observations/species_counts?user_id=", user, "&page=", as.character(x), "&hrank=species", sep = ""))
parsed <- content(resp, as = "parsed")

#Retreving data from the API
for(x in 1:(parsed$total_results/500)){
  resp <- GET(paste("https://api.inaturalist.org/v1/observations/species_counts?user_id=", user, "&page=", as.character(x), "&hrank=species", sep = ""))
  parsed <- content(resp, as = "parsed")
  modJSON <- parsed$results 
  modJSON <- list.select(modJSON, taxon$name, count, taxon$observations_count, taxon$iconic_taxon_name)
  if(x == 1){
    data <- list.stack(modJSON)
  }
  if(x > 1){
    dataz <- list.stack(modJSON)
    data <- rbind(data, dataz)
  }
}

data <- data.frame(data$V1, data$count, data$V2, data$V3)
names(data) <- c("Species", "Your Obs", "Total Obs", "Iconic Taxon")

#Build the table
a <- reactable(data, striped = TRUE, showPageSizeOptions = TRUE, pageSizeOptions = c(5, 10, 20, 100), filterable = TRUE)
a
