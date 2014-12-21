# load helpful libraries
suppressWarnings(suppressMessages( library(kitr) ))
suppressWarnings(suppressMessages( library(plyr) ))
suppressWarnings(suppressMessages( library(data.table) ))

# define paths, filenames and URLs
data_path = "data"
download_file = "storm-data.csv.bz2"
download_file_path = file.path( data_path, download_file )
url = "https://d396qusza40orc.cloudfront.net/repdata%2Fdata%2FStormData.csv.bz2"

# create the data folfder if it doesnt exist
if (!(file.exists( data_path ))) {
  # "Data folder exists"
  dir.create( data_path, showWarnings = FALSE )
} 

# download the file to the data directory if it is not there
if (!(file.exists( download_file_path ))) {
  download.file(url, download_file_path, method="curl")
}

# read the file
#pipe("storm-data.csv.bz2 | bunzip2" )
#raw_data <- read.table( "storm-data.csv", sep="," )
# raw_data <- read.table(bzfile("storm-data.csv.bz2"), sep=",")
raw_data <- read.table(bzfile( download_file_path ), sep=",", head=TRUE)


## START tests here!
# processing the data
events_dt <- data.table(raw_data)
# events are all over the place with lots of duplicates
# 
data_rows <- nrow( events_dt)
data_rows

# copy factors to a new character field
events_dt$event_char <- as.character( events_dt$EVTYPE )

# simplify and clean up the data -- the coding is not consistent with the standards listed by
# by NOA as defined in their data definitions found at:
# https://d396qusza40orc.cloudfront.net/repdata%2Fpeer2_doc%2Fpd01016005curr.pdf
# categorize all summary data as summary data
events_dt$event_char <- gsub(".*summary.*", "summary", events_dt$event_char, ignore.case=TRUE)
events_dt$event_char <- gsub(".*month.*", "summary", events_dt$event_char, ignore.case=TRUE)
events_dt$event_char <- gsub(".*week.*", "summary", events_dt$event_char, ignore.case=TRUE)
events_dt$event_char <- gsub(".*year.*", "summary", events_dt$event_char, ignore.case=TRUE)
events_dt$event_char <- gsub(".*record.*", "summary", events_dt$event_char, ignore.case=TRUE)
events_dt$event_char <- gsub(".*county.*", "summary", events_dt$event_char, ignore.case=TRUE)
events_dt$event_char <- gsub(".*southeast.*", "summary", events_dt$event_char, ignore.case=TRUE)

