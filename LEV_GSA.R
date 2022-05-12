# Final Project - LEV Global Sensitivity Analysis
# Outputs 3 heatmaps: C_trough, E_trough_tonic, and E_trough_clonic

# Load necessary packages
library("R.matlab")
library("tidyverse")
library("patchwork")
library("plotly")
library("shiny")
library("ggplot2")
library("viridis")

# set theme for all plots
theme1 <- theme_classic(base_size = 30) +
  theme(text = element_text(),
        plot.title = element_text(hjust = 0.075),
        axis.text.x = element_text(size = 30),
        axis.text.y = element_text(size = 26),
        legend.position  = "bottom",
        legend.key.width = unit(2, 'cm'),
        legend.text = element_text(angle=45),
        plot.title.position = "plot")

# Load Data 
kCL <- readMat('sens_analysis_data/kCL_GSA.mat')
kCL <- as.data.frame(kCL)
names(kCL) <- c('kCL')

TimeLen <- readMat('sens_analysis_data/TimeLen_GSA.mat')
TimeLen <- as.data.frame(TimeLen)
TimeLen <- t(TimeLen)
TimeLen <- as.data.frame(TimeLen)
names(TimeLen) <- c('TimeLen')

Ctrough <- readMat('sens_analysis_data/Ctrough_GSA.mat')
Ctrough <- as.data.frame(Ctrough)
Ctrough <- Ctrough[c(1:24)]

kCL = round(kCL,2)

# Labels 
df <- cbind(TimeLen, Ctrough)
df <- as.data.frame(df)
names(df) <- c('TimeLen', kCL)

# Reformat data so all of the output is in one column
df <- pivot_longer(df, !TimeLen, names_to = 'kCL', values_to = 'df')

# First plot, for C_trough

Ctrough_plot <- ggplot(data = df, aes(x = as.numeric(kCL), y = TimeLen, fill = df)) +
  geom_tile() +
  labs(title = 'A') +
  xlab('kCL (hr-1)') +
  ylab('Time between Doses (h)') +
  labs(fill='Minimum Central\nCompartment\nConcentration (mg/L)') +
  scale_fill_viridis(discrete = FALSE) +
  theme1

ggsave(filename = 'global_Ctrough.png', plot = Ctrough_plot, path = 'sens_analysis_data/',
       width = 12, height = 8)
plot(Ctrough_plot)


# Repeat for E_trough Tonic
################################################################################

ETonic <- readMat('sens_analysis_data/EtroughTONIC_GSA.mat')
ETonic <- as.data.frame(ETonic)
ETonic <- ETonic[c(1:24)]

kCL = round(kCL,2)

# Labels 
df1 <- cbind(TimeLen, ETonic)
df1 <- as.data.frame(df1)
names(df1) <- c('TimeLen', kCL)

# Reformat data so all of the output is in one column
df1 <- pivot_longer(df1, !TimeLen, names_to = 'kCL', values_to = 'df1')

ETonic_plot <- ggplot(data = df1, aes(x = as.numeric(kCL), y = TimeLen, fill = df1)) +
  geom_tile() +
  labs(title = 'B') +
  xlab('kCL (hr-1)') +
  ylab('Time between Doses (h)') +
  labs(fill='Minimum\nTonic Seizure\nProtection (%)') +
  scale_fill_viridis(discrete = FALSE) +
  theme1 

ggsave(filename = 'global_Etrough_Tonic.png', plot = ETonic_plot, path = 'sens_analysis_data/',
       width = 12, height = 8)

plot(ETonic_plot)


# Repeat for E_trough Clonic
################################################################################

EClonic <- readMat('sens_analysis_data/EtroughCLONIC_GSA.mat')
EClonic <- as.data.frame(EClonic)

kCL = round(kCL,2)


EClonic <- readMat('sens_analysis_data/EtroughCLONIC_GSA.mat')
EClonic <- as.data.frame(EClonic)
EClonic <- EClonic[c(1:24)]

kCL = round(kCL,2)

# Labels 
df3 <- cbind(TimeLen, ETonic)
df3 <- as.data.frame(df3)
names(df3) <- c('TimeLen', kCL)

# Reformat data so all of the output is in one column
df3 <- pivot_longer(df3, !TimeLen, names_to = 'kCL', values_to = 'df3')

EClonic_plot <- ggplot(data = df3, aes(x = as.numeric(kCL), y = TimeLen, fill = df3)) +
  geom_tile() +
  labs(title = 'C') +
  xlab('kCL (hr-1)') +
  ylab('Time between Doses (h)') +
  labs(fill='Minimum\nClonic Seizure\nProtection (%)') +
  theme1 +
  scale_fill_viridis(discrete = FALSE) 

ggsave(filename = 'global_Etrough_Clonic.png', plot = EClonic_plot, path = 'sens_analysis_data/', 
       width = 12, height = 8)

plot(EClonic_plot)
