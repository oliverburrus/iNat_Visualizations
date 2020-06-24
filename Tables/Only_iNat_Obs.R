#This code allows you to find out with species you have observed on iNat that no one else has.

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
while(x < (parsed$total_results/500)+1){
  resp <- GET(paste("https://api.inaturalist.org/v1/observations/species_counts?user_id=", user, "&page=", as.character(x), "&hrank=species", sep = ""))
  parsed <- content(resp, as = "parsed")
  modJSON <- parsed$results %>%
    list.select(taxon$name, count, taxon$observations_count)
  if(x == 1){
    data <- list.stack(modJSON)
  }
  if(x > 1){
    dataz <- list.stack(modJSON)
    data <- rbind(data, dataz)
  }
  x <- x+1
}

#Add a logical column to define if you have the ONLY iNat ob(s) of a certain species.
data$logic <- data$V2 == data$count

#Filter the data based on the Logical column
data <- filter(data, data$logic == T)
data <- data.frame(data$V1, data$count, data$V2)
names(data) <- c("Species", "Your Obs", "Total Obs")

#Build the table
a <- reactable(data, striped = TRUE, showPageSizeOptions = TRUE, pageSizeOptions = c(5, 10, 20, 100), filterable = TRUE)
a
