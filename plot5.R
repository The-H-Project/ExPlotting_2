# Coursera Exploratory Data Analysis
# Course Project 2 Plot 5

# Question: How have emissions from motor vehicle sources changed from 1999 to 2008
# in Baltimore City?

# Load required packages. Requires data.table 1.9.6 
library(data.table)
library(ggplot2)
#
# Read the data files, and convert it to a data table.
NEIdt <- data.table(readRDS('../summarySCC_PM25.rds'))
SCCdt <- data.table(readRDS('../Source_Classification_Code.rds'))

# Build the SCC subset for motor vehicle sources.
SCCsubset <- SCCdt[Data.Category %like% 'Onroad']

# Get rid of 'Not Used' SCC codes.
SCCsubset <- SCCsubset[-grep('^NOT USED', SCCsubset$SCC.Level.Three),]

# Subset the full NEI dataset for identified SCC codes, but for Baltimore City only.
NEIsubset <- NEIdt[SCC %in% SCCsubset$SCC][fips=='24510']

# Sum the emissions.
Graphdt <- NEIsubset[,sum(Emissions), by=year]
names(Graphdt)[2] <- 'TotalEmissions'

# Get rid of the original datasets to save memory.
rm(NEIdt, SCCdt, NEIsubset, SCCsubset)

# Create the plot.
plot5 <- ggplot(data=Graphdt, aes(x=year, y=TotalEmissions)) + geom_line(size=1) +
         ggtitle('Total Vehicular PM2.5 Emissions in Baltimore City 1999 to 2008') + 
         ylab('Total Emissions (in tons)') +
         theme(plot.title=element_text(family='Times', face='bold', size=18),
               axis.title.y=element_text(size=16), 
               axis.text.y=element_text(size=14))

# Save the plot to a png file, but make it larger so the x-axis labels are visible.
png(filename='plot5.png', bg='transparent', width=960, height=960)
print(plot5)

# Close the plot device.
dev.off()

