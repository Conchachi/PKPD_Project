# Final Project - LEV Sensitivity Analysis 
# Outputs two plots

# Load necessary packages
library("R.matlab")
library("tidyverse")
library("patchwork")
library("plotly")
library("shiny")

# set theme for all plots
theme1 <- theme_classic(base_size = 20) +
  theme(text = element_text(),
        panel.grid.major.y = element_line(colour = "grey", size = 0.2),
        panel.grid.minor.y = element_line(colour = "grey", size = 0.2),
        plot.title.position = "plot")
        
SensAUC <- readMat('sens_analysis_data/SensAUC.mat')
SensAUC <- as.data.frame(SensAUC)

SensClonicAUEC <- readMat('sens_analysis_data/SensClonicAUEC.mat')
SensClonicAUEC <- as.data.frame(SensClonicAUEC)

SensTonicAUEC <- readMat('sens_analysis_data/SensTonicAUEC.mat')
SensTonicAUEC <- as.data.frame(SensTonicAUEC)

SensClonicEtrough <- readMat('sens_analysis_data/SensClonicEtrough.mat')
SensClonicEtrough <- as.data.frame(SensClonicEtrough)

SensTonicEtrough <- readMat('sens_analysis_data/SensTonicEtrough.mat')
SensTonicEtrough <- as.data.frame(SensTonicEtrough)

SensCtrough<- readMat('sens_analysis_data/SensCtrough.mat')
SensCtrough <- as.data.frame(SensCtrough)


names(SensAUC) <- c('kA,AUC', 'V,AUC', 'kCL,AUC', 'Dose,AUC', 'TimeLen,AUC')
names(SensClonicAUEC) <- c('kA,AUEC - Clonic', 'V,AUEC - Clonic', 'kCL,AUEC - Clonic', 'Dose,AUEC - Clonic', 
                           'TimeLen,AUEC - Clonic')
names(SensClonicEtrough) <- c('kA,Clonic E_Trough', 'V,Clonic E_Trough', 
                              'kCL,Clonic E_Trough', 'Dose,Clonic E_Trough', 
                              'TimeLen,Clonic E_Trough')
names(SensCtrough) <- c('kA,C_Trough', 'V,C_Trough', 'kCL,C_Trough', 
                        'Dose,C_Trough', 'TimeLen,C_Trough')
names(SensTonicAUEC) <- c('kA,AUEC - Tonic', 'V,AUEC - Tonic', 'kCL,AUEC - Tonic', 'Dose,AUEC - Tonic', 'TimeLen,AUEC - Tonic')
names(SensTonicEtrough) <- c('kA,Tonic E_Trough', 'V,Tonic E_Trough',
                             'kCL,Tonic E_Trough', 'Dose,Tonic E_Trough',
                             'TimeLen,Tonic E_Trough')


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
               into = c("Parameter", "Legend"),
               sep = ",")

Trough <- separate(Trough,
                col = "Parameters",
                into = c("Parameter", "Legend"),
                sep = ",")

AUC_plot<-ggplot(data = AUC, aes(x=Parameter, y=Sensitivity, colour = Legend, fill=Legend)) +
  geom_bar(stat="identity", position=position_dodge()) + 
  labs(title = 'A')+
  ylim(-1.8,1.8)  + 
  theme1
AUC_plot
ggsave(filename = 'LocalSens_AUC_plot.png', plot = AUC_plot, path = 'sens_analysis_data/', width = 8, height = 6)

Trough_plot<-ggplot(data = Trough, aes(x=Parameter, y=Sensitivity, colour = Legend, fill=Legend)) +
  geom_bar(stat="identity", position=position_dodge()) + 
  labs(title = 'B')+
  ylim(-1.8,1.8) +
  theme1
Trough_plot
ggsave(filename = 'LocalSens_Trough_plot.png', plot = Trough_plot, path = 'sens_analysis_data/', width = 8, height = 6)

