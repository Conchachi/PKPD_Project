
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
# histogram for missed_dose_pop data

# load data
# AUC
AUC_double <- as.data.frame(readMat('missed_dose_pop_data/AUC_double.mat'))
AUC_missed <- as.data.frame(readMat('missed_dose_pop_data/AUC_missed.mat'))
AUC_skipped <- as.data.frame(readMat('missed_dose_pop_data/AUC_skipped.mat'))
# AUEC tonic
AUEC_tonic_double <- as.data.frame(readMat('missed_dose_pop_data/AUEC_tonic_double.mat'))
AUEC_tonic_missed <- as.data.frame(readMat('missed_dose_pop_data/AUEC_tonic_missed.mat'))
AUEC_tonic_skipped <- as.data.frame(readMat('missed_dose_pop_data/AUEC_tonic_skipped.mat'))
#AUEC clonic
AUEC_clonic_double <- as.data.frame(readMat('missed_dose_pop_data/AUEC_clonic_double.mat'))
AUEC_clonic_missed <- as.data.frame(readMat('missed_dose_pop_data/AUEC_clonic_missed.mat'))
AUEC_clonic_skipped <- as.data.frame(readMat('missed_dose_pop_data/AUEC_clonic_skipped.mat'))
# Ctrough
Ctrough_double <- as.data.frame(readMat('missed_dose_pop_data/Ctrough_double.mat'))
Ctrough_missed <- as.data.frame(readMat('missed_dose_pop_data/Ctrough_missed.mat'))
Ctrough_skipped <- as.data.frame(readMat('missed_dose_pop_data/Ctrough_skipped.mat'))
# Etrough tonic
Etrough_tonic_double <- as.data.frame(readMat('missed_dose_pop_data/Etrough_tonic_double.mat'))
Etrough_tonic_missed <- as.data.frame(readMat('missed_dose_pop_data/Etrough_tonic_missed.mat'))
Etrough_tonic_skipped <- as.data.frame(readMat('missed_dose_pop_data/Etrough_tonic_skipped.mat'))
# Etrough clonic
Etrough_clonic_double <- as.data.frame(readMat('missed_dose_pop_data/Etrough_clonic_double.mat'))
Etrough_clonic_missed <- as.data.frame(readMat('missed_dose_pop_data/Etrough_clonic_missed.mat'))
Etrough_clonic_skipped <- as.data.frame(readMat('missed_dose_pop_data/Etrough_clonic_skipped.mat'))

# manipulate
# add column name
# AUC
names(AUC_double) <- c('AUC')
names(AUC_missed) <- c('AUC')
names(AUC_skipped) <- c('AUC')
# AUEC tonic
names(AUEC_tonic_double) <- c('AUEC_tonic')
names(AUEC_tonic_missed) <- c('AUEC_tonic')
names(AUEC_tonic_skipped) <- c('AUEC_tonic')
# AUEC clonic
names(AUEC_clonic_double) <- c('AUEC_clonic')
names(AUEC_clonic_missed) <- c('AUEC_clonic')
names(AUEC_clonic_skipped) <- c('AUEC_clonic')
# Ctrough
names(Ctrough_double) <- c('Ctrough')
names(Ctrough_missed) <- c('Ctrough')
names(Ctrough_skipped) <- c('Ctrough')
# Etrough tonic
names(Etrough_tonic_double) <- c('Etrough_tonic')
names(Etrough_tonic_missed) <- c('Etrough_tonic')
names(Etrough_tonic_skipped) <- c('Etrough_tonic')
# Etrough clonic
names(Etrough_clonic_double) <- c('Etrough_clonic')
names(Etrough_clonic_missed) <- c('Etrough_clonic')
names(Etrough_clonic_skipped) <- c('Etrough_clonic')

# ==============================================================================
# plot
# ==============================================================================
# AUC, AUEC (tonic), AUEC (clonic)
#AUC
AUC_missed_hist <- ggplot(AUC_missed, aes(x = AUC)) +
  geom_histogram(
    color = 'black',
    fill = 'red',
    binwidth = 0.1,
    alpha = 0.5
  ) +
  geom_vline(
    aes(xintercept = mean(AUC)),
    color = 'black',
    linetype = 'dashed',
    size = 1
  ) +
  geom_density(
    color = 'red4',
    size = 1
  ) +
  scale_x_continuous(
    name = 'Relative change in AUC\n(AUC - AUC0)/AUC0',
    limits = c(-1, 3.5),
    breaks = seq(-1, 3.5, by = 1)
  ) +
  scale_y_continuous(
    name = 'Count',
    limits = c(0, 120),
    breaks = seq(0, 120, by = 20)
  ) +
  labs(title = '           Missed Dose\nA') +
  vis_theme

