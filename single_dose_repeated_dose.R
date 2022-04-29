
# ==============================================================================
# load libraries
library('R.matlab')
library('tidyverse')
library('patchwork')
library('plotly') # not needed for this assignment
library('shiny') # not needed for this assignment
library('rsconnect') # not needed for this assignment

# ==============================================================================
# plot theme

vis_theme <- theme_classic() +
  theme(
    text = element_text(size = 30),
    plot.title = element_text(size = 50, hjust = 0),
    plot.title.position = 'plot',
    axis.title = element_text(size = 25),
    axis.title.x = element_text(margin = margin(10,0,0,0)),
    axis.title.y = element_text(margin = margin(0,10,0,0)),
    axis.text = element_text(size = 30),
    axis.text.x = element_text(margin = margin(5,0,0,0)),
    axis.text.y = element_text(margin = margin(0,5,0)),
    legend.box.margin = margin(10, 10, 10, 10)
  )

# ==============================================================================
# [LEV] for Single dose, 400 mg (comparison to the paper figure)

# load data
sddata <- readMat('single_dose_data/SingleDoseConc.mat')
sdtime <- readMat('single_dose_data/SingleDoseTime.mat')
sddata <- as.data.frame(sddata)
sdtime <- as.data.frame(sdtime)

sddata <- cbind(sdtime, sddata)

# manipulate data
names(sddata) <- c('Time', 'Concentration')

# plot
sdplot <- ggplot(data = NULL) + 
  geom_line(
    data = sddata,
    aes(x = Time, y = Concentration, color = 'red'),
    size = 1.5,
  ) +
  scale_x_continuous(name = 'Time (hr)') +
  scale_y_continuous(name = '[D] (mg/L)') +
  labs(title = 'A') +
  vis_theme +
  theme(
    legend.position = 'none'
  )

ggsave(filename = 'single_dose_plot.png', plot = sdplot, width = 12, height = 8)

# ==============================================================================
# [LEV] for Repeated dose, varying dose (100 - 600 mg)
# load data
rddata <- readMat('repeated_dose_data/DoseRangeConc.mat')
rdtime <- readMat('repeated_dose_data/DoseRangeTime.mat')
rddata <- as.data.frame(rddata)
rdtime <- as.data.frame(rdtime)

rddata <- cbind(rdtime, rddata)

# data manipulation
names(rddata) <- c('Time', '100', '200', '300', '400', '500', '600')
rddata <- pivot_longer(rddata, !Time, names_to = 'Dose', values_to = 'Concentration')
rddata$Dose <- factor(rddata$Dose, levels = c('100', '200', '300', '400', '500', '600'))

# plot
rdplot <- ggplot(data = NULL) +
  geom_line(
    data = rddata,
    aes(x = Time, y = Concentration, color = Dose),
    size = 1.5
  ) +
  scale_x_continuous(name = 'Time (hr)', limits = c(0, 130), breaks = seq(0, 130, by = 25)) +
  scale_y_continuous(name = '[D] (mg/L)') +
  scale_color_discrete('Dose (mg)') +
  labs(title = 'B') +
  vis_theme

ggsave(filename = 'repeated_dose_plot.png', plot = rdplot, width = 12, height = 8)

# ==============================================================================
# R/Rmax for Repeated dose, varying dose (100 - 600 mg)
# load data
erdata <- readMat('repeated_dose_data/DoseRangeReceptor.mat')
erdata <- as.data.frame(erdata)

erdata <- cbind(rdtime, erdata)

# data manipulation
names(erdata) <- c('Time', '100', '200', '300', '400', '500', '600')
erdata <- pivot_longer(erdata, !Time, names_to = 'Dose', values_to = 'Concentration')
erdata$Dose <- factor(erdata$Dose, levels = c('100', '200', '300', '400', '500', '600'))

# plot
erplot <- ggplot(data = NULL) +
  geom_line(
    data = erdata,
    aes(x = Time, y = Concentration, color = Dose),
    size = 1.5
  ) +
  scale_x_continuous(name = 'Time (hr)', limits = c(0, 130), breaks = seq(0, 130, by = 25)) +
  scale_y_continuous(name = 'SV2A occupancy with R/Rmax (%)', limits = c(0, 100)) +
  scale_color_discrete('Dose (mg)') +
  labs(title = 'A') +
  vis_theme

