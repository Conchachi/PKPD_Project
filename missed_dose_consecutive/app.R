# ====================================================================================
# PKPD Levetiracetam Interactive Model App

# Builds a Shiny app to model missed dose analysis, accept one user input
# in the form of choosing the time at which the missed dose is taken after the
# normal dose time, and displays three outputs - AUC, protection against clonic seizures,
# and protection against tonic seizures

# ====================================================================================
# LOAD PACKAGES

library(R.matlab)
library(shiny)
library(tidyverse)
library(patchwork)
library(plotly)
library(shiny)
library(tidyr)
library(dplyr)
library(readr)
library(ggplot2)
library(reshape2)
library(shinydashboardPlus)
library(shinythemes)


# ====================================================================================
# DATA IMPORT

Conc_missed <- as.data.frame(readMat('data/MissedDoseConsecutiveConc.mat'))
t_m <- as.data.frame(readMat('data/MissedDoseConsecutiveTime.mat'))
auc_m <- as.data.frame(readMat('data/MissedDoseConsecutiveAUC.mat'))
ctrough_m <- as.data.frame(readMat('data/MissedDoseConsecutiveCtrough.mat'))
Receptor_missed <-
  as.data.frame(readMat('data/MissedDoseConsecutiveReceptor.mat'))
Effect_missed <- as.data.frame(readMat('data/MissedDoseConsecutiveEffect.mat'))
Ptonic_missed <-
  as.data.frame(readMat('data/MissedDoseConsecutiveP_tonic.mat'))
Pclonic_missed <-
  as.data.frame(readMat('data/MissedDoseConsecutiveP_clonic.mat'))
AUEC_tonic <-
  as.data.frame(readMat('data/MissedDoseConsecutiveAUEC_tonic.mat'))
AUEC_clonic <-
  as.data.frame(readMat('data/MissedDoseConsecutiveAUEC_clonic.mat'))
E_tonic_trough <-
  as.data.frame(readMat('data/MissedDoseConsecutiveE_tonic_trough.mat'))
E_clonic_trough <-
  as.data.frame(readMat('data/MissedDoseConsecutiveE_clonic_trough.mat'))

# ===== 
# Normal Dosing Comparisons
conc_normal <- 
  as.data.frame(readMat('data/RepeatedDoseConc.mat'))
Pclonic_norm <-
  as.data.frame(readMat('data/RepeatedDoseP_clonic.mat'))
Ptonic_norm <- 
  as.data.frame(readMat('data/RepeatedDoseP_tonic.mat'))
t_norm <- 
  as.data.frame(readMat('data/RepeatedDoseTime.mat'))



# ====================================================================================
# DATA MANIPULATION
# Helper function for pivoting
pivot_helper <- function(df, val_name) {
  col_names <- c('1', '2', '3', '4')
  col_names <- append(col_names, 't')
  names(df) <- col_names
  return(pivot_longer(
    df,
    cols = -'t',
    names_to = 'Missed',
    values_to = val_name
  ))
  
  
}

# Add in time
Conc_missed <- cbind(Conc_missed, t_m)
Ptonic_missed <- cbind(Ptonic_missed, t_m)
Pclonic_missed <- cbind(Pclonic_missed, t_m)

conc_normal <- cbind(conc_normal, t_m)
colnames(conc_normal) <- c('Conc', 't')
Pclonic_norm <- cbind(Pclonic_norm, t_m)
colnames(Pclonic_norm) <- c('Pclonic', 't')
Ptonic_norm <- cbind(Ptonic_norm, t_m)
colnames(Ptonic_norm) <- c('Ptonic', 't')

# Do pivots
Conc_missed_pivot <- pivot_helper(Conc_missed, 'Conc')
Ptonic_missed_pivot <- pivot_helper(Ptonic_missed, 'Ptonic')
Pclonic_missed_pivot <- pivot_helper(Pclonic_missed, 'Pclonic')

# Combine
df_missed <- cbind(Conc_missed_pivot, Ptonic_missed_pivot['Ptonic'])
df_missed <- cbind(df_missed, Pclonic_missed_pivot['Pclonic'])
# ====================================================================================
# Plotting
# Create a theme
my_theme <- theme_classic() +
  theme(
    text = element_text(size = 20),
    plot.title = element_text(hjust = 0.5),
    axis.title.x = element_text(margin = margin(10, 0, 0, 0)),
    axis.title.y = element_text(margin = margin(0, 10, 0, 0)),
    axis.text.x = element_text(margin = margin(5, 0, 0, 0)),
    axis.text.y = element_text(margin = margin(0, 5, 0, 0))
  )
LINE_THICKNESS = 1

# Plot 1: concentration vs time
conc <- ggplot(data = NULL) +
  geom_line(size = LINE_THICKNESS) +
  geom_line(data = conc_normal, 
            aes(x= t,
                y= Conc))+
  labs(title = 'Levetiracetam Concentration Over Time',
       x = 'Time (h)',
       y = '[D] (mg/L)') +
  scale_color_brewer(name = '# Missed Dose', palette = 'Accent') +
  my_theme
conc

# Plot 1.5: concentration (missed dose) vs time
conc_mis <- ggplot(data = NULL) +
  geom_line(size = LINE_THICKNESS) +
  geom_line(data = df_missed, 
            aes(x= t,
                y= Conc,
                color = Missed))+
  labs(title = 'Levetiracetam Concentration Over Time',
       x = 'Time (h)',
       y = '[D] (mg/L)') +
  scale_color_brewer(name = '# Missed Dose', palette = 'Accent') +
  my_theme
conc_mis

# Plot 2: tonic seizure protection % vs time
tonic <- ggplot(data = df_missed,
                aes(x = t,
                    y = Ptonic,
                    color = Missed)) +
  geom_line(size = LINE_THICKNESS) +
  labs(title = 'Tonic Seizure Protection Over Time',
       x = 'Time (h)',
       y = 'Protection From Seizures (%)') +
  scale_color_brewer(name = '# Missed Dose', palette = 'Accent') +
  my_theme
tonic


# Plot 3: clonic seizure protection % vs time
clonic <- ggplot(data = df_missed,
                 aes(x = t,
                     y = Pclonic,
                     color = Missed)) +
  geom_line(size = LINE_THICKNESS) +
  labs(title = 'Clonic Seizure Protection Over Time',
       x = 'Time (h)',
       y = 'Protection From Seizures (%)') +
  scale_color_brewer(name = '# Missed Dose', palette = 'Accent') +
  my_theme
clonic