#Go to https://www.inaturalist.org/observations/export to get your data.
#Highest Rank MUST be set to Species!
#The file MUST have the following columns:
#Taxon Species Name
#Common Name
#Observed On
#URL
#Iconic Taxon Name


#Upload the data 
#(execute this line first, and select the file you want)
data <- read.csv(choose.files())

#----- No need to edit anything from here on, 
#----- just execute everything.

#Load required packages
library(reactable)

#Format the column to "Date" format
data$observed_on <- as.Date(data$observed_on)

#Subset the data
dataset <- data.frame(data$common_name, data$taxon_species_name, data$observed_on, data$url, data$iconic_taxon_name)
dataset <- dataset[order(dataset$data.taxon_species_name, dataset$data.observed_on),]
names(dataset) <- c("Common Name", "Scientific Name", "First Seen", "URL", "Iconic Taxon")
rownames(dataset) <- NULL

#Get the species list
species <- data.frame(unique(data$taxon_species_name))
names(species) <- "Scientific Name"

#Merge the data
table <- join(species, dataset, by = "Scientific Name", type = "left", match = "first")

#Build the table
a <- reactable(table, striped = TRUE, showPageSizeOptions = TRUE, pageSizeOptions = c(10, 50, 100, 1000, 10000), filterable = TRUE)

#Plot the table
a
