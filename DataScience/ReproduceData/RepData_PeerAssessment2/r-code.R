# load helpful libraries
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
# download the file
download.file(url, download_file_path, method="curl")

# read the file
#pipe("storm-data.csv.bz2 | bunzip2" )
#raw_data <- read.table( "storm-data.csv", sep="," )
# raw_data <- read.table(bzfile("storm-data.csv.bz2"), sep=",")
raw_data <- read.table(bzfile( download_file_path ), sep=",", head=TRUE)


## START tests here!
# processing
events_dt <- data.table(raw_data)
# events are all over the place with lots of duplicates
# 
data_rows <- nrow( events_dt)
data_rows
total <- 0

# copy factors to a new character field
events_dt$event_char <- as.character( events_dt$EVTYPE )

# simplify and clean up the data
events_dt$event_char <- gsub(".*summary.*", "summary", events_dt$event_char, ignore.case=TRUE)
events_dt$event_char <- gsub(".*month.*", "summary", events_dt$event_char, ignore.case=TRUE)
events_dt$event_char <- gsub(".*week.*", "summary", events_dt$event_char, ignore.case=TRUE)
events_dt$event_char <- gsub(".*year.*", "summary", events_dt$event_char, ignore.case=TRUE)
events_dt$event_char <- gsub(".*record.*", "summary", events_dt$event_char, ignore.case=TRUE)
events_dt$event_char <- gsub(".*county.*", "summary", events_dt$event_char, ignore.case=TRUE)
events_dt$event_char <- gsub(".*southeast.*", "summary", events_dt$event_char, ignore.case=TRUE)

events_dt$event_char <- gsub(".*hyp.*", "human", events_dt$event_char, ignore.case=TRUE)
events_dt$event_char <- gsub(".*drown.*", "human", events_dt$event_char, ignore.case=TRUE)
events_dt$event_char <- gsub(".*dam.*", "human", events_dt$event_char, ignore.case=TRUE)
events_dt$event_char <- gsub(".*acc.*", "human", events_dt$event_char, ignore.case=TRUE)
events_dt$event_char <- gsub(".*mishap.*", "human", events_dt$event_char, ignore.case=TRUE)
events_dt$event_char <- gsub(".*flag.*", "human", events_dt$event_char, ignore.case=TRUE)

#events_dt$event_char <- gsub("\?", "note", events_dt$event_char, ignore.case=TRUE)
events_dt$event_char <- gsub(".*no .*", "note", events_dt$event_char, ignore.case=TRUE)
events_dt$event_char <- gsub(".*none.*", "note", events_dt$event_char, ignore.case=TRUE)
events_dt$event_char <- gsub(".*mild.*", "note", events_dt$event_char, ignore.case=TRUE)
events_dt$event_char <- gsub(".*other.*", "note", events_dt$event_char, ignore.case=TRUE)


