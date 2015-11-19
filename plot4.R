# Coursera Exploratory Data Analysis
# Course Project 2 Plot 4

# Goal: Across the United States, how have emissions from coal combustion-related sources 
# changed from 1999 to 2008?

# Load required packages. Requires data.table 1.9.6 
library(data.table)
library(ggplot2)
#
# Read the data files, and convert it to a data table.
NEIdt <- data.table(readRDS('../summarySCC_PM25.rds'))
SCCdt <- data.table(readRDS('../Source_Classification_Code.rds'))

# Find the pollution source codes for coal combustion-related sources.
SCCsubset <- SCCdt[EI.Sector %like% 'Coal$']

# Subset the full NEI dataset for coal combustion-related sources, only.
NEIsubset <- NEIdt[SCC %in% SCCsubset$SCC]

# Sum the emissions.
Graphdt <- NEIsubset[,sum(Emissions), by=year]
names(Graphdt)[2] <- 'TotalEmissions'

# Get rid of the original datasets to save memory.
rm(NEIdt, SCCdt, NEIsubset, SCCsubset)

# Reduce the y-axis scale.
Graphdt[,TotalEmissions := TotalEmissions / 1000]

# Create the plot.
plot4 <- ggplot(data=Graphdt, aes(x=year, y=TotalEmissions))
plot4 <- plot4 + geom_line(size=1)
plot4 <- plot4 + ggtitle('Total Coal Emissions 1999 to 2008') + 
     ylab('Total Emissions (in thousands of tons)') + 
     theme(plot.title=element_text(face='bold', size=18)) +
     theme(axis.title.y=element_text(size=16)) +
     theme(axis.text.y=element_text(size=14))

# Save the plot to a png file, but make it larger so the x-axis labels are visible.
png(filename='plot4.png', bg='transparent', width=960, height=960)
print(plot4)

# Close the plot device.
dev.off()

