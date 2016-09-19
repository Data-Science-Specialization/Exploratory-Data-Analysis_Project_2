NEI <- readRDS("summarySCC_PM25.rds")
library(dplyr)
nei <- tbl_df(NEI)

# Calculate total emissions from all sources in a given year
yearlyEmissions <- group_by(nei, year) %>%
    summarise(totKiloEmissions = sum(Emissions)/1000)

# Plot using base plotting system and export the data to PNG device
png(file = "plot 1.png", bg = "transparent")
barplot(yearlyEmissions$totKiloEmissions, names.arg = yearlyEmissions$year, col = 'red', 
        border = FALSE, ylab=expression('Total emissions in thousands of tons of '*'PM'[2.5]))
dev.off()