events_dt$event_char <- gsub(".*freezing.*", "ice", events_dt$event_char, ignore.case=TRUE)
events_dt$event_char <- gsub(".*ice.*", "ice", events_dt$event_char, ignore.case=TRUE)
events_dt$event_char <- gsub(".*icy.*", "ice", events_dt$event_char, ignore.case=TRUE)
events_dt$event_char <- gsub(".*glaze.*", "ice", events_dt$event_char, ignore.case=TRUE)
events_dt$event_char <- gsub(".*tide$", "tide", events_dt$event_char, ignore.case=TRUE)
events_dt$event_char <- gsub(".*tide.*", "tide", events_dt$event_char, ignore.case=TRUE)
events_dt$event_char <- gsub("^tidal.*", "tide", events_dt$event_char, ignore.case=TRUE)
events_dt$event_char <- gsub(".*torn.*", "tornado", events_dt$event_char, ignore.case=TRUE)
events_dt$event_char <- gsub(".*funn.*", "tornado", events_dt$event_char, ignore.case=TRUE)
events_dt$event_char <- gsub(".*spout.*", "tornado", events_dt$event_char, ignore.case=TRUE)
events_dt$event_char <- gsub(".*thun.*", "thunderstorm", events_dt$event_char, ignore.case=TRUE)
events_dt$event_char <- gsub(".*tund.*", "thunderstorm", events_dt$event_char, ignore.case=TRUE)
events_dt$event_char <- gsub("^tstm.*", "thunderstorm", events_dt$event_char, ignore.case=TRUE)
events_dt$event_char <- gsub(".*tstm.*", "thunderstorm", events_dt$event_char, ignore.case=TRUE)
events_dt$event_char <- gsub(".*gustn.*", "thunderstorm", events_dt$event_char, ignore.case=TRUE)
events_dt$event_char <- gsub(".*metro.*", "thunderstorm", events_dt$event_char, ignore.case=TRUE)
events_dt$event_char <- gsub(".*light.*", "lightning", events_dt$event_char, ignore.case=TRUE)
events_dt$event_char <- gsub(".*ligtn.*", "lightning", events_dt$event_char, ignore.case=TRUE)
events_dt$event_char <- gsub(".*lign.*", "lightning", events_dt$event_char, ignore.case=TRUE)
events_dt$event_char <- gsub(".*blizzard.*", "blizzard", events_dt$event_char, ignore.case=TRUE)
events_dt$event_char <- gsub(".*hail.*", "hail", events_dt$event_char, ignore.case=TRUE)
events_dt$event_char <- gsub(".*sleet.*", "sleet", events_dt$event_char, ignore.case=TRUE)
events_dt$event_char <- gsub("avalanc.*", "avalanche", events_dt$event_char, ignore.case=TRUE)
events_dt$event_char <- gsub(".*coast.*", "coastal flood", events_dt$event_char, ignore.case=TRUE)
events_dt$event_char <- gsub(".*cstl.*", "coastal flood", events_dt$event_char, ignore.case=TRUE)
events_dt$event_char <- gsub(".*beach.*", "coastal flood", events_dt$event_char, ignore.case=TRUE)
events_dt$event_char <- gsub(".*surge.*", "coastal flood", events_dt$event_char, ignore.case=TRUE)
events_dt$event_char <- gsub(".*cool.*", "cold", events_dt$event_char, ignore.case=TRUE)
events_dt$event_char <- gsub(".*cold.*", "cold", events_dt$event_char, ignore.case=TRUE)
events_dt$event_char <- gsub(".*chill.*", "cold", events_dt$event_char, ignore.case=TRUE)
events_dt$event_char <- gsub(".*low.*", "cold", events_dt$event_char, ignore.case=TRUE)
events_dt$event_char <- gsub(".*snow.*", "snow", events_dt$event_char, ignore.case=TRUE)
events_dt$event_char <- gsub(".*fog.*", "fog", events_dt$event_char, ignore.case=TRUE)
events_dt$event_char <- gsub(".*smoke.*", "smoke", events_dt$event_char, ignore.case=TRUE)
events_dt$event_char <- gsub(".*dust.*", "dust", events_dt$event_char, ignore.case=TRUE)
events_dt$event_char <- gsub(".*dry.*", "drought", events_dt$event_char, ignore.case=TRUE)
events_dt$event_char <- gsub(".*excessive.*", "drought", events_dt$event_char, ignore.case=TRUE)
events_dt$event_char <- gsub(".*drought.*", "drought", events_dt$event_char, ignore.case=TRUE)
events_dt$event_char <- gsub(".*heat.*", "heat", events_dt$event_char, ignore.case=TRUE)
events_dt$event_char <- gsub(".*hot.*", "heat", events_dt$event_char, ignore.case=TRUE)
events_dt$event_char <- gsub(".*warm.*", "heat", events_dt$event_char, ignore.case=TRUE)
events_dt$event_char <- gsub(".*frost.*", "frost", events_dt$event_char, ignore.case=TRUE)
events_dt$event_char <- gsub(".*freeze.*", "frost", events_dt$event_char, ignore.case=TRUE)
events_dt$event_char <- gsub(".*wint.*", "winter", events_dt$event_char, ignore.case=TRUE)
events_dt$event_char <- gsub(".*fire.*", "fire", events_dt$event_char, ignore.case=TRUE)
events_dt$event_char <- gsub(".*rain.*", "rain", events_dt$event_char, ignore.case=TRUE)
events_dt$event_char <- gsub(".*mix.*", "rain", events_dt$event_char, ignore.case=TRUE)
events_dt$event_char <- gsub(".*shower.*", "rain", events_dt$event_char, ignore.case=TRUE)
events_dt$event_char <- gsub(".*precip.*", "rain", events_dt$event_char, ignore.case=TRUE)
events_dt$event_char <- gsub(".*wet.*", "rain", events_dt$event_char, ignore.case=TRUE)
events_dt$event_char <- gsub(".*hur.*", "hurricane", events_dt$event_char, ignore.case=TRUE)
events_dt$event_char <- gsub(".*typ.*", "hurricane", events_dt$event_char, ignore.case=TRUE)
events_dt$event_char <- gsub(".*floyd.*", "hurricane", events_dt$event_char, ignore.case=TRUE)
events_dt$event_char <- gsub(".*rip.*", "rip current", events_dt$event_char, ignore.case=TRUE)
events_dt$event_char <- gsub(".*depress.*", "tropical depression", events_dt$event_char, ignore.case=TRUE)
events_dt$event_char <- gsub(".*trop.*", "tropical storm", events_dt$event_char, ignore.case=TRUE)
events_dt$event_char <- gsub(".*wind.*", "wind", events_dt$event_char, ignore.case=TRUE)
events_dt$event_char <- gsub(".*turb.*", "wind", events_dt$event_char, ignore.case=TRUE)
events_dt$event_char <- gsub(".*micro.*", "wind", events_dt$event_char, ignore.case=TRUE)
events_dt$event_char <- gsub(".*wnd.*", "wind", events_dt$event_char, ignore.case=TRUE)
events_dt$event_char <- gsub(".*burst.*", "wind", events_dt$event_char, ignore.case=TRUE)
events_dt$event_char <- gsub(".*flood.*", "flood", events_dt$event_char, ignore.case=TRUE)
events_dt$event_char <- gsub(".*flooo.*", "flood", events_dt$event_char, ignore.case=TRUE)
events_dt$event_char <- gsub(".*stream.*", "flood", events_dt$event_char, ignore.case=TRUE)
events_dt$event_char <- gsub(".*water.*", "flood", events_dt$event_char, ignore.case=TRUE)
events_dt$event_char <- gsub(".*mud.*", "debris slide", events_dt$event_char, ignore.case=TRUE)
events_dt$event_char <- gsub(".*rock.*", "debris slide", events_dt$event_char, ignore.case=TRUE)
events_dt$event_char <- gsub(".*land.*", "debris slide", events_dt$event_char, ignore.case=TRUE)
events_dt$event_char <- gsub(".*tsunami.*", "tsunami", events_dt$event_char, ignore.case=TRUE)
events_dt$event_char <- gsub(".*volc.*", "volcano", events_dt$event_char, ignore.case=TRUE)
events_dt$event_char <- gsub(".*surf.*", "marine waves", events_dt$event_char, ignore.case=TRUE)
events_dt$event_char <- gsub(".*sea.*", "marine waves", events_dt$event_char, ignore.case=TRUE)
events_dt$event_char <- gsub(".*sea.*", "marine waves", events_dt$event_char, ignore.case=TRUE)
events_dt$event_char <- gsub(".*swell.*", "marine waves", events_dt$event_char, ignore.case=TRUE)
events_dt$event_char <- gsub(".*wave.*", "marine waves", events_dt$event_char, ignore.case=TRUE)
events_dt$event_char <- gsub(".*high.*", "marine waves", events_dt$event_char, ignore.case=TRUE)
events_dt$event_char <- gsub(".*seiche.*", "marine waves", events_dt$event_char, ignore.case=TRUE)
events_dt$event_char <- gsub(".*urban.*", "urban", events_dt$event_char, ignore.case=TRUE)
events_dt$event_char <- gsub(".*wall.*", "wall cloud", events_dt$event_char, ignore.case=TRUE)
events_dt$event_char <- gsub(".*vog.*", "air quality", events_dt$event_char, ignore.case=TRUE)

