library('R.matlab')
library('tidyverse')
library('patchwork')
library('plotly')
library('shiny')
library('rsconnect')

#Read in data and convert to data frames
ConcData <- readMat('build_model_data/SingleDoseComparisonConc.mat')
ConcData <- as.data.frame(ConcData)

col_names <- c('Conc', 'Time')
names(ConcData) <- col_names

#Create theme for ggplot
theme1 <- theme_classic() +
  theme(text = element_text(size = 18),
        axis.title.x = element_text(margin = margin(10, 0, 0, 0)),
        axis.title.y = element_text(margin = margin(0, 10, 0, 0)),
        axis.text.x = element_text(margin = margin(5, 0, 0, 0)),
        axis.text.y = element_text(margin = margin(0, 5, 0, 0)),
        legend.text = element_text(size=12),
        plot.title.position = "plot")

#Plot data using ggplot
Conc_Plot <- ggplot(data = NULL) +
  geom_line(data = ConcData, aes(x = Time, y = Conc), color = 'blue1') +
  labs(title = 'A') +
  scale_x_continuous(name = 'Time (h)') +
  scale_y_continuous(limits=c(0,50), name = '[D] (mg/L)') +
  theme1 

plot(Conc_Plot)

ggsave(filename = 'Concentration_comparison.png', plot = Conc_Plot, path = 'build_model_data/', width = 6, height = 6)