# categorize all "other events" (accidents, mild weather, urban events and
# unoffical weather events, etc) as other.  For a list of official events, 
# see:  https://d396qusza40orc.cloudfront.net/repdata%2Fpeer2_doc%2Fpd01016005curr.pdf
# for the purposes of this analysis -- similar events have been further grouped from 
# 42 defined events to 30 types of weather events.
events_dt$event_char <- gsub(".*hyp.*", "other", events_dt$event_char, ignore.case=TRUE)
events_dt$event_char <- gsub(".*drown.*", "other", events_dt$event_char, ignore.case=TRUE)
events_dt$event_char <- gsub(".*dam.*", "other", events_dt$event_char, ignore.case=TRUE)
events_dt$event_char <- gsub(".*acc.*", "other", events_dt$event_char, ignore.case=TRUE)
events_dt$event_char <- gsub(".*mishap.*", "other", events_dt$event_char, ignore.case=TRUE)
events_dt$event_char <- gsub(".*flag.*", "other", events_dt$event_char, ignore.case=TRUE)
events_dt$event_char <- gsub("\\?", "other", events_dt$event_char, ignore.case=TRUE)
events_dt$event_char <- gsub(".*no .*", "other", events_dt$event_char, ignore.case=TRUE)
events_dt$event_char <- gsub(".*none.*", "other", events_dt$event_char, ignore.case=TRUE)
events_dt$event_char <- gsub(".*mild.*", "other", events_dt$event_char, ignore.case=TRUE)
events_dt$event_char <- gsub(".*other.*", "other", events_dt$event_char, ignore.case=TRUE)
events_dt$event_char <- gsub(".*urban.*", "other", events_dt$event_char, ignore.case=TRUE)
events_dt$event_char <- gsub(".*wall.*", "other", events_dt$event_char, ignore.case=TRUE)
events_dt$event_char <- gsub(".*vog.*", "other", events_dt$event_char, ignore.case=TRUE)
# ice related weather events (using freezing early catches freezing events - which result in ice)
events_dt$event_char <- gsub(".*freezing.*", "ice", events_dt$event_char, ignore.case=TRUE)
events_dt$event_char <- gsub(".*ice.*", "ice", events_dt$event_char, ignore.case=TRUE)
events_dt$event_char <- gsub(".*icy.*", "ice", events_dt$event_char, ignore.case=TRUE)
events_dt$event_char <- gsub(".*glaze.*", "ice", events_dt$event_char, ignore.case=TRUE)
# astronomical tidal events
events_dt$event_char <- gsub(".*tide$", "tide", events_dt$event_char, ignore.case=TRUE)
events_dt$event_char <- gsub(".*tide.*", "tide", events_dt$event_char, ignore.case=TRUE)
events_dt$event_char <- gsub("^tidal.*", "tide", events_dt$event_char, ignore.case=TRUE)
# tornado related events
events_dt$event_char <- gsub(".*torn.*", "tornado", events_dt$event_char, ignore.case=TRUE)
events_dt$event_char <- gsub(".*funn.*", "tornado", events_dt$event_char, ignore.case=TRUE)
events_dt$event_char <- gsub(".*spout.*", "tornado", events_dt$event_char, ignore.case=TRUE)
# thunderstorm related events (tstm - is a NOA abbreviation for thunderstorms)
events_dt$event_char <- gsub(".*thun.*", "thunderstorm", events_dt$event_char, ignore.case=TRUE)
events_dt$event_char <- gsub(".*tund.*", "thunderstorm", events_dt$event_char, ignore.case=TRUE)
events_dt$event_char <- gsub("^tstm.*", "thunderstorm", events_dt$event_char, ignore.case=TRUE)
events_dt$event_char <- gsub(".*tstm.*", "thunderstorm", events_dt$event_char, ignore.case=TRUE)
events_dt$event_char <- gsub(".*gustn.*", "thunderstorm", events_dt$event_char, ignore.case=TRUE)
events_dt$event_char <- gsub(".*metro.*", "thunderstorm", events_dt$event_char, ignore.case=TRUE)
# lightning realated weather events
events_dt$event_char <- gsub(".*light.*", "lightning", events_dt$event_char, ignore.case=TRUE)
events_dt$event_char <- gsub(".*ligtn.*", "lightning", events_dt$event_char, ignore.case=TRUE)
events_dt$event_char <- gsub(".*lign.*", "lightning", events_dt$event_char, ignore.case=TRUE)
# blizzards
events_dt$event_char <- gsub(".*blizzard.*", "blizzard", events_dt$event_char, ignore.case=TRUE)
# hail
events_dt$event_char <- gsub(".*hail.*", "hail", events_dt$event_char, ignore.case=TRUE)
# sleet 
events_dt$event_char <- gsub(".*sleet.*", "sleet", events_dt$event_char, ignore.case=TRUE)
# avalanches
events_dt$event_char <- gsub("avalanc.*", "avalanche", events_dt$event_char, ignore.case=TRUE)
# costal flooding
events_dt$event_char <- gsub(".*coast.*", "coastal flood", events_dt$event_char, ignore.case=TRUE)
events_dt$event_char <- gsub(".*cstl.*", "coastal flood", events_dt$event_char, ignore.case=TRUE)
events_dt$event_char <- gsub(".*beach.*", "coastal flood", events_dt$event_char, ignore.case=TRUE)
events_dt$event_char <- gsub(".*surge.*", "coastal flood", events_dt$event_char, ignore.case=TRUE)
# cold and wind chill events
events_dt$event_char <- gsub(".*cool.*", "cold", events_dt$event_char, ignore.case=TRUE)
events_dt$event_char <- gsub(".*cold.*", "cold", events_dt$event_char, ignore.case=TRUE)
events_dt$event_char <- gsub(".*chill.*", "cold", events_dt$event_char, ignore.case=TRUE)
events_dt$event_char <- gsub(".*low.*", "cold", events_dt$event_char, ignore.case=TRUE)
events_dt$event_char <- gsub(".*snow.*", "snow", events_dt$event_char, ignore.case=TRUE)
# fog related weather events
events_dt$event_char <- gsub(".*fog.*", "fog", events_dt$event_char, ignore.case=TRUE)
# dust storm and dust devil weather events
events_dt$event_char <- gsub(".*dust.*", "dust", events_dt$event_char, ignore.case=TRUE)
# dry weather (and droughts)
events_dt$event_char <- gsub(".*dry.*", "drought", events_dt$event_char, ignore.case=TRUE)
events_dt$event_char <- gsub(".*excessive.*", "drought", events_dt$event_char, ignore.case=TRUE)
events_dt$event_char <- gsub(".*drought.*", "drought", events_dt$event_char, ignore.case=TRUE)
# heat related weather events
events_dt$event_char <- gsub(".*heat.*", "heat", events_dt$event_char, ignore.case=TRUE)
events_dt$event_char <- gsub(".*hot.*", "heat", events_dt$event_char, ignore.case=TRUE)
events_dt$event_char <- gsub(".*warm.*", "heat", events_dt$event_char, ignore.case=TRUE)
# frost related weather events
events_dt$event_char <- gsub(".*frost.*", "frost", events_dt$event_char, ignore.case=TRUE)
events_dt$event_char <- gsub(".*freeze.*", "frost", events_dt$event_char, ignore.case=TRUE)
# winter storms 
events_dt$event_char <- gsub(".*wint.*", "winter", events_dt$event_char, ignore.case=TRUE)
# fire related events
events_dt$event_char <- gsub(".*smoke.*", "fire", events_dt$event_char, ignore.case=TRUE)
events_dt$event_char <- gsub(".*fire.*", "fire", events_dt$event_char, ignore.case=TRUE)
# rain related events
events_dt$event_char <- gsub(".*rain.*", "rain", events_dt$event_char, ignore.case=TRUE)
events_dt$event_char <- gsub(".*mix.*", "rain", events_dt$event_char, ignore.case=TRUE)
events_dt$event_char <- gsub(".*shower.*", "rain", events_dt$event_char, ignore.case=TRUE)
events_dt$event_char <- gsub(".*precip.*", "rain", events_dt$event_char, ignore.case=TRUE)
events_dt$event_char <- gsub(".*wet.*", "rain", events_dt$event_char, ignore.case=TRUE)
# hurricane events
events_dt$event_char <- gsub(".*hur.*", "hurricane", events_dt$event_char, ignore.case=TRUE)
events_dt$event_char <- gsub(".*typ.*", "hurricane", events_dt$event_char, ignore.case=TRUE)
events_dt$event_char <- gsub(".*floyd.*", "hurricane", events_dt$event_char, ignore.case=TRUE)
# rip current events
events_dt$event_char <- gsub(".*rip.*", "rip current", events_dt$event_char, ignore.case=TRUE)
# tropicl depressions
events_dt$event_char <- gsub(".*depress.*", "tropical depression", events_dt$event_char, ignore.case=TRUE)
# tropical storms
events_dt$event_char <- gsub(".*trop.*", "tropical storm", events_dt$event_char, ignore.case=TRUE)
# wind events (not part of a thunderstorm)
events_dt$event_char <- gsub(".*wind.*", "wind", events_dt$event_char, ignore.case=TRUE)
events_dt$event_char <- gsub(".*turb.*", "wind", events_dt$event_char, ignore.case=TRUE)
events_dt$event_char <- gsub(".*micro.*", "wind", events_dt$event_char, ignore.case=TRUE)
events_dt$event_char <- gsub(".*wnd.*", "wind", events_dt$event_char, ignore.case=TRUE)
events_dt$event_char <- gsub(".*burst.*", "wind", events_dt$event_char, ignore.case=TRUE)
# flooding events
events_dt$event_char <- gsub(".*flood.*", "flood", events_dt$event_char, ignore.case=TRUE)
events_dt$event_char <- gsub(".*flooo.*", "flood", events_dt$event_char, ignore.case=TRUE)
events_dt$event_char <- gsub(".*stream.*", "flood", events_dt$event_char, ignore.case=TRUE)
events_dt$event_char <- gsub(".*water.*", "flood", events_dt$event_char, ignore.case=TRUE)
# land, mud and other debris slides
events_dt$event_char <- gsub(".*mud.*", "debris slide", events_dt$event_char, ignore.case=TRUE)
events_dt$event_char <- gsub(".*rock.*", "debris slide", events_dt$event_char, ignore.case=TRUE)
events_dt$event_char <- gsub(".*land.*", "debris slide", events_dt$event_char, ignore.case=TRUE)
# tsunami
events_dt$event_char <- gsub(".*tsunami.*", "tsunami", events_dt$event_char, ignore.case=TRUE)
# volcano events
events_dt$event_char <- gsub(".*volc.*", "volcano", events_dt$event_char, ignore.case=TRUE)
# various wave events at sea (marine waves)
events_dt$event_char <- gsub(".*surf.*", "marine waves", events_dt$event_char, ignore.case=TRUE)
events_dt$event_char <- gsub(".*sea.*", "marine waves", events_dt$event_char, ignore.case=TRUE)
events_dt$event_char <- gsub(".*sea.*", "marine waves", events_dt$event_char, ignore.case=TRUE)
events_dt$event_char <- gsub(".*swell.*", "marine waves", events_dt$event_char, ignore.case=TRUE)
events_dt$event_char <- gsub(".*wave.*", "marine waves", events_dt$event_char, ignore.case=TRUE)
events_dt$event_char <- gsub(".*high.*", "marine waves", events_dt$event_char, ignore.case=TRUE)
events_dt$event_char <- gsub(".*seiche.*", "marine waves", events_dt$event_char, ignore.case=TRUE)

