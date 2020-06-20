#Go to https://www.inaturalist.org/observations/export to get your data.
#Highest Rank MUST be set to Species!
#The file MUST have the following columns:
#Observed On
#Iconic Taxon Name

#Load required packages
library(tidyr)
library(ggplot2)
library(plotly)
library(dplyr)

#Load the data
data <- read.csv(choose.files(), na.strings = c("", "NA"))

#Filter the data
data$logic <- is.na(data$iconic_taxon_name)
data <- filter(data, logic == FALSE) %>%
  separate(observed_on, into = c("Year", "Month", "Day"), sep = "-")
df <- as.data.frame(table(data$Month, data$iconic_taxon_name))
names(df) <- c("Month", "Iconic Taxon", "Obs")

#Make the Bar Plot
p <- ggplot(data = df, 
       aes(x = Month, y = Obs, fill = `Iconic Taxon`))+
  geom_bar(position="stack", stat="identity")+
  scale_colour_gradientn(colours=rainbow(10))+
  scale_fill_hue(l=50)
p %>%
  ggplotly(tooltip = c("Iconic Taxon", "Obs")) %>% 
  config(displayModeBar = FALSE) %>% 
  layout(xaxis = list(fixedrange = TRUE)) %>% 
  layout(yaxis = list(fixedrange = TRUE))
