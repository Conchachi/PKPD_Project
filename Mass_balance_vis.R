library('R.matlab')
library('tidyverse')
library('patchwork')
library('plotly')
library('shiny')
library('rsconnect')

#Read in data and convert to data frames
MassBal_Single <- readMat('build_model_data/MassBal_Single.mat')
MassBal_Single <- as.data.frame(MassBal_Single)

MassBal_Rep <- readMat('build_model_data/MassBal_Rep.mat')
MassBal_Rep <- as.data.frame(MassBal_Rep)

col_names <- c('Time', 'Mass_Bal')
names(MassBal_Single) <- col_names
names(MassBal_Rep) <- col_names

#Create theme for ggplot
theme1 <- theme_classic() +
  theme(text = element_text(size = 28),
        axis.title.x = element_text(margin = margin(10, 0, 0, 0)),
        axis.title.y = element_text(margin = margin(0, 10, 0, 0)),
        axis.text.x = element_text(margin = margin(5, 0, 0, 0)),
        axis.text.y = element_text(margin = margin(0, 5, 0, 0)),
        legend.text = element_text(size=12),
        legend.box.background = element_rect(colour = "black"),
        plot.title.position = "plot")

#Plot data using ggplot
MassBal_Single_Plot <- ggplot(data = NULL) +
  geom_line(data = MassBal_Single, aes(x = Time, y = Mass_Bal), color = 'blue1') +
  labs(title = 'A') +
  scale_x_continuous(name = 'Time (h)') +
  scale_y_continuous(name = 'Mass Balance (mg/L)') +
  theme1 

#Plot data using ggplot
MassBal_Rep_Plot <- ggplot(data = NULL) +
  geom_line(data = MassBal_Rep, aes(x = Time, y = Mass_Bal), color = 'blue1') +
  labs(title = 'B') +
  scale_x_continuous(name = 'Time (h)') +
  scale_y_continuous(name = 'Mass Balance (mg/L)') +
  theme1 

print(MassBal_Single_Plot)
print(MassBal_Rep_Plot)

ggsave(filename = 'MassBal_Single_Plot.png', plot = MassBal_Single_Plot, path = 'build_model_data/', width = 8.5, height = 6)
ggsave(filename = 'MassBal_Rep_Plot.png', plot = MassBal_Rep_Plot, path = 'build_model_data/', width = 9, height = 6)


