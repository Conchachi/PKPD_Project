# Final Project - LEV Population Variability
# Outputs plots for Figures 9, 10, and 11

# Load necessary packages
library("R.matlab")
library("tidyverse")
library("patchwork")
library("plotly")
library("shiny")
library("viridis")

# Loading Data and Setting Themes
##############################################################################

# set theme for all plots
theme1 <- theme_classic() +
  theme(text = element_text(size = 18),
        plot.title = element_text(hjust = 0),
        axis.text.x = element_text(size = 15),
        axis.text.y = element_text(size = 15),
        legend.text = element_text(size=12),
        legend.box.background = element_rect(colour = "black"),
        plot.title.position = "plot")

# Load kA Data 
ka_data <- readMat('pop_var_data/kA_PopVar_params.mat')
ka_data <- as.data.frame(ka_data)

ka_values <- readMat('pop_var_data/kA_PopVar.mat')
ka_values <- as.data.frame(ka_values)

names(ka_data) <- c('AUC','Ctrough', 'AUECTonic', 'EtroughTonic', 'AUECClonic', 'EtroughClonic')
names(ka_values) <- c('kA')

ka_data <- bind_cols(ka_data, ka_values)


# Load kCL Data
kcl_data <- readMat('pop_var_data/kCL_PopVar_params.mat')
kcl_data <- as.data.frame(kcl_data)

kcl_values <- readMat('pop_var_data/kCL_PopVar.mat')
kcl_values <- as.data.frame(kcl_values)

names(kcl_data) <- c('AUC','Ctrough', 'AUECTonic', 'EtroughTonic', 'AUECClonic', 'EtroughClonic')
names(kcl_values) <- c('kCL')

kcl_data <- bind_cols(kcl_data, kcl_values)

# Load kA and kCL (Varying Both) Data 
both_data <- readMat('pop_var_data/kCL_kA_PopVar_params.mat')
both_data <- as.data.frame(both_data)

names(both_data) <- c('AUC','Ctrough', 'AUECTonic', 'EtroughTonic', 'AUECClonic', 'EtroughClonic')

both_data <- bind_cols(both_data, ka_values, kcl_values)

# kA Only 
################################################################################
ka_AUC_Plot <- ggplot(data = NULL) +
  geom_point(data = ka_data, aes(x = kA, y = AUC), color='darkorchid', size = 1.5) +
  labs(title = 'A', 
       x = 'kA (1/hr)', y = 'AUC of Central Compartment\nConcentration (mg*h/L)') +
  theme1
plot(ka_AUC_Plot)
ggsave(filename = 'ka_AUC.png', plot = ka_AUC_Plot, path = 'pop_var_data/', width = 5, height = 4.5)


ka_AUEC_Plot <- ggplot(data = NULL) +
  geom_point(data = ka_data, aes(x = kA, y = AUECTonic, color="AUEC of Tonic\nSeizure Protection"), size = 1.5) +
  geom_point(data = ka_data, aes(x = kA, y = AUECClonic, color="AUEC of Clonic\nSeizure Protection"), size = 1.5) +
  labs(title = 'C', 
       x = 'kA (1/hr)', y = 'AUEC of Seizure\nProtection (% * hr)', color = ' ') +
  theme1 + 
  theme(legend.position  = 'bottom') 
plot(ka_AUEC_Plot)
ggsave(filename = 'ka_AUEC.png', plot = ka_AUEC_Plot, path = 'pop_var_data/', width = 5, height = 5)


ka_Ctrough_Plot <- ggplot(data = NULL) +
  geom_point(data = ka_data, aes(x = kA, y = Ctrough), color='darkorchid', size = 1.5) +
  labs(title = 'B', 
       x = 'kA (1/hr)', y = 'Ctrough- Minimum Central\nCompartment Conc. (mg/L)') +
  theme1 + 
  theme(legend.position="none")
plot(ka_Ctrough_Plot)
ggsave(filename = 'ka_Ctrough.png', plot = ka_Ctrough_Plot, path = 'pop_var_data/', width = 5, height = 4.5)


ka_Etrough_Plot <- ggplot(data = NULL) +
  geom_point(data = ka_data, aes(x = kA, y = EtroughTonic, color="Minimum Tonic\nSeizure Protection"), size = 1.5) +
  geom_point(data = ka_data, aes(x = kA, y = EtroughClonic, color="Minimum Clonic\nSeizure Protection"), size = 1.5) +
  labs(title = 'D', 
       x = 'kA (1/hr)', y = 'Etrough- Minimum\nSeizure Protection (%)', color = ' ') +
  theme1 + 
  theme(legend.position  = 'bottom') 
plot(ka_Etrough_Plot)
ggsave(filename = 'ka_Etrough.png', plot = ka_Etrough_Plot, path = 'pop_var_data/', width = 5, height = 5)


################################################################################
# kCL Only

kcl_AUC_Plot <- ggplot(data = NULL) +
  geom_point(data = kcl_data, aes(x = kCL, y = AUC), color='darkorchid', size = 1.5) +
  labs(title = 'A', 
       x = 'kCL (1/hr)', y = 'AUC of Central Compartment\nConcentration (mg*h/L)') +
  theme1
plot(kcl_AUC_Plot)
ggsave(filename = 'kcl_AUC.png', plot = kcl_AUC_Plot, path = 'pop_var_data/', width = 5, height = 4.5)


kcl_AUEC_Plot <- ggplot(data = NULL) +
  geom_point(data = kcl_data, aes(x = kCL, y = AUECTonic, color="AUEC of Tonic\nSeizure Protection"), size = 1.5) +
  geom_point(data = kcl_data, aes(x = kCL, y = AUECClonic, color="AUEC of Clonic\nSeizure Protection"), size = 1.5) +
  labs(title = 'C', 
       x = 'kCL (1/hr)', y = 'AUEC of Seizure\nProtection (% * hr)', color = ' ') +
  theme1 + 
  theme(legend.position  = "bottom")
