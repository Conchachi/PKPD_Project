# Load packages
library('R.matlab')
library('tidyverse')
library('patchwork')

# ==============================================================================
# Data manipulation
Conc_missed <- as.data.frame(readMat('missed_dose_data/MissedDoseConc.mat'))
t_m <- as.data.frame(readMat('missed_dose_data/MissedDoseTime.mat'))
auc_m <- as.data.frame(readMat('missed_dose_data/MissedDoseAUC.mat'))
ctrough_m <- as.data.frame(readMat('missed_dose_data/MissedDoseCtrough.mat'))
Receptor_missed <- as.data.frame(readMat('missed_dose_data/MissedDoseReceptor.mat'))
Effect_missed <- as.data.frame(readMat('missed_dose_data/MissedDoseEffect.mat'))
Ptonic_missed <- as.data.frame(readMat('missed_dose_data/MissedDoseP_tonic.mat'))
Pclonic_missed <- as.data.frame(readMat('missed_dose_data/MissedDoseP_clonic.mat'))
AUEC_tonic <- as.data.frame(readMat('missed_dose_data/MissedDoseAUEC_tonic.mat'))
AUEC_clonic <- as.data.frame(readMat('missed_dose_data/MissedDoseAUEC_clonic.mat'))
E_tonic_trough <- as.data.frame(readMat('missed_dose_data/MissedDoseE_tonic_trough.mat'))
E_clonic_trough <- as.data.frame(readMat('missed_dose_data/MissedDoseE_clonic_trough.mat'))

# Helper function for pivoting
pivot_helper <- function(df, val_name) {
  col_names <- c('2.4', '4.8', '7.2', '9.6', '12', 'Skipped')
  col_names <- append(col_names, 't')
  names(df) <- col_names
  return(pivot_longer(df, 
                      cols = -'t',
                      names_to = 'Missed',
                      values_to=val_name))
  
  
}

# Add in time
Conc_missed <- cbind(Conc_missed, t_m)
Ptonic_missed <- cbind(Ptonic_missed, t_m)
Pclonic_missed <- cbind(Pclonic_missed, t_m)


# Do pivots
Conc_missed_pivot <- pivot_helper(Conc_missed, 'Conc')
Ptonic_missed_pivot <- pivot_helper(Ptonic_missed, 'Ptonic')
Pclonic_missed_pivot <- pivot_helper(Pclonic_missed, 'Pclonic')

# Combine
df_missed <- cbind(Conc_missed_pivot, Ptonic_missed_pivot['Ptonic'])
df_missed <- cbind(df_missed, Pclonic_missed_pivot['Pclonic'])

# ==============================================================================
# PLOTTING
# Create a theme
my_theme <- theme_classic() +
  theme(text = element_text(size = 20),
        plot.title = element_text(hjust = 0.5),
        axis.title.x = element_text(margin = margin(10,0,0,0)),
        axis.title.y = element_text(margin = margin(0,10,0,0)),
        axis.text.x = element_text(margin = margin(5,0,0,0)),
        axis.text.y = element_text(margin = margin(0,5,0,0)))
LINE_THICKNESS = 1

# Plot 1: concentration vs time
conc <- ggplot(data = df_missed,
                    aes(
                      x = t, 
                      y = Conc, 
                      color = Missed
                      )
                    ) +
  geom_line(size = LINE_THICKNESS) +
  labs(
    title = 'Levetiracetam Concentration Over Time',
    x = 'Time (h)',
    y = '[D] (mg/L)'
    ) +
  scale_color_brewer(name = 'Missed Dose (h)', palette = 'Accent') +
  my_theme 
conc
ggsave('plots/missed_dose_conc_time.pdf', width=8, height=5)

# Plot 2: tonic seizure protection % vs time
tonic <- ggplot(data = df_missed,
                     aes(
                       x = t, 
                       y = Ptonic, 
                       color = Missed
                     )
) +
  geom_line(size = LINE_THICKNESS) +
  labs(
    title = 'Tonic Seziure Protection Over Time',
    x = 'Time (h)',
    y = 'Protection From Seziures (%)'
  ) +
  scale_color_brewer(name = 'Missed Dose (h)', palette = 'Accent') +
  ylim(0, 100) +
  my_theme 
tonic
ggsave('plots/missed_dose_tonic_time.pdf', width=8, height=5)

# Plot 3: clonic seizure protection % vs time
clonic <- ggplot(data = df_missed,
                 aes(
                   x = t, 
                   y = Pclonic, 
                   color = Missed
                 )
) +
  geom_line(size = LINE_THICKNESS) +
  labs(
    title = 'Clonic Seziure Protection Over Time',
    x = 'Time (h)',
    y = 'Protection From Seziures (%)'
  ) +
  scale_color_brewer(name = 'Missed Dose (h)', palette = 'Accent') +
  ylim(0, 100) +
  my_theme 
clonic
ggsave('plots/missed_dose_clonic_time.pdf', width=8, height=5)
