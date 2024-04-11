################## DOE project ####################

# Plot the graph of historical prices
# https://www.nasdaqomxnordic.com/indexes/historical_prices?Instrument=SE0000337842
price <- read.table("OMXS30reverse-1986-10-31-2015-10-30.csv", 
                   header = F, fill=T, sep = ",")
head(price)
# data$Closing_price
plot(price$V2, ylab = "Closing price", main = "OMXS30 between 1986 and 2015")

###################### ANOVA #########################

Data <- read.table("ABlist.csv",
                         header =F, fill=T, sep=",")
names(Data) <- c("Year", "Month", "Day", "Price", "Return", "Period")
head(Data)
attach(Data)

PriceA <- Price[(175:348)]
PriceB <- Price[((1:174))]
ReturnA <- Return[(175:348)]
ReturnB <- Return[(1:174)]

# plot the prices A vs B
plot(PriceA, col = "blue", pch=16, main = "Prices A vs B, 1986 - 2015 monthly")
points(PriceB, col = "darkgreen", pch = 16)
legend("topleft", c("A: Nov - April", "B: May - Oct"), 
       col = c("blue", "darkgreen"), pch = c(16, 16)) #lty = 1:2)

# plot the returns A vs B
plot(ReturnA, col = "blue", pch=16, main = "Percentage return A vs B, 1986 - 2015 monthly")
points(ReturnB, col = "darkgreen", pch = 16)
legend("topleft", c("A: Nov - April", "B: May - Oct"), 
       col = c("blue", "darkgreen"), pch = c(16, 16)) #lty = 1:2)


# ANOVA
result <- aov(Return ~ Period, Data)
summary(result)
#              Df Sum Sq Mean Sq F value Pr(>F)   
# Period        1    340   339.8   8.445 0.0039 **
# Residuals   346  13919    40.2                  
# ---
# Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

# we see that the probability that F_0 > F is small. We reject that A and B have the s
# same mean. 
# F test just to see
(340/1)/(13919/(2*348 - 2)) # 16.95237
qf(.95, df1=1, df2=346) # 3.868475
# 16.95237 > 3.868475 so we reject the null hypothesis. 

#detach(Data)

######################## Checking the assumptions ##############################

# additivity

SSPeriodnError <- 340 + 13919 # from the summary of aov
GrandAvg <- (sum(ReturnA) + sum(ReturnB))/(length(ReturnA) + length(ReturnB))
SS_T <- sum((ReturnA - GrandAvg)**2) + sum((ReturnB - GrandAvg)**2) # 14259.19

fit <- lm(Return ~ Period, Data)
Residuals <- fit$residuals
summary(fit)
plot(Period, Residuals, main = "Residuals against A respectiv eB") ### observe that it looks about the same as the plot of residuals

#### random? around zero?
plot(Residuals, ylab ="Residuals")
abline(h = 0)

#### Normality?
hist(Residuals)
qqnorm(Residuals)
qqline(Residuals)

##### independence? Autocorrelation
acf(Residuals) # Seems fine

##### constant variance?
# dotplot of return A vs B

#bartlett.test(Return ~ Period) 

require(ggplot2)
ggplot(fit, aes(Return, Period, colour = Period)) + geom_point()

# plot(Period, Residuals)
plot(result)

sum(ReturnA)/174 # 1.889949
sum(ReturnB)/174 # -0.08621389

# http://homepages.inf.ed.ac.uk/bwebb/statistics/ANOVA_in_R.pdf
