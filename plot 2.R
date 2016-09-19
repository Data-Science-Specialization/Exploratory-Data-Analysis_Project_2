NEI <- readRDS("summarySCC_PM25.rds")
library(dplyr)
nei <- tbl_df(NEI)

# Calculate total emissions from all sources in every year in Baltimore City, MD
yearlyBaltEmissions <- group_by(nei, year) %>%
    filter(fips == "24510") %>%
    summarise(totBaltEmissions = sum(Emissions))

# Plot using base plotting system and export the data to PNG device
png(file = "plot 2.png", bg = "transparent")
barplot(yearlyBaltEmissions$totBaltEmissions, names.arg = yearlyBaltEmissions$year, col = 'red', 
        border = FALSE, ylab=expression('Total emissions in tons of '*'PM'[2.5]*' in Batlimore City, MD'))
dev.off()