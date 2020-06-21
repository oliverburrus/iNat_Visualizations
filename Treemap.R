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
