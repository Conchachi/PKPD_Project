# Final Project - LEV Sensitivity Analysis 
# Outputs two plots

# Load necessary packages
library("R.matlab")
library("tidyverse")
library("patchwork")
library("plotly")
library("shiny")

# set theme for all plots
theme1 <- theme_classic() +
  theme(text = element_text(size = 20),
        plot.title = element_text(hjust = 0),
        axis.title.x = element_text(margin = margin(10, 0, 0, 0)),
        axis.title.y = element_text(margin = margin(0, 10, 0, 0)),
        axis.text.x = element_text(margin = margin(5, 0, 0, 0)),
        axis.text.y = element_text(margin = margin(0, 5, 0, 0)),
        plot.title.position = "plot")


SensAUC <- readMat('SensAUC.mat')
SensAUC <- as.data.frame(SensAUC)

SensClonicAUEC <- readMat('SensClonicAUEC.mat')
SensClonicAUEC <- as.data.frame(SensClonicAUEC)

SensTonicAUEC <- readMat('SensTonicAUEC.mat')
SensTonicAUEC <- as.data.frame(SensTonicAUEC)

SensClonicEtrough <- readMat('SensClonicEtrough.mat')
SensClonicEtrough <- as.data.frame(SensClonicEtrough)

SensTonicEtrough <- readMat('SensTonicEtrough.mat')
SensTonicEtrough <- as.data.frame(SensTonicEtrough)

SensCtrough<- readMat('SensCtrough.mat')
SensCtrough <- as.data.frame(SensCtrough)


names(SensAUC) <- c('kA,AUC', 'V,AUC', 'kCL,AUC', 'Dose,AUC', 'TimeLen,AUC')
names(SensClonicAUEC) <- c('kA,AUEC - Clonic', 'V,AUEC - Clonic', 'kCL,AUEC - Clonic', 'Dose,AUEC - Clonic', 
                           'TimeLen,AUEC - Clonic')
names(SensClonicEtrough) <- c('kA,Effective Trough - Clonic', 'V,Effective Trough - Clonic', 
                              'kCL,Effective Trough - Clonic', 'Dose,Effective Trough - Clonic', 
                              'TimeLen,Effective Trough - Clonic')
names(SensCtrough) <- c('kA,Concentration Trough', 'V,Concentration Trough', 'kCL,Concentration Trough', 
                        'Dose,Concentration Trough', 'TimeLen,Concentration Trough')
names(SensTonicAUEC) <- c('kA,AUEC - Tonic', 'V,AUEC - Tonic', 'kCL,AUEC - Tonic', 'Dose,AUEC - Tonic', 'TimeLen,AUEC - Tonic')
names(SensTonicEtrough) <- c('kA,Effective Trough - Tonic', 'V,Effective Trough - Tonic',
                             'kCL,Effective Trough - Tonic', 'Dose,Effective Trough - Tonic',
                             'TimeLen,Effective Trough - Tonic')


AUC <- cbind(SensAUC, SensClonicAUEC, SensTonicAUEC)
Trough <- cbind(SensClonicEtrough, SensCtrough, SensTonicEtrough)

AUC <- pivot_longer(AUC,
                   cols = everything(),
                   names_to = "Parameters",
                   values_to = "Sensitivity")

Trough <- pivot_longer(Trough,
                    cols = everything(),
                    names_to = "Parameters",
                    values_to = "Sensitivity")

AUC <- separate(AUC,
               col = "Parameters",
               into = c("Parameter", "Relative_Sensitivity_of"),
               sep = ",")

Trough <- separate(Trough,
                col = "Parameters",
                into = c("Parameter", "Relative_Sensitivity_of"),
                sep = ",")

AUC_plot<-ggplot(data = AUC, aes(x=Parameter, y=Sensitivity, colour = Relative_Sensitivity_of, fill=Relative_Sensitivity_of)) +
  geom_bar(stat="identity", position=position_dodge()) + 
  labs(title = 'A')+
  ylim(-1.8,1.8) 
AUC_plot
ggsave(filename = 'AUC_plot.png', plot = AUC_plot, width = 8, height = 6)

Trough_plot<-ggplot(data = Trough, aes(x=Parameter, y=Sensitivity, colour = Relative_Sensitivity_of, fill=Relative_Sensitivity_of)) +
  geom_bar(stat="identity", position=position_dodge()) + 
  labs(title = 'B')+
  ylim(-1.8,1.8) 
Trough_plot
ggsave(filename = 'Trough_plot.png', plot = Trough_plot, width = 8, height = 6)
