# Coursera Exploratory Data Analysis
# Course Project 2 Plot 6

# Goal: Compare from emissions from motor vehicle sources in Baltimore City with emissions
# from motor vehicle sources in Los Angeles County. Which ciy has seen greater changes
# over time in motor vehicle emissions?

# Load required packages. Requires data.table 1.9.6 
library(data.table)
library(ggplot2)
library(grid)
#
# Read the data files, and convert it to a data table.
NEIdt <- data.table(readRDS('../summarySCC_PM25.rds'))
SCCdt <- data.table(readRDS('../Source_Classification_Code.rds'))

# Build the SCC subset for motor vehicle sources.
SCCsubset <- SCCdt[Data.Category %like% 'Onroad']

# Get rid of 'Not Used' SCC codes.
SCCsubset <- SCCsubset[-grep('^NOT USED', SCCsubset$SCC.Level.Three),]

# Subset the full NEI dataset for identified SCC codes for Baltimore City and Los Angeles County..
BCNEIsubset <- NEIdt[SCC %in% SCCsubset$SCC][fips=='24510'] # Baltimore
LANEIsubset <- NEIdt[SCC %in% SCCsubset$SCC][fips=='06037'] # Los Angeles

# Summarize the emissions while adding a County source column, 
# and combine the two tables for a ggplot dataset.
BCGraphdt <- BCNEIsubset[,sum(Emissions), by=year][,County:='Baltimore City']
LAGraphdt <- LANEIsubset[,sum(Emissions), by=year][,County:='Los Angeles County']
Graphdt <- rbind(BCGraphdt, LAGraphdt)
Graphdt$County <- as.factor(Graphdt$County)
names(Graphdt)[2] <- 'TotalEmissions'

# Get rid of the original datasets to save memory.
rm(NEIdt, SCCdt, BCNEIsubset, LANEIsubset, SCCsubset, BCGraphdt, LAGraphdt)

# Create the plot.
# Place the legend in the middle of the plot because there's nothing there.
plot6 <- ggplot(data=Graphdt, aes(x=year, y=TotalEmissions, Group=County, color=County)) +
         geom_line(size=2) +
         ggtitle('Total Vehicular PM2.5 Emissions 1999 to 2008:\n Baltimore City vs Los Angeles County') + 
         ylab('Total Emissions (in tons)') +
         theme(plot.title=element_text(face='bold', size=15), 
               axis.title.y=element_text(size=16), 
               axis.text.y=element_text(size=14),
               legend.position=c(0.5,0.5),
               legend.title=element_text(size=15),
               legend.text=element_text(size=14),
               legend.key.size=unit(18,'points'))

# Save the plot to a png file.
png(filename='plot6.png', bg='transparent')
print(plot6)

# Close the plot device.
dev.off()

