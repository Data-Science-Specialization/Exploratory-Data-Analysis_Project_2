NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")
library(dplyr)
library(ggplot2)
nei <- tbl_df(NEI)
scc <- tbl_df(SCC)

# Find SCCs inside the Source Classification Code table which correspond to motor vehicle sources
vehicleSCCs <- unique(scc$SCC[grepl('vehicles',scc$EI.Sector, ignore.case=TRUE)])

# Filter NEI data table to keep only the Baltimore City and Los Angeles County data
neiBaltLAC <-filter(nei, fips == "24510" | fips == "06037")

# Find rows with matching vehicle SCCs inside the Baltimore City and Los Angeles County NEI data table
vehicleSCCInd <- which(neiBaltLAC$SCC %in% vehicleSCCs)

# Filter the Balt+LAC NEI data table to select only the rows matching motor vehicle SCCs
vehicleNEI <- neiBaltLAC[vehicleSCCInd,] 

# Compute the required sums for motor vehicle-related sources
yearlyVehicleEmissions <- group_by(vehicleNEI, year, fips) %>%
    summarise(totEmissions = sum(Emissions)) %>%
    mutate(fips = ifelse(fips == '06037', 'Los Angeles County, CA', 'Baltimore City, MD')) %>% 
    rename(County = fips)
    
# Plot using ggplot2 plotting system and export the data to PNG device
png(file = "plot 6.png", bg = "transparent")
ggplot(yearlyVehicleEmissions, aes(x=year, y=totEmissions, color=County, group=County)) + 
    geom_line(size=2) + geom_point(size=4) + labs(x='Year') + 
    labs(y=expression('Total emissions in tons of '*'PM'[2.5]*' from motor vehicles')) + 
    theme(legend.position="bottom") + 
    geom_text(aes(label=round(totEmissions,0)),size = 5,vjust=1.5, show_guide = FALSE) +
    coord_cartesian(ylim = c(-500, 5000)) 
dev.off()