plot(kcl_AUEC_Plot)
ggsave(filename = 'kcl_AUEC.png', plot = kcl_AUEC_Plot, path = 'pop_var_data/', width = 5, height = 5)


kcl_Ctrough_Plot <- ggplot(data = NULL) +
  geom_point(data = kcl_data, aes(x = kCL, y = Ctrough), color='darkorchid', size = 1.5) +
  labs(title = 'B', 
       x = 'kCL (1/hr)', y = 'Ctrough- Minimum Central\nCompartment Conc. (mg/L)') + 
  theme1
plot(kcl_Ctrough_Plot)
ggsave(filename = 'kcl_Ctrough.png', plot = kcl_Ctrough_Plot, path = 'pop_var_data/', width = 5, height = 4.5)


kcl_Etrough_Plot <- ggplot(data = NULL) +
  geom_point(data = kcl_data, aes(x = kCL, y = EtroughTonic, color="Minimum Tonic\nSeizure Protection"), size = 1.5) +
  geom_point(data = kcl_data, aes(x = kCL, y = EtroughClonic, color="Minimum Clonic\nSeizure Protection"), size = 1.5) +
  labs(title = 'D', 
       x = 'kCL (1/hr)', y = 'Etrough- Minimum\nSeizure Protection (%)', color = ' ') +
  theme1 + 
  theme(legend.position  = 'bottom')
plot(kcl_Etrough_Plot)
ggsave(filename = 'kcl_Etrough.png', plot = kcl_Etrough_Plot, path = 'pop_var_data/', width = 5, height = 5)
################################################################################

# Varying both kA and kCL


# set theme for all plots
theme1 <- theme_classic(base_size = 12) +
  theme(text = element_text(size = 12),
        plot.title = element_text(hjust = 0),
        axis.title.x = element_text(margin = margin(10, 0, 0, 0)),
        axis.title.y = element_text(margin = margin(0, 10, 0, 0)),
        axis.text.x = element_text(size = 12),
        axis.text.y = element_text(size = 12),
        legend.key.height = unit(1.5, 'cm'),
        plot.title.position = "plot")

AUC3D <- ggplot(both_data, aes(kA, kCL, color=AUC)) + 
  geom_point(size=3) +
  scale_color_viridis(discrete = FALSE) +
  labs(title = 'A    AUC of Central Compartment Concentration')+
  xlab('kA (hr-1)') +
  ylab('kCL (hr-1)') +
  labs(color = ' ') +
  theme1 
ggsave(filename = '3DAUC.png', plot = AUC3D, path = 'pop_var_data/', width = 5, height = 4)
plot(AUC3D)


ClonicAUEC3D <- ggplot(both_data, aes(kA, kCL, color=AUECClonic)) + 
  geom_point(size=3) +
  scale_color_viridis(discrete = FALSE) +
  labs(title = 'B    AUEC of Clonic Seizure Protection') +
  xlab('kA (hr-1)') +
  ylab('kCL (hr-1)') +
  labs(color = ' ') +
  theme1 
ggsave(filename = '3DClonicAUEC.png', plot = ClonicAUEC3D, path = 'pop_var_data/', width = 5, height = 4)
#plot(ClonicAUEC3D)


TonicAUEC3D <- ggplot(both_data, aes(kA, kCL, color=AUECTonic)) + 
  geom_point(size=3) +
  scale_color_viridis(discrete = FALSE) +
  labs(title = 'C    AUEC of Tonic Seizure Protection') +
  xlab('kA (hr-1)') +
  ylab('kCL (hr-1)') +
  labs(color = ' ') +
  theme1 
ggsave(filename = '3DTonicAUEC.png', plot = TonicAUEC3D, path = 'pop_var_data/', width = 5, height = 4)
#plot(TonicAUEC3D)


Ctrough3D <- ggplot(both_data, aes(kA, kCL, color=Ctrough)) + 
  geom_point(size=3) +
  scale_color_viridis(discrete = FALSE) +
  labs(title = 'D    Minimum Central Compartment Concentration') +
  xlab('kA (hr-1)') +
  ylab('kCL (hr-1)') + 
  labs(color = '(mg/L)') +
  theme1 
ggsave(filename = '3DCtrough.png', plot = Ctrough3D, path = 'pop_var_data/', width = 5, height = 4)
plot(Ctrough3D)


ClonicEtrough3D <- ggplot(both_data, aes(kA, kCL, color=EtroughClonic)) + 
  geom_point(size=3) +
  scale_color_viridis(discrete = FALSE) +
  labs(title = 'E    Minimum Clonic Seizure Protection') +
  xlab('kA (hr-1)') +
  ylab('kCL (hr-1)') +
  labs(color = '(%)') +
  theme1 
ggsave(filename = '3DClonicEtrough.png', plot = ClonicEtrough3D, path = 'pop_var_data/', width = 5, height = 4)
plot(ClonicEtrough3D)


TonicEtrough3D <- ggplot(both_data, aes(kA, kCL, color=EtroughTonic)) + 
  geom_point(size=3) +
  scale_color_viridis(discrete = FALSE) +
  labs(title = 'F    Minimum Tonic Seizure Protection') +
  xlab('kA (hr-1)') +
  ylab('kCL (hr-1)') +
  labs(color = '(%)') +
  theme1 
ggsave(filename = '3DTonicEtrough.png', plot = TonicEtrough3D, path = 'pop_var_data/', width = 5, height = 4)
plot(TonicEtrough3D)