AUC_double_hist <- ggplot(AUC_double, aes(x = AUC)) +
  geom_histogram(
    color = 'black',
    fill = 'blue',
    binwidth = 0.1,
    alpha = 0.5
  ) +
  geom_vline(
    aes(xintercept = mean(AUC)),
    color = 'black',
    linetype = 'dashed',
    size = 1
  ) +
  geom_density(
    color = 'blue4',
    size = 1
  ) +
  scale_x_continuous(
    name = 'Relative change in AUC\n(AUC - AUC0)/AUC0',
    limits = c(-1, 3.5),
    breaks = seq(-1, 3.5, by = 1)
  ) +
  scale_y_continuous(
    name = 'Count',
    limits = c(0, 120),
    breaks = seq(0, 120, by = 20)
  ) +
  labs(title = '           Double Dose\nB') +
  vis_theme

AUC_skipped_hist <- ggplot(AUC_skipped, aes(x = AUC)) +
  geom_histogram(
    color = 'black',
    fill = 'green',
    binwidth = 0.1,
    alpha = 0.5
  ) +
  geom_vline(
    aes(xintercept = mean(AUC)),
    color = 'black',
    linetype = 'dashed',
    size = 1
  ) +
  geom_density(
    color = 'green4',
    size = 1
  ) +
  scale_x_continuous(
    name = 'Relative change in AUC\n(AUC - AUC0)/AUC0',
    limits = c(-1, 3.5),
    breaks = seq(-1, 3.5, by = 1)
  ) +
  scale_y_continuous(
    name = 'Count',
    limits = c(0, 120),
    breaks = seq(0, 120, by = 20)
  ) +
  labs(title = '           Skipped Dose\nC') +
  vis_theme

# AUEC tonic
AUEC_tonic_missed_hist <- ggplot(AUEC_tonic_missed, aes(x = AUEC_tonic)) +
  geom_histogram(
    color = 'black',
    fill = 'red',
    binwidth = 0.1,
    alpha = 0.5
  ) +
  geom_vline(
    aes(xintercept = mean(AUEC_tonic)),
    color = 'black',
    linetype = 'dashed',
    size = 1
  ) +
  geom_density(
    color = 'red4',
    size = 1
  ) +
  scale_x_continuous(
    name = 'Relative change in AUEC (tonic)\n(AUEC - AUEC0)/AUEC0',
    limits = c(-1, 3.5),
    breaks = seq(-1, 3.5, by = 1)
  ) +
  scale_y_continuous(
    name = 'Count',
    limits = c(0, 120),
    breaks = seq(0, 120, by = 20)
  ) +
  labs(title = 'D') +
  vis_theme

AUEC_tonic_double_hist <- ggplot(AUEC_tonic_double, aes(x = AUEC_tonic)) +
  geom_histogram(
    color = 'black',
    fill = 'blue',
    binwidth = 0.1,
    alpha = 0.5
  ) +
  geom_vline(
    aes(xintercept = mean(AUEC_tonic)),
    color = 'black',
    linetype = 'dashed',
    size = 1
  ) +
  geom_density(
    color = 'blue4',
    size = 1
  ) +
  scale_x_continuous(
    name = 'Relative change in AUEC (tonic)\n(AUEC - AUEC0)/AUEC0',
    limits = c(-1, 3.5),
    breaks = seq(-1, 3.5, by = 1)
  ) +
  scale_y_continuous(
    name = 'Count',
    limits = c(0, 120),
    breaks = seq(0, 120, by = 20)
  ) +
  labs(title = 'E') +
  vis_theme

