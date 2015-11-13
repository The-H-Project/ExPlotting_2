# Coursera Exploratory Data Analysis
# Course Project 2 Plot 3
# Goal: Show the total PM2.5 emissions by Type for the years 1999, 2002, 2005, and 2008
# for Baltimore City, MD.
#
# Load required packages. Requires data.table 1.9.6 
library(data.table)
library(ggplot2)
#
# Read the data file, and convert it to a data table.
NEIdt <- data.table(readRDS('../summarySCC_PM25.rds'))

# Summarize the PM2.5 emissions by year, and rename the summed column. fips==25410 for Baltimore City, MD.
Graphdt <- NEIdt[fips=='24510',sum(Emissions), by=c('year', 'type')]
names(Graphdt)[3] <- 'TotalEmissions'

# Data-cast (widen and shorten) the table by pollution type.
Graphdt <- dcast.data.table(Graphdt, year ~ type, fun.aggregate = sum, value.var='TotalEmissions')

# Open the png plot device.
# png(filename='plot2.png', bg='transparent')

# Create the plot.
plot(Graphdt$year,Graphdt$TotalEmissions, type='b', main='Total Baltimore City PM2.5 Emissions 1999 to 2008', xlab='Year', ylab='Emissions', yaxs='r', xaxs='r', cex.axis=0.75)

# Close the plot device.
# dev.off()