ggsave(filename = 'effect_r_plot.png', plot = erplot, width = 12, height = 8)

# ==============================================================================
# E/Emax for Repeated dose, varying dose (100 - 600 mg)
# load data
eedata <- readMat('repeated_dose_data/DoseRangeEffect.mat')
eedata <- as.data.frame(eedata)

eedata <- cbind(rdtime, eedata)

# data manipulation
names(eedata) <- c('Time', '100', '200', '300', '400', '500', '600')
eedata <- pivot_longer(eedata, !Time, names_to = 'Dose', values_to = 'Concentration')
eedata$Dose <- factor(eedata$Dose, levels = c('100', '200', '300', '400', '500', '600'))

# plot
eeplot <- ggplot(data = NULL) +
  geom_line(
    data = eedata,
    aes(x = Time, y = Concentration, color = Dose),
    size = 1.5
  ) +
  scale_x_continuous(name = 'Time (hr)', limits = c(0, 130), breaks = seq(0, 130, by = 25)) +
  scale_y_continuous(name = 'SV2A occupancy with E/Emax (%)', limits = c(0, 100)) +
  scale_color_discrete('Dose (mg)') +
  labs(title = 'B') +
  vis_theme

ggsave(filename = 'effect_e_plot.png', plot = eeplot, width = 12, height = 8)

# ==============================================================================
# Protection against tonic seizures for Repeated dose, varying dose (100 - 600 mg)
# load data
eptdata <- readMat('repeated_dose_data/DoseRangeP_tonic.mat')
eptdata <- as.data.frame(eptdata)

eptdata <- cbind(rdtime, eptdata)

# data manipulation
names(eptdata) <- c('Time', '100', '200', '300', '400', '500', '600')
eptdata <- pivot_longer(eptdata, !Time, names_to = 'Dose', values_to = 'Concentration')
eptdata$Dose <- factor(eptdata$Dose, levels = c('100', '200', '300', '400', '500', '600'))

# plot
eptplot <- ggplot(data = NULL) +
  geom_line(
    data = eptdata,
    aes(x = Time, y = Concentration, color = Dose),
    size = 1.5
  ) +
  scale_x_continuous(name = 'Time (hr)', limits = c(0, 130), breaks = seq(0, 130, by = 25)) +
  scale_y_continuous(name = 'Protection against tonic seizures (%)', limits = c(0, 100)) +
  scale_color_discrete('Dose (mg)') +
  labs(title = 'C') +
  vis_theme

ggsave(filename = 'effect_ptonic_plot.png', plot = eptplot, width = 12, height = 8)

# ==============================================================================
# Protection against clonic seizures for Repeated dose, varying dose (100 - 600 mg)
# load data
epcdata <- readMat('repeated_dose_data/DoseRangeP_clonic.mat')
epcdata <- as.data.frame(epcdata)

epcdata <- cbind(rdtime, epcdata)

# data manipulation
names(epcdata) <- c('Time', '100', '200', '300', '400', '500', '600')
epcdata <- pivot_longer(epcdata, !Time, names_to = 'Dose', values_to = 'Concentration')
epcdata$Dose <- factor(epcdata$Dose, levels = c('100', '200', '300', '400', '500', '600'))

# plot
epcplot <- ggplot(data = NULL) +
  geom_line(
    data = epcdata,
    aes(x = Time, y = Concentration, color = Dose),
    size = 1.5
  ) +
  scale_x_continuous(name = 'Time (hr)', limits = c(0, 130), breaks = seq(0, 130, by = 25)) +
  scale_y_continuous(name = 'Protection against clonic seizures (%)', limits = c(0, 100)) +
  scale_color_discrete('Dose (mg)') +
  labs(title = 'D') +
  vis_theme

ggsave(filename = 'effect_pclonic_plot.png', plot = epcplot, width = 12, height = 8)

# ==============================================================================
# Figure 1 ([LEV] for single dose and repeated dose)
figure1 <- sdplot | rdplot
ggsave(filename = 'figure1.png', plot = figure1, width = 24, height = 8)

# ==============================================================================
# Figure 2 (effect for repeated dose)
figure2 <- (erplot | eeplot) / (eptplot | epcplot) +
  plot_layout(guides = 'collect')

ggsave(filename = 'figure2.png', plot = figure2, width = 24, height = 16)