AUEC_tonic_skipped_hist <- ggplot(AUEC_tonic_skipped, aes(x = AUEC_tonic)) +
  geom_histogram(
    color = 'black',
    fill = 'green',
    binwidth = 0.1,
    alpha = 0.5
  ) +
  geom_vline(
    aes(xintercept = mean(AUEC_tonic)),
    color = 'black',
    linetype = 'dashed',
    size = 1
  ) +
  geom_density(
    color = 'green4',
    size = 1
  ) +
  scale_x_continuous(
    name = 'Relative change in AUEC (tonic)\n(AUEC - AUEC0)/AUEC0',
    limits = c(-1, 3.5),
    breaks = seq(-1, 3.5, by = 1)
  ) +
  scale_y_continuous(
    name = 'Count',
    limits = c(0, 120),
    breaks = seq(0, 120, by = 20)
  ) +
  labs(title = 'F') +
  vis_theme

# AUEC clonic
AUEC_clonic_missed_hist <- ggplot(AUEC_clonic_missed, aes(x = AUEC_clonic)) +
  geom_histogram(
    color = 'black',
    fill = 'red',
    binwidth = 0.1,
    alpha = 0.5
  ) +
  geom_vline(
    aes(xintercept = mean(AUEC_clonic)),
    color = 'black',
    linetype = 'dashed',
    size = 1
  ) +
  geom_density(
    color = 'red4',
    size = 1
  ) +
  scale_x_continuous(
    name = 'Relative change in AUEC (clonic)\n(AUEC - AUEC0)/AUEC0',
    limits = c(-1, 3.5),
    breaks = seq(-1, 3.5, by = 1)
  ) +
  scale_y_continuous(
    name = 'Count',
    limits = c(0, 120),
    breaks = seq(0, 120, by = 20)
  ) +
  labs(title = 'G') +
  vis_theme

AUEC_clonic_double_hist <- ggplot(AUEC_clonic_double, aes(x = AUEC_clonic)) +
  geom_histogram(
    color = 'black',
    fill = 'blue',
    binwidth = 0.1,
    alpha = 0.5
  ) +
  geom_vline(
    aes(xintercept = mean(AUEC_clonic)),
    color = 'black',
    linetype = 'dashed',
    size = 1
  ) +
  geom_density(
    color = 'blue4',
    size = 1
  ) +
  scale_x_continuous(
    name = 'Relative change in AUEC (clonic)\n(AUEC - AUEC0)/AUEC0',
    limits = c(-1, 3.5),
    breaks = seq(-1, 3.5, by = 1)
  ) +
  scale_y_continuous(
    name = 'Count',
    limits = c(0, 120),
    breaks = seq(0, 120, by = 20)
  ) +
  labs(title = 'H') +
  vis_theme

AUEC_clonic_skipped_hist <- ggplot(AUEC_clonic_skipped, aes(x = AUEC_clonic)) +
  geom_histogram(
    color = 'black',
    fill = 'green',
    binwidth = 0.1,
    alpha = 0.5
  ) +
  geom_vline(
    aes(xintercept = mean(AUEC_clonic)),
    color = 'black',
    linetype = 'dashed',
    size = 1
  ) +
  geom_density(
    color = 'green4',
    size = 1
  ) +
  scale_x_continuous(
    name = 'Relative change in AUEC (clonic)\n(AUEC - AUEC0)/AUEC0',
    limits = c(-1, 3.5),
    breaks = seq(-1, 3.5, by = 1)
  ) +
  scale_y_continuous(
    name = 'Count',
    limits = c(0, 120),
    breaks = seq(0, 120, by = 20)
  ) +
  labs(title = 'I') +
  vis_theme

# ==============================================================================
# Ctrough, Etrough (tonic), Etrough (clonic)
#Ctrough
Ctrough_missed_hist <- ggplot(Ctrough_missed, aes(x = Ctrough)) +
  geom_histogram(
    color = 'black',
    fill = 'red',
    binwidth = 0.1,
    alpha = 0.5
  ) +
  geom_vline(
    aes(xintercept = mean(Ctrough)),
    color = 'black',
    linetype = 'dashed',
    size = 1
  ) +
  geom_density(
    color = 'red4',
    size = 1
  ) +
  scale_x_continuous(
    name = 'Relative change in Ctrough\n(Ctrough - Ctrough0)/Ctrough0',
    limits = c(-1, 3.5),
    breaks = seq(-1, 3.5, by = 1)
  ) +
  scale_y_continuous(
    name = 'Count',
    limits = c(0, 50),
    breaks = seq(0, 50, by = 10)
  ) +
  labs(title = '           Missed Dose\nA') +
  vis_theme

