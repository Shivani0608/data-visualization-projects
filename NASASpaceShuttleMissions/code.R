#################################################
# Libraries
#################################################
library(ggplot2)
library(reshape2)
library(grid)

#################################################
# Space Shuttle Launch Dates
# source: https://en.wikipedia.org/wiki/List_of_Space_Shuttle_missions#Launches_and_orbital_flights
#################################################

# read and clean up data
shuttleDatesData = read.csv("nasa-shuttle-mission-dates.csv")
shuttleDatesData$Date = as.Date(shuttleDatesData$Date, format="%d-%b-%y")
shuttleDatesData$Shuttle = factor(shuttleDatesData$Shuttle, levels=c("Columbia", "Challenger", "Discovery", "Atlantis", "Endeavour"))

# create plot
g1 = qplot(shuttleDatesData$Date, shuttleDatesData$Shuttle, color=shuttleDatesData$Shuttle, size=I(2)) +
  labs(x="", y="Shuttle Name", title="NASA Space Shuttle Launches") +
  scale_x_date(date_breaks="2 year", date_labels="%Y",
               limits=c(min=as.Date("01-Jan-81", format="%d-%b-%y"), max=as.Date("31-Dec-11", format="%d-%b-%y"))) +
  theme_bw() + theme(legend.position="none", axis.title.y=element_text(margin=margin(0,25,0,0)))
g1

#################################################
# NASA Budget
# source: https://en.wikipedia.org/wiki/Budget_of_NASA
#################################################

# read and clean up data
nasaBudget = read.csv("nasa-budget.csv")
nasaBudget$Year = as.Date(paste(as.character(nasaBudget$Year), "-03-01", sep=""), format="%Y-%m-%d")
nasaBudget$Percent.of.Budget = NULL
nasaBudgetMelt = melt(nasaBudget, id.var="Year")

# create plot
g2 = ggplot(data=nasaBudgetMelt, aes(x=nasaBudgetMelt$Year, y=nasaBudgetMelt$value)) + 
  geom_line(aes(color=nasaBudgetMelt$variable)) + 
  geom_point(aes(color=nasaBudgetMelt$variable), size=2) +
  labs(x="Year", y="Dollars (M)", title="NASA's Annual Budget") +
  scale_x_date(date_breaks="2 year", date_labels="%Y",
               limits=c(min=as.Date("01-Jan-81", format="%d-%b-%y"),max=as.Date("01-Mar-12", format="%d-%b-%y"))) + 
  theme_bw() + theme(axis.title.y=element_text(margin=margin(0,25,0,0)), legend.position="bottom") +
  scale_color_manual(name="Budget", values=c("turquoise", "darkblue") , labels=c("Nominal Dollars", "2014 Constant Dollars"))
g2

#################################################
# Combine Plots
#################################################
grid.newpage()
grid.draw(rbind(ggplotGrob(g1), ggplotGrob(g2), size="last"))
