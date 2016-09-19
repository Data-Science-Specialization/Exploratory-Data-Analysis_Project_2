NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")
library(dplyr)
library(ggplot2)
nei <- tbl_df(NEI)
scc <- tbl_df(SCC)

# Find SCCs inside the Source Classification Code table which correspond to coal fuel combustion
coalCombSCCs <- unique(scc$SCC[grepl('coal',scc$EI.Sector, ignore.case=TRUE) & 
                  grepl('fuel comb',scc$EI.Sector, ignore.case=TRUE)])

# Find rows with matching SCCs inside the NEI data table
coalCombSCCInd <- which(nei$SCC %in% coalCombSCCs)

# Filter the NEI data table to select only the rows matchign Coal Fuel Comb SCCs
coalCombNEI <- nei[coalCombSCCInd,] 

# Computed the required sums for coal combustion-related sources
yearlyCoalEmissions <- group_by(coalCombNEI, year) %>%
    summarise(totKiloEmissions = sum(Emissions)/1000)

# Plot using base plotting system and export the data to PNG device
png(file = "plot 4.png", bg = "transparent")
barplot(yearlyCoalEmissions$totKiloEmissions, names.arg = yearlyCoalEmissions$year, col = 'red', 
        border = FALSE, ylab=expression('Total '*'PM'[2.5]*' emissions from coal combustion in thousands of tons'))
dev.off()