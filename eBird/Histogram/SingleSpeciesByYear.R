#Import required packages
library(ggplot2)
library(magrittr)
library(rebird)

#Can either be "states", "counties", or "hotspots"
Loc_Type <- "Enter Loc_Type here"
#For states put the two letter country code followed by the two letter state code and separated by "-" (e.g. "US-NY")
#For counties use same format as states but add 3 number county code seperated by a hyphen if in US or 2 letter code if in Canada (e.g. "US-IL-035")
#For hotspots use the unique identifier as found on the hotspot page on eBird.org
Loc_ID <- "Enter Loc_ID here"
#Enter the common name of a bird species (in Clements/eBird nomenclature)
Species <- "Enter Species here"
#Enter how many years back you would like to retreve data from (I suggest 10).
years_back <- 10

#Retreve the data with rebird
x <- as.numeric(format(Sys.Date(), "%Y")) - years_back
while(x < as.numeric(format(Sys.Date(), "%Y"))){
  if(x == as.numeric(format(Sys.Date(), "%Y")) - years_back){
    eBird <- ebirdfreq(Loc_Type, Loc_ID, startyear = x, endyear = x) %>%
      dplyr::filter(comName == Species)
    eBird <- data.frame(sum(eBird$frequency), sum(eBird$sampleSize))
    names(eBird) <- c("Freq", "Sample")
  } else{
    eBirdz <- ebirdfreq(Loc_Type, Loc_ID, startyear = x, endyear = x) %>%
      dplyr::filter(comName == Species)
    eBirdz <- data.frame(sum(eBirdz$frequency), sum(eBirdz$sampleSize))
    names(eBirdz) <- c("Freq", "Sample")
    eBird <- rbind(eBird, eBirdz)
  }
  x <- x+1
}
#Add columns
eBird$Year <- seq(as.numeric(format(Sys.Date(), "%Y")) - (years_back-1), as.numeric(format(Sys.Date(), "%Y")))
eBird$Average <- mean(eBird$Freq)
eBird$GrThAvg <- eBird$Freq > eBird$Average

#Plots to test if the data is biased
#Plot 1: Plot should show random sparks in color on the points as year increases.
ggplot(data = eBird, 
       aes(x = Year, y = Sample, color = Freq)) +
  geom_point(size = 3)
#plot 2: Plot should show completely random distribution of points and color of the points.
ggplot(data = eBird, 
       aes(x = Freq, y = Sample, color = Freq)) +
  geom_point()

#The final plot!
ggplot(data = eBird, 
       aes(x = Year, y = Freq)) +
  geom_smooth(se = F) +
  geom_line(color = "orange") +
  geom_point(aes(color = GrThAvg), show.legend = F) +
  geom_line(aes(y = Average), alpha = .5) +
  scale_x_continuous(breaks = seq(min(eBird$Year), max(eBird$Year), 1), minor_breaks = 0)+
  ylim(0, max(eBird$Freq)+(max(eBird$Freq)/10))

#Part of the text in the comments was copied from the rebird documentation