events_dt$event_type <- as.factor( events_dt$event_char )
levels( events_dt$event_type )

# understand the time frames
# convert the begin data to extract just the year as a numeric value
#events_dt$year <- as.numeric(format( as.Date(as.character(events$BGN_DATE), %m/%d/%Y %T), "%Y""))
events_dt$date <-  as.Date( as.character(events_dt$BGN_DATE), format = " %m/%d/%Y %T" )
events_dt$year <- as.numeric( format( events_dt$date, "%Y" ) )

# convert the crop damage into us dollars
events_dt$crop_mult <- list(0)
events_dt$crop_mult[ events_dt$CROPDMGEXP == "K" ] <- 1000
events_dt$crop_mult[ events_dt$CROPDMGEXP == "M" ] <- 1000000
events_dt$crop_mult[ events_dt$CROPDMGEXP == "B" ] <- 1000000000
events_dt$crop_usd <- events_dt$CROPDMG * events_dt$crop_mult

# convert the property damage into us dollars
events_dt$property_mult <- list(0)
events_dt$property_mult[ events_dt$PROPDMGEXP == "K" ] <- 1000
events_dt$property_mult[ events_dt$PROPDMGEXP == "M" ] <- 1000000
events_dt$property_mult[ events_dt$PROPDMGEXP == "B" ] <- 1000000000
events_dt$property_usd <- events_dt$PROPDMG * events_dt$property_mult

