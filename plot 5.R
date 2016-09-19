NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")
library(dplyr)
library(ggplot2)
nei <- tbl_df(NEI)
scc <- tbl_df(SCC)

# Find SCCs inside the Source Classification Code table which correspond to motor vehicle sources
vehicleSCCs <- unique(scc$SCC[grepl('vehicles',scc$EI.Sector, ignore.case=TRUE)])

# Filter NEI data table to keep only the Baltimore City data
neiBalt <-filter(nei, fips == "24510")

# Find rows with matching vehicle SCCs inside the Baltimore City NEI data table
vehicleSCCInd <- which(neiBalt$SCC %in% vehicleSCCs)

# Filter the Baltimore NEI data table to select only the rows matching motor vehicle SCCs
vehicleNEI <- neiBalt[vehicleSCCInd,] 

# Compute the required sums for motor vehicle-related sources
yearlyVehicleEmissions <- group_by(vehicleNEI, year) %>%
    summarise(totEmissions = sum(Emissions))

# Plot using base plotting system and export the data to PNG device
png(file = "plot 5.png", bg = "transparent")
barplot(yearlyVehicleEmissions$totEmissions, names.arg = yearlyVehicleEmissions$year, col = 'red', 
        border = FALSE, ylab=expression('Total '*'PM'[2.5]*' emissions in tons from motor vehicles in Baltimore City, MD'))
dev.off()