Ctrough_double_hist <- ggplot(Ctrough_double, aes(x = Ctrough)) +
  geom_histogram(
    color = 'black',
    fill = 'blue',
    binwidth = 0.1,
    alpha = 0.5
  ) +
  geom_vline(
    aes(xintercept = mean(Ctrough)),
    color = 'black',
    linetype = 'dashed',
    size = 1
  ) +
  geom_density(
    color = 'blue4',
    size = 1
  ) +
  scale_x_continuous(
    name = 'Relative change in Ctrough\n(Ctrough - Ctrough0)/Ctrough0',
    limits = c(-1, 3.5),
    breaks = seq(-1, 3.5, by = 1)
  ) +
  scale_y_continuous(
    name = 'Count',
    limits = c(0, 50),
    breaks = seq(0, 50, by = 10)
  ) +
  labs(title = '           Double Dose\nB') +
  vis_theme

Ctrough_skipped_hist <- ggplot(Ctrough_skipped, aes(x = Ctrough)) +
  geom_histogram(
    color = 'black',
    fill = 'green',
    binwidth = 0.1,
    alpha = 0.5
  ) +
  geom_vline(
    aes(xintercept = mean(Ctrough)),
    color = 'black',
    linetype = 'dashed',
    size = 1
  ) +
  geom_density(
    color = 'green4',
    size = 1
  ) +
  scale_x_continuous(
    name = 'Relative change in Ctrough\n(Ctrough - Ctrough0)/Ctrough0',
    limits = c(-1, 3.5),
    breaks = seq(-1, 3.5, by = 1)
  ) +
  scale_y_continuous(
    name = 'Count',
    limits = c(0, 50),
    breaks = seq(0, 50, by = 10)
  ) +
  labs(title = '           Skipped Dose\nC') +
  vis_theme

# Etrough (tonic)
Etrough_tonic_missed_hist <- ggplot(Etrough_tonic_missed, aes(x = Etrough_tonic)) +
  geom_histogram(
    color = 'black',
    fill = 'red',
    binwidth = 0.1,
    alpha = 0.5
  ) +
  geom_vline(
    aes(xintercept = mean(Etrough_tonic)),
    color = 'black',
    linetype = 'dashed',
    size = 1
  ) +
  geom_density(
    color = 'red4',
    size = 1
  ) +
  scale_x_continuous(
    name = 'Relative change in Etrough (tonic)\n(Etrough - Etrough0)/Etrough0',
    limits = c(-1, 3.5),
    breaks = seq(-1, 3.5, by = 1)
  ) +
  scale_y_continuous(
    name = 'Count',
    limits = c(0, 50),
    breaks = seq(0, 50, by = 10)
  ) +
  labs(title = 'D') +
  vis_theme

Etrough_tonic_double_hist <- ggplot(Etrough_tonic_double, aes(x = Etrough_tonic)) +
  geom_histogram(
    color = 'black',
    fill = 'blue',
    binwidth = 0.1,
    alpha = 0.5
  ) +
  geom_vline(
    aes(xintercept = mean(Etrough_tonic)),
    color = 'black',
    linetype = 'dashed',
    size = 1
  ) +
  geom_density(
    color = 'blue4',
    size = 1
  ) +
  scale_x_continuous(
    name = 'Relative change in Etrough (tonic)\n(Etrough - Etrough0)/Etrough0',
    limits = c(-1, 3.5),
    breaks = seq(-1, 3.5, by = 1)
  ) +
  scale_y_continuous(
    name = 'Count',
    limits = c(0, 50),
    breaks = seq(0, 50, by = 10)
  ) +
  labs(title = 'E') +
  vis_theme

Etrough_tonic_skipped_hist <- ggplot(Etrough_tonic_skipped, aes(x = Etrough_tonic)) +
  geom_histogram(
    color = 'black',
    fill = 'green',
    binwidth = 0.1,
    alpha = 0.5
  ) +
  geom_vline(
    aes(xintercept = mean(Etrough_tonic)),
    color = 'black',
    linetype = 'dashed',
    size = 1
  ) +
  geom_density(
    color = 'green4',
    size = 1
  ) +
  scale_x_continuous(
    name = 'Relative change in Etrough (tonic)\n(Etrough - Etrough0)/Etrough0',
    limits = c(-1, 3.5),
    breaks = seq(-1, 3.5, by = 1)
  ) +
  scale_y_continuous(
    name = 'Count',
    limits = c(0, 50),
    breaks = seq(0, 50, by = 10)
  ) +
  labs(title = 'F') +
  vis_theme