# calculate combined damage costs
events_dt$total_usd  <- events_dt$crop_usd + events_dt$property_usd

# calculate combined health effects (death and injuries)
events_dt$health_count <- events_dt$FATALITIES + events_dt$INJURIES

# create a summary data table of each event type with important effects summed
effects <- events_dt[, lapply(.SD, sum, na.rm=TRUE), by="event_type", .SDcols=c("FATALITIES", "INJURIES", "property_usd", "crop_usd", "health_count", "total_usd") ]

# count each type of event
event_count <- as.data.frame(table(events_dt$event_type))
colnames(event_count)[1] <- "event_type"
colnames(event_count)[2] <- "events_count"
effects <- merge(effects, event_count, by="event_type")
# calculate the average effects per event
effects$avg_health_per_event <- round( effects$health_count / effects$events_count, 2 )
effects$avg_cost_per_event   <- round( effects$total_usd    / effects$events_count, 2 )
#effects
# cost per year is not useful when the number of events per year rises so much
#effects$events_per_year      <- round( effects$events_count / years_span, 2 )
#effects$health_per_year      <- round( effects$health_count / years_span, 2 )
#effects$cost_per_year        <- round( effects$total_usd    / years_span, 2 )
#effects


# find the most recent year and oldest year
max_year   = max( events_dt$year )
min_year   = min( events_dt$year )
# understand the time-span of the study
years_span = max_year - min_year



# understand frequency by year
events_in_year <- as.data.frame(table(events_dt$year))
colnames(events_in_year)[1] <- "year"
colnames(events_in_year)[2] <- "events_count"
events_in_year

# compare events_in_year to events_dt 
data_rows <- nrow( events_dt)
summed_by_year <- sum( events_in_year$events_count )


plot( events_in_year$year, events_in_year$events_count, 
      main="Weather Events over Time", 
      xlab="Year", ylab="Number of Events", pch=19)

# sort by effect on health
#health[ , crop_usd,total_usd :=NULL]
#health[ , total_usd:=NULL ]
health <- as.data.frame(effects)
health <- data.table(health)
health[ , c("property_usd", "crop_usd", "total_usd", "avg_cost_per_event"):=NULL ]
health 

health_by_deaths <- health[ order( -health$FATALITIES) ]
health_by_deaths
health_by_injuries <- health[ order( -health$INJURIES) ]
health_by_injuries
health_per_event <- health[ order( -health$avg_health_per_event) ]
health_per_event


# sort by cost
cost <- as.data.frame(effects)
cost <- data.table(cost)
cost[ , c("FATALITIES", "INJURIES", "health_count", "avg_health_per_event"):=NULL ]
cost 

cost_by_crop <- cost[ order( -cost$crop_usd) ]
cost_by_crop
cost_by_property <- cost[ order( -cost$property_usd) ]
cost_by_property
cost_per_event <- cost[ order( -cost$avg_cost_per_event) ]
cost_per_event




