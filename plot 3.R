NEI <- readRDS("summarySCC_PM25.rds")
library(dplyr)
library(ggplot2)
library(directlabels)
nei <- tbl_df(NEI)

# Calculate total emission from different sources in every year in Baltimore City, MD
yearlyBaltEmissions <- group_by(nei, year, type) %>%
    filter(fips == "24510") %>%
    summarise(totBaltEmissions = sum(Emissions))

# Plot using ggplot2 plotting system and export the data to PNG device
png(file = "plot 3.png", bg = "transparent")
ggplot(yearlyBaltEmissions, aes(x=year, y=totBaltEmissions, colour=type)) +
    geom_line(aes(group=type),size=2) + geom_point(size=4) + theme(legend.title=element_blank()) + labs(x='Year') + 
    labs(y=expression('Total emissions in tons of '*'PM'[2.5]*' in Batlimore City, MD')) + 
    theme(legend.position="bottom") + 
    geom_text(aes(label=round(totBaltEmissions,0)), size = 5, 
              position=position_jitter(width=0, heigh=50), show_guide = FALSE, col='black')
dev.off()
