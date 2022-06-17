setwd("D:/")

mdata <- read.table("monkey_cases.txt", sep = "\t")
mdata <- cbind(days = as.numeric(as.Date(mdata[,1]) - as.Date(mdata[1,1])), mdata)
colnames(mdata) <- c("days", "date", "cases")

m1 <- lm(cases ~ days, data = mdata)
m2 <- lm(cases ~ I(days^2), data = mdata)
m3 <- lm(cases ~ days + I(days^2), data = mdata)
m4 <- lm(cases ~ days * I(exp(1)^days), data = mdata)

AIC(m1,m2,m3,m4)

m1p <- predict(m1)
m2p <- predict(m2)
m3p <- predict(m3)
m4p <- predict(m4)

plot(mdata[,"days"], mdata[,"cases"], pch = 19, las=2, xaxt='n', xlab="", ylab="# Cases")
axis(1, at = mdata[,"days"], mdata[,"date"], las=2, cex.axis=0.7)
points(m1p, t = 'l', col = "orange")
points(m2p, t = 'l', col = "gold")
points(m3p, t = 'l', col = "green")
points(m4p, t = 'l', col = "red")
legend("topleft", c("cases ~ days", "cases ~ I(days^2)", "cases ~ days + I(days^2)", "cases ~ days * I(exp(1)^days)"), lwd=1, col = c("orange", "gold", "green", "red"))