# Etrough clonic
Etrough_clonic_missed_hist <- ggplot(Etrough_clonic_missed, aes(x = Etrough_clonic)) +
  geom_histogram(
    color = 'black',
    fill = 'red',
    binwidth = 0.1,
    alpha = 0.5
  ) +
  geom_vline(
    aes(xintercept = mean(Etrough_clonic)),
    color = 'black',
    linetype = 'dashed',
    size = 1
  ) +
  geom_density(
    color = 'red4',
    size = 1
  ) +
  scale_x_continuous(
    name = 'Relative change in Etrough (clonic)\n(Etrough - Etrough0)/Etrough0',
    limits = c(-1, 3.5),
    breaks = seq(-1, 3.5, by = 1)
  ) +
  scale_y_continuous(
    name = 'Count',
    limits = c(0, 50),
    breaks = seq(0, 50, by = 10)
  ) +
  labs(title = 'G') +
  vis_theme

Etrough_clonic_double_hist <- ggplot(Etrough_clonic_double, aes(x = Etrough_clonic)) +
  geom_histogram(
    color = 'black',
    fill = 'blue',
    binwidth = 0.1,
    alpha = 0.5
  ) +
  geom_vline(
    aes(xintercept = mean(Etrough_clonic)),
    color = 'black',
    linetype = 'dashed',
    size = 1
  ) +
  geom_density(
    color = 'blue4',
    size = 1
  ) +
  scale_x_continuous(
    name = 'Relative change in Etrough (clonic)\n(Etrough - Etrough0)/Etrough0',
    limits = c(-1, 3.5),
    breaks = seq(-1, 3.5, by = 1)
  ) +
  scale_y_continuous(
    name = 'Count',
    limits = c(0, 50),
    breaks = seq(0, 50, by = 10)
  ) +
  labs(title = 'H') +
  vis_theme

Etrough_clonic_skipped_hist <- ggplot(Etrough_clonic_skipped, aes(x = Etrough_clonic)) +
  geom_histogram(
    color = 'black',
    fill = 'green',
    binwidth = 0.1,
    alpha = 0.5
  ) +
  geom_vline(
    aes(xintercept = mean(Etrough_clonic)),
    color = 'black',
    linetype = 'dashed',
    size = 1
  ) +
  geom_density(
    color = 'green4',
    size = 1
  ) +
  scale_x_continuous(
    name = 'Relative change in Etrough (clonic)\n(Etrough - Etrough0)/Etrough0',
    limits = c(-1, 3.5),
    breaks = seq(-1, 3.5, by = 1)
  ) +
  scale_y_continuous(
    name = 'Count',
    limits = c(0, 50),
    breaks = seq(0, 50, by = 10)
  ) +
  labs(title = 'I') +
  vis_theme
# ==============================================================================
# combine histogram figure (AUC, AUEC (tonic), AUEC (clonic))
# adjust axis dimension
figure_histogram_1 <-(AUC_missed_hist | AUC_double_hist | AUC_skipped_hist) / (AUEC_tonic_missed_hist | AUEC_tonic_double_hist | AUEC_tonic_skipped_hist) / (AUEC_clonic_missed_hist | AUEC_clonic_double_hist | AUEC_clonic_skipped_hist)

ggsave(filename = 'figure_histogram_1.png', plot = figure_histogram_1, width = 24, height = 24 )

# combine histogram figure (Ctrough, Etrough (tonic), Etrough(clonic))
figure_histogram_2 <-(Ctrough_missed_hist | Ctrough_double_hist | Ctrough_skipped_hist) / (Etrough_tonic_missed_hist | Etrough_tonic_double_hist | Etrough_tonic_skipped_hist) / (Etrough_clonic_missed_hist | Etrough_clonic_double_hist | Etrough_clonic_skipped_hist)

ggsave(filename = 'figure_histogram_2.png', plot = figure_histogram_2, width = 24, height = 24 )