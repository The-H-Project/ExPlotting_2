# Coursera Exploratory Data Analysis
# Course Project 2 Plot 3

# Goal: Of the four types of sources indicated by the type (point, nonpoint, onroad, nonroad) variable, 
# which of these four sources have seen decreases in emissions from 1999–2008 for Baltimore City? 
# Which have seen increases in emissions from 1999–2008? 
# Use the ggplot2 plotting system to make a plot answer this question.

# Load required packages. Requires data.table 1.9.6 
library(data.table)
library(ggplot2)
#
# Read the data file, and convert it to a data table.
NEIdt <- data.table(readRDS('../summarySCC_PM25.rds'))

# Summarize the PM2.5 emissions by year, rename the summed column, and convert Type to a factor.
# fips==25410 for Baltimore City, MD.
Graphdt <- NEIdt[fips=='24510',sum(Emissions), by=c('year', 'type')]
names(Graphdt)[3] <- 'TotalEmissions'
Graphdt$type <- as.factor(Graphdt$type)

# Create the plot using qplot.
plot3 <- qplot(year, TotalEmissions, data=Graphdt, color=type, main='Emissions by Type 1999 to 2008', 
               facets= . ~ type, geom='line', size=I(2))

# Save the plot to a png file, but make it larger so the x-axis labels are visible.
png(filename='plot3.png', bg='transparent', width=960, height=960)
print(plot3)

# Close the plot device.
dev.off()
