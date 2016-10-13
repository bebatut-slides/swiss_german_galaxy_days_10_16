training_stats = read.csv("data/training_stats.csv", sep = ";", h = T)

# Manipulate the date to extract number of workshops per month
date = as.factor(paste(data$year, data$month, "1", sep="/"))
seq_date = seq(as.Date(date[length(date)]), as.Date(date[1]), by="month")

tmp_ws_stat_per_month = summary(date)
names(tmp_ws_stat_per_month) = as.Date(names(tmp_ws_stat_per_month))

ws_stat_per_month = rep(0, length(seq_date))
names(ws_stat_per_month) = seq_date
for(t in names(tmp_ws_stat_per_month)){
    ws_stat_per_month[t] = tmp_ws_stat_per_month[t]
}

png("results/workshop_per_month.png", width = 560, height = 480)
par(mar=c(7,3,1,1), pty = "m", bty = "l")
plot(ws_stat_per_month, type = "l", ylab = "", xlab = "", col = "blue4", xaxt = "n")
axis(1, at=seq(1, length(ws_stat_per_month)),labels = FALSE)

to_label = seq(1, length(ws_stat_per_month), by = 4)
labels = format(as.Date(names(ws_stat_per_month)[to_label]), "%B %Y")
text(to_label + 1.5, par("usr")[3] - .4,  labels = labels, srt = 45, pos = 2, xpd = TRUE)
dev.off()

# Extract cities and number of workshop per cities
cities = paste(data$city, data$country, sep=", ")