events_dt$event_type <- as.factor( events_dt$event_char )
levels( events_dt$event_type )


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


# create a summary data table of each event type with important effects summed
effects <- events_dt[, lapply(.SD, sum, na.rm=TRUE), by="event_type", .SDcols=c("FATALITIES", "INJURIES", "property_usd", "crop_usd") ]

# create grand totals for each effect
effects$health_count <- effects$FATALITIES + effects$INJURIES
effects$total_usd <- effects$crop_usd + effects$property_usd

# count the number of unique events for each type of event
#effects$event_count <- list()

# count each type of event
events_dt$tornado <-  grepl("tornado", events_dt$event_char, ignore.case=TRUE)
effects$events_count[ effects$event_type == "tornado" ] <- sum(events_dt$tornado)

events_dt$thunder <-  grepl("thunderstorm", events_dt$event_char, ignore.case=TRUE) 
effects$events_count[ effects$event_type == "thunderstorm" ] <- sum(events_dt$thunder)

events_dt$hurricane <-  grepl("hurricane", events_dt$event_char, ignore.case=TRUE) 
effects$events_count[ effects$event_type == "hurricane" ] <- sum(events_dt$hurricane)

events_dt$hail <-  grepl("hail", events_dt$event_char, ignore.case=TRUE)
effects$events_count[ effects$event_type == "hail" ] <- sum(events_dt$hail)

events_dt$winter <-  grepl("winter", events_dt$event_char, ignore.case=TRUE)
effects$events_count[ effects$event_type == "winter" ] <- sum(events_dt$winter)

events_dt$snow <-  grepl("snow", events_dt$event_char, ignore.case=TRUE)
effects$events_count[ effects$event_type == "snow" ] <- sum(events_dt$snow)

events_dt$ice <-  grepl("ice", events_dt$event_char, ignore.case=TRUE)
effects$events_count[ effects$event_type == "ice" ] <- sum(events_dt$ice)

events_dt$summary <-  grepl("summary", events_dt$event_char, ignore.case=TRUE)
effects$events_count[ effects$event_type == "summary" ] <- sum(events_dt$summary)

events_dt$lightning <-  grepl("lightning", events_dt$event_char, ignore.case=TRUE)
effects$events_count[ effects$event_type == "ligthning" ] <- sum(events_dt$ligthning)

events_dt$fog <-  grepl("fog", events_dt$event_char, ignore.case=TRUE)
effects$events_count[ effects$event_type == "fog" ] <- sum(events_dt$fog)

events_dt$rip <-  grepl("rip current", events_dt$event_char, ignore.case=TRUE)
effects$events_count[ effects$event_type == "rip current" ] <- sum(events_dt$rip)

events_dt$rain <-  grepl("rain", events_dt$event_char, ignore.case=TRUE)
effects$events_count[ effects$event_type == "rain" ] <- sum(events_dt$rain)

events_dt$flood <-  grepl("flood", events_dt$event_char, ignore.case=TRUE)
effects$events_count[ effects$event_type == "flood" ] <- sum(events_dt$flood)

events_dt$wind <-  grepl("wind", events_dt$event_char, ignore.case=TRUE)
effects$events_count[ effects$event_type == "wind" ] <- sum(events_dt$wind)

events_dt$heat <-  grepl("heat", events_dt$event_char, ignore.case=TRUE)
effects$events_count[ effects$event_type == "heat" ] <- sum(events_dt$heat)

events_dt$cold <-  grepl("cold", events_dt$event_char, ignore.case=TRUE)
effects$events_count[ effects$event_type == "cold" ] <- sum(events_dt$cold)

