#This code allows you to visualize your observations in an interactive treemap.

#Go to https://www.inaturalist.org/observations/export to get your data.
#Highest Rank should be set to Species but not necessary.
#The file MUST have the following columns:
#taxon_kingdom_name
#taxon_phylum_name
#taxon_class_name
#taxon_order_name
#taxon_family_name
#taxon_genus_name
#taxon_species_name


#Load required packages
library(tidyr)
library(plyr)
library(treemap)
library(magrittr)
library(d3treeR)

#Upload data
data <- read.csv(choose.files(), na.strings = c("", "NA"))

#Grab the Species column and create a table
Species <- data$taxon_species_name %>%
  table() %>%
  as.data.frame()
names(Species) <- c("Species", "Obs")

#Subset the data
data <- data.frame(data$taxon_kingdom_name, data$taxon_phylum_name, data$taxon_class_name, data$taxon_order_name, data$taxon_family_name, data$taxon_genus_name, data$taxon_species_name)
names(data) <- c("Kingdom", "Phylum", "Class", "Order", "Family", "Genus", "Species")

#Join both data frames to get desired input for a treemap
data <- join(data, Species, by = "Species", type = "right", match = "first")

#Build the treemap
a <- treemap(d,
        index=c("Kingdom", "Phylum", "Class", "Order", "Family", "Genus", "Species"),
        vSize="Obs",
        type="index"
)

#Add interactivity
d3tree2(a, rootname = "Kingdom", id = "name")
