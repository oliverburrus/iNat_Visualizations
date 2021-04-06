Taxon_ID <- #Enter your target taxon_id here, NOT the taxon_name (eg. if you are trying to make a choropleth map for birds, enter 3, NOT "Birds", you can find the taxon ID by going to Explore on iNaturalist.org)

# After running the code below, lets create the choropleth map using datawrapper.de
# 1 - locate the csv file (eg. Choropleth_Taxon_3.csv) in your current working directory, open in a spredsheet editor, and copy the "count" column.
# 2 - open datawrapper.de and click "Start Creating"
# 3 - click New Map -> Choropleth Map -> scroll down and select "USA >> States" -> Proceed.
# 4 - paste your copied data into the value column, click Proceed and start customising the map!

if(is.numeric(Taxon_ID)==T){
  resp <- GET("https://api.inaturalist.org/v1/places/1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37,38,39,40,41,42,43,44,45,46,47,48,49,50,51,52?admin_level=1")
  parsed <- content(resp, as = "parsed")
  modJSON <- parsed$results 
  modJSON <- list.select(modJSON, name)
  states <- list.stack(modJSON)
  states$ID <- seq(52, 2)
  
  
  #Retreving data from the API
  for(x in 2:max(states$ID)){
    resp <- GET(paste("https://api.inaturalist.org/v1/observations/species_counts?place_id=", as.character(x), "&taxon_id=", as.character(Taxon_ID), "&quality_grade=research", sep = ""))
    parsed <- content(resp, as = "parsed")
    if(x == 2){
      data <- parsed$total_results
    }
    if(x > 2){
      dataz <- parsed$total_results
      data <- rbind(data, dataz)
    }
  }
  states$count <- rev(data)
  states <- states[order(states$name),]
  write.csv(states, paste("Choropleth_Taxon_", Taxon_ID, ".csv", sep = ""))
}else{
  stop("Taxon_ID must be a number.")
}