events_dt$frost <-  grepl("frost", events_dt$event_char, ignore.case=TRUE)
effects$events_count[ effects$event_type == "frost" ] <- sum(events_dt$frost)

events_dt$blizzard <-  grepl("blizzard", events_dt$event_char, ignore.case=TRUE)
effects$events_count[ effects$event_type == "blizzard" ] <- sum(events_dt$blizzard)

events_dt$tide <-  grepl("tide", events_dt$event_char, ignore.case=TRUE)
effects$events_count[ effects$event_type == "tide" ] <- sum(events_dt$tide)

events_dt$avalanche <-  grepl("avalanche", events_dt$event_char, ignore.case=TRUE)
effects$events_count[ effects$event_type == "avalanche" ] <- sum(events_dt$avalanche)

events_dt$dust <-  grepl("dust", events_dt$event_char, ignore.case=TRUE)
effects$events_count[ effects$event_type == "dust" ] <- sum(events_dt$dust)

events_dt$sleet <-  grepl("sleet", events_dt$event_char, ignore.case=TRUE)
effects$events_count[ effects$event_type == "sleet" ] <- sum(events_dt$sleet)

events_dt$surf <-  grepl("marine waves", events_dt$event_char, ignore.case=TRUE)
effects$events_count[ effects$event_type == "marine waves" ] <- sum(events_dt$surf)

events_dt$urban <-  grepl("urban", events_dt$event_char, ignore.case=TRUE)
effects$events_count[ effects$event_type == "urban" ] <- sum(events_dt$urban)

events_dt$urban <-  grepl("lightning", events_dt$event_char, ignore.case=TRUE)
effects$events_count[ effects$event_type == "lightning" ] <- sum(events_dt$urban)

events_dt$urban <-  grepl("wall cloud", events_dt$event_char, ignore.case=TRUE)
effects$events_count[ effects$event_type == "wall cloud" ] <- sum(events_dt$urban)

events_dt$urban <-  grepl("human", events_dt$event_char, ignore.case=TRUE)
effects$events_count[ effects$event_type == "human" ] <- sum(events_dt$urban)

events_dt$urban <-  grepl("drought", events_dt$event_char, ignore.case=TRUE)
effects$events_count[ effects$event_type == "drought" ] <- sum(events_dt$urban)

events_dt$urban <-  grepl("fire", events_dt$event_char, ignore.case=TRUE)
effects$events_count[ effects$event_type == "fire" ] <- sum(events_dt$urban)

events_dt$urban <-  grepl("debris slide", events_dt$event_char, ignore.case=TRUE)
effects$events_count[ effects$event_type == "debris slide" ] <- sum(events_dt$urban)

events_dt$urban <-  grepl("tropical storm", events_dt$event_char, ignore.case=TRUE)
effects$events_count[ effects$event_type == "tropical storm" ] <- sum(events_dt$urban)

events_dt$urban <-  grepl("note", events_dt$event_char, ignore.case=TRUE)
effects$events_count[ effects$event_type == "note" ] <- sum(events_dt$urban)

events_dt$urban <-  grepl("volcano", events_dt$event_char, ignore.case=TRUE)
effects$events_count[ effects$event_type == "volcano" ] <- sum(events_dt$urban)

events_dt$urban <-  grepl("air quality", events_dt$event_char, ignore.case=TRUE)
effects$events_count[ effects$event_type == "air quality" ] <- sum(events_dt$urban)

events_dt$urban <-  grepl("smoke", events_dt$event_char, ignore.case=TRUE)
effects$events_count[ effects$event_type == "smoke" ] <- sum(events_dt$urban)

events_dt$urban <-  grepl("tsunami", events_dt$event_char, ignore.case=TRUE)
effects$events_count[ effects$event_type == "tsunami" ] <- sum(events_dt$urban)
# see the data summary
effects

# sort by effect on health
#health_sort <- effects[ order(effects[,2], effects[,3]), ]
health <- effects
health <- health[ order( -health$FALALITIES) ]
health

# sort by cost
cost <- effects
cost <- cost[ order( -cost$total_usd) ]
cost

