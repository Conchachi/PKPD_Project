# Final Project - LEV Sensitivity Analysis

# Load necessary packages
library("R.matlab")
library("tidyverse")
library("patchwork")
library("plotly")
library("shiny")

# set theme for all plots
theme1 <- theme_light() +
  theme(text = element_text(size = 18),
        plot.title = element_text(hjust = 0),
        axis.title.x = element_text(margin = margin(10, 0, 0, 0)),
        axis.title.y = element_text(margin = margin(0, 10, 0, 0)),
        axis.text.x = element_text(margin = margin(5, 0, 0, 0)),
        axis.text.y = element_text(margin = margin(0, 5, 0, 0)),
        plot.title.position = "plot")

# Sensitivity of AUC
SensAUC <- readMat('SensAUC.mat')
SensAUC <- as.data.frame(SensAUC)
names(SensAUC) <- c('kA', 'V', 'kCL', 'Dose', 'TimeLen')

SensAUC <- pivot_longer(SensAUC,
                        cols = everything(),
                        names_to = "Parameters",
                        values_to = "Sensitivity")

SensAUC_plot<-ggplot(data = SensAUC, aes(x=Parameters, y=Sensitivity, colour = Parameters, fill=Parameters)) +
  geom_bar(stat="identity") + 
  labs(title = 'Relative Sensitivity of AUC') +
  ylim(-1,1) +
  theme1 
SensAUC_plot
ggsave(filename = 'SensAUC_plot.png', plot = SensAUC_plot, width = 8, height = 6)


# Sensitivity of AUEC
SensClonicAUEC <- readMat('SensClonicAUEC.mat')
SensClonicAUEC <- as.data.frame(SensClonicAUEC)
names(SensClonicAUEC) <- c('kA', 'V', 'kCL', 'Dose', 'TimeLen')

SensClonicAUEC <- pivot_longer(SensClonicAUEC,
                        cols = everything(),
                        names_to = "Parameters",
                        values_to = "Sensitivity")

SensClonicAUEC_plot<-ggplot(data = SensClonicAUEC, aes(x=Parameters, y=Sensitivity, colour = Parameters, fill=Parameters)) +
  geom_bar(stat="identity") + 
  labs(title = 'Relative Sensitivity of AUEC: Clonic Seizure Protection')+
  ylim(-1,1) +
  theme1 
SensClonicAUEC_plot
ggsave(filename = 'SensClonicAUEC_plot.png', plot = SensClonicAUEC_plot, width = 8, height = 6)


# Sensitivity of SensClonicEtrough
SensClonicEtrough <- readMat('SensClonicEtrough.mat')
SensClonicEtrough <- as.data.frame(SensClonicEtrough)
names(SensClonicEtrough) <- c('kA', 'V', 'kCL', 'Dose', 'TimeLen')

SensClonicEtrough <- pivot_longer(SensClonicEtrough,
                        cols = everything(),
                        names_to = "Parameters",
                        values_to = "Sensitivity")

SensClonicEtrough_plot<-ggplot(data = SensClonicEtrough, aes(x=Parameters, y=Sensitivity, colour = Parameters, fill=Parameters)) +
  geom_bar(stat="identity") + 
  labs(title = 'Relative Sensitivity of Etrough: Clonic Seizure Prevention')+
  ylim(-1,1) +
  theme1 
SensClonicEtrough_plot
ggsave(filename = 'SensClonicEtrough_plot.png', plot = SensClonicEtrough_plot, width = 8, height = 6)


# Sensitivity of Ctrough 
SensCtrough <- readMat('SensCtrough.mat')
SensCtrough <- as.data.frame(SensCtrough)
names(SensCtrough) <- c('kA', 'V', 'kCL', 'Dose', 'TimeLen')

SensCtrough <- pivot_longer(SensCtrough,
                        cols = everything(),
                        names_to = "Parameters",
                        values_to = "Sensitivity")

SensCtrough_plot<-ggplot(data = SensCtrough, aes(x=Parameters, y=Sensitivity, colour = Parameters, fill=Parameters)) +
  geom_bar(stat="identity") +
  labs(title = 'Relative Sensitivity of Ctrough')+
  ylim(-1.8,1.8) +
  theme1
SensCtrough_plot
ggsave(filename = 'SensCtrough_plot.png', plot = SensCtrough_plot, width = 8, height = 6)


# Sensitivity of SensTonicAUEC
SensTonicAUEC <- readMat('SensTonicAUEC.mat')
SensTonicAUEC <- as.data.frame(SensTonicAUEC)
names(SensTonicAUEC) <- c('kA', 'V', 'kCL', 'Dose', 'TimeLen')

SensTonicAUEC <- pivot_longer(SensTonicAUEC,
                        cols = everything(),
                        names_to = "Parameters",
                        values_to = "Sensitivity")

SensTonicAUEC_plot<-ggplot(data = SensTonicAUEC, aes(x=Parameters, y=Sensitivity, colour = Parameters, fill=Parameters)) +
  geom_bar(stat="identity") + 
  labs(title = 'Relative Sensitivity of AUEC: Tonic Seizure Protection')+
  ylim(-1,1) +
  theme1 
SensTonicAUEC_plot
ggsave(filename = 'SensTonicAUEC_plot.png', plot = SensTonicAUEC_plot, width = 8, height = 6)

# Sensitivity of SensTonicEtrough
SensTonicEtrough <- readMat('SensTonicEtrough.mat')
SensTonicEtrough <- as.data.frame(SensTonicEtrough)
names(SensTonicEtrough) <- c('kA', 'V', 'kCL', 'Dose', 'TimeLen')

SensTonicEtrough <- pivot_longer(SensTonicEtrough,
                        cols = everything(),
                        names_to = "Parameters",
                        values_to = "Sensitivity")

SensTonicEtrough_plot<-ggplot(data = SensTonicEtrough, aes(x=Parameters, y=Sensitivity, colour = Parameters, fill=Parameters)) +
  geom_bar(stat="identity") + 
  labs(title = 'Relative Sensitivity of Etrough: Tonic Seizure Protection')+
  ylim(-1,1) +
  theme1 
SensTonicEtrough_plot
ggsave(filename = 'SensTonicEtrough_plot.png', plot = SensTonicEtrough_plot, width = 8, height = 6)

