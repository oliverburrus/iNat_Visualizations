#This code allows you to view the iNat leaderboard.

#Replace the following text with the desired taxon id and place id.
Taxon_id <- 26718
Place_id <- 35

#Load required packages
library(httr)
library(rlist)
library(reactable)
library(dplyr)

#API set-up
resp <- GET(paste("https://api.inaturalist.org/v1/observations?place_id=", Place_id, "&taxon_id=", Taxon_id,"&page=1&per_page=200&order=desc&hrank=species&order_by=created_at", sep = ""))
parsed <- content(resp, as = "parsed")
if(parsed$total_results > 8000){
  stop("Observations excede 8000, please use leaderboard_by_year.R")
}

#Retreving data from the API
for(x in 0:(parsed$total_results/200)+1){
  resp <- GET(paste("https://api.inaturalist.org/v1/observations?place_id=", Place_id, "&taxon_id=", Taxon_id,"&page=", as.character(x), "&per_page=200&order=desc&hrank=species&order_by=created_at", sep = ""))
  parsed <- content(resp, as = "parsed")
  modJSON <- parsed$results 
  modJSON <- list.select(modJSON, taxon$name, user$login)
  if(x == 1){
    data <- list.stack(modJSON)
  }
  if(x > 1){
    dataz <- list.stack(modJSON)
    data <- rbind(data, dataz)
  }
}

#Build the table
data <- tidyr::separate(data, V1, into = c("Genus", "Species", "Other"))
data <- data.frame(paste(data$Genus, data$Species, sep = " "), data$V2)
colnames(data) <- c("Sci_name", "User")
table(data$V2)
a <- unique(paste(data$Sci_name, data$User, sep = "~"))%>%
  as.data.frame()
b <- tidyr::separate(a, ., into = c("Sci_name", "User"), sep = "~")
c <- table(b$User)%>%
  as.data.frame()
reactable(c)
