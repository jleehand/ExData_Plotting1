library(data.table) 
library(lubridate)

# Downloading all of the data and unzipping if it isn't already present.
dl_url = "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
filename = "household_power_consumption.zip"

if (!file.exists(filename)) {
    download.file(dl_url, filename, method = "curl")
}
if (!file.exists(gsub(".zip", "", filename))) {
    unzip(filename)
}

# Joins the Date and Time columns for plotting.
all_data <- fread("household_power_consumption.txt")
all_data$DateTime <- dmy_hms(paste(all_data$Date, all_data$Time))
all_data$Date <- dmy(all_data$Date)
all_data$Time <- hms(all_data$Time)

data_dates <- lubridate::interval(ymd("2007-02-01"), ymd("2007-02-02"))
data <- all_data[all_data$Date %within% data_dates, ]

# Create Plot
png(file = "plot4.png", width = 480, height = 480, units = "px")
par(mfrow = c(2,2))
plot(data$DateTime, data$Global_active_power, type = "l", 
    ylab = "Global Active Power", xlab = "")

plot(data$DateTime, data$Voltage, type = "l", ylab = "Voltage", xlab = "datetime")

plot(data$DateTime, data$Sub_metering_1, type = "l", ylab = "Energy sub metering", xlab = "")
lines(data$DateTime, data$Sub_metering_2, col = "red")
lines(data$DateTime, data$Sub_metering_3, col = "blue")
legend("topright", legend = c("Sub_metering_1","Sub_metering_2","Sub_metering_3"), col = c("black", "red", "blue"), lty = "solid", bty = "n")

plot(data$DateTime, data$Global_reactive_power, type = "l", xlab = "datetime", ylab = "Global_reactive_power")
dev.off()