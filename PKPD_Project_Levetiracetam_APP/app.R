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

# DATA FOR TIME CHANGE
Conc_missed <- as.data.frame(readMat('data/MissedDoseConc.mat'))
t_m <- as.data.frame(readMat('data/MissedDoseTime.mat'))
auc_m <- as.data.frame(readMat('data/MissedDoseAUC.mat'))
ctrough_m <- as.data.frame(readMat('data/MissedDoseCtrough.mat'))
Receptor_missed <-
  as.data.frame(readMat('data/MissedDoseReceptor.mat'))
Effect_missed <- as.data.frame(readMat('data/MissedDoseEffect.mat'))
Ptonic_missed <-
  as.data.frame(readMat('data/MissedDoseP_tonic.mat'))
Pclonic_missed <-
  as.data.frame(readMat('data/MissedDoseP_clonic.mat'))
AUEC_tonic <-
  as.data.frame(readMat('data/MissedDoseAUEC_tonic.mat'))
AUEC_clonic <-
  as.data.frame(readMat('data/MissedDoseAUEC_clonic.mat'))
E_tonic_trough <-
  as.data.frame(readMat('data/MissedDoseE_tonic_trough.mat'))
E_clonic_trough <-
  as.data.frame(readMat('data/MissedDoseE_clonic_trough.mat'))

# DATA FOR NUMBER OF DOSES

Conc_missedr <-
  as.data.frame(readMat('data/MissedDoseConsecutiveConc.mat'))
Ptonic_missedr <-
  as.data.frame(readMat('data/MissedDoseConsecutiveP_tonic.mat'))
Pclonic_missedr <-
  as.data.frame(readMat('data/MissedDoseConsecutiveP_clonic.mat'))
t_mr <- as.data.frame(readMat('data/MissedDoseConsecutiveTime.mat'))

# =====
# Normal Dosing Comparisons
conc_normal <-
  as.data.frame(readMat('data/RepeatedDoseConc.mat'))
Pclonic_norm <-
  as.data.frame(readMat('data/RepeatedDoseP_clonic.mat'))
Ptonic_norm <-
  as.data.frame(readMat('data/RepeatedDoseP_tonic.mat'))
t_norm <-
  as.data.frame(readMat('data/MissedDoseTime.mat'))


# ====================================================================================
# DATA MANIPULATION for Time Change
# Helper function for pivoting
pivot_helper <- function(df, val_name) {
  col_names <- c('2.4', '4.8', '7.2', '9.6', '12', 'Skipped', 'Normal')
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
conc_normal <- cbind(conc_normal, t_norm)
Pclonic_norm <- cbind(Pclonic_norm, t_norm)
Ptonic_norm <- cbind(Ptonic_norm, t_norm)

# Do pivots
Conc_missed_pivot <- pivot_helper(Conc_missed, 'Conc')
Ptonic_missed_pivot <- pivot_helper(Ptonic_missed, 'Ptonic')
Pclonic_missed_pivot <- pivot_helper(Pclonic_missed, 'Pclonic')

# Combine
df_missed <- cbind(Conc_missed_pivot, Ptonic_missed_pivot['Ptonic'])
df_missed <- cbind(df_missed, Pclonic_missed_pivot['Pclonic'])

#================================
# DATA CHANGE for Num Dose Change

# Helper function for pivoting
pivot_helperr <- function(df, val_name) {
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
Conc_missedr <- cbind(Conc_missedr, t_mr)
Ptonic_missedr <- cbind(Ptonic_missedr, t_mr)
Pclonic_missedr <- cbind(Pclonic_missedr, t_mr)


# Do pivots
Conc_missed_pivotr <- pivot_helperr(Conc_missedr, 'Conc')
Ptonic_missed_pivotr <- pivot_helperr(Ptonic_missedr, 'Ptonic')
Pclonic_missed_pivotr <- pivot_helperr(Pclonic_missedr, 'Pclonic')

# Combine
df_missedr <-
  cbind(Conc_missed_pivotr, Ptonic_missed_pivotr['Ptonic'])
df_missedr <- cbind(df_missedr, Pclonic_missed_pivotr['Pclonic'])




# ====================================================================================
# Plotting
# Create a theme
my_theme <- theme_classic() +
  theme(
    text = element_text(size = 15),
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
            aes(x = t.m,
                y = Rep.conc)) +
  labs(title = 'Levetiracetam Concentration Over Time',
       x = 'Time (h)',
       y = '[D] (mg/L)') +
  scale_color_brewer(name = 'Missed Dose (h)', palette = 'Accent') +
  my_theme
conc


# Plot 2: tonic seizure protection % vs time
tonic <- ggplot(data = df_missed,
                aes(x = t,
                    y = Ptonic,
                    color = Missed)) +
  geom_line(size = LINE_THICKNESS) +
  labs(title = 'Tonic Seizure Protection Over Time',
       x = 'Time (h)',
       y = 'Protection From Seizures (%)') +
  scale_color_brewer(name = 'Missed Dose (h)', palette = 'Accent') +
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
  scale_color_brewer(name = 'Missed Dose (h)', palette = 'Accent') +
  my_theme
clonic

# ====================================================================================
# APP UI

# Define UI for application that draws a histogram
ui <-
  fluidPage(
    titlePanel(h1(
      strong('PKPD Project: Levetiracetam Missed Dose Analysis')
    )),
    h4(
      'Shiny app modeling Missed Dose Analysis of Levetiracetam. Using literature knowledge of the Pharmacokinetic and Pharmacodynamic properties of Levetiracetam, this app demonstrates the effects of the',
      strong('number of consecutive missed doses'),
      'and the',
      strong('time of the substituted missed dose'),
      '.'
    ),
    
    h5(
      p(
        'Made by Gohta Aihara, Connie Chang-Chien, Jacob Desman, Sarah Kulkarni, and Kaitlyn Storm'
      )
    ),
    
    br(),
    
    #Sidebar layout
    sidebarLayout(
      sidebarPanel(
        width = 3,
        fluidRow(
          sliderInput(
            'timelen',
            label =  h4('Select time range to observe:'),
            min = 0,
            max = 119.95,
            value = c(0, 119.95),
            step = 0.05
          ),
          selectInput(
            'num_skipdose',
            label = h4(
              strong('For NUMBER OF MISSED DOSES'),
              br(),
              'Select the number of consecutive skipped doses:'
            ),
            choices = list('1',
                           '2',
                           '3',
                           '4'),
            selected = '1',
            multiple = TRUE
          ),
          selectInput(
            'time_dif',
            label = h4(
              strong('For TIME OF MISSED DOSE'),
              br(),
              'Select time at which missed dose is taken (hours):'
            ),
            choices = list('2.4',
                           '4.8',
                           '7.2',
                           '9.6',
                           'Skipped'),
            selected = '2.4',
            multiple = TRUE
          ),
          h4(
            'Missed Dose Analysis is Subject to inter-individual variation
                                            based on the optimization of calculated absorbance and clearance constants.'
          )
        ),
        hr()
        #fluidRow(column(3, verbatimTextOutput("md_time"))),
        #fluidRow(column(3, verbatimTextOutput("trange"))),
        
        
      ),
      mainPanel(
        width = 9,
        tabsetPanel(
          type = 'tabs',
          tabPanel(
            h4('PKPD Characteristics and Mechanism of Action'),
            h3(strong('Background')),
            h4(
              'Levetiracetam is one of the many FDA approved anti-epilepsy
                    drugs (AEDs) that are popularly prescribed to control seizures
                    and epileptic disorders. Generally, Levetiracetam has shown
                    consistent results in treating seizures in a variety of adult
                    and pediatric populations, and across a wide spectrum of epilepsy
                    disorders such as myoclonic seizures and tonic-clonic seizures.
                    In this day and age, there are several other FDA approved AEDs
                    that are available to treat seizures, but given the unique chemical
                    structure of this drug compared to other AEDs, as well as its still
                    vague mechanism of action, this warrants further investigation into
                    the pharmacokinetics and pharmacodynamics of the drug.'
            ),
            tags$img(src = 'https://www.drugs.com/img/mol/DB01202.mol.t.png'),
            h5(
              em('DrugBank. (2022). Levetiracetam'),
              br(),
              h3(strong('Pharmacokinetic Characteristics')),
              h4(
                'Notably, Levetiracetam possesses several interesting pharmacokinetic
                    properties that make it an ideal drug of interest -
                    it is rapidly absorbed within 1.3 hours, with a bioavailability of
                    >95%. It can be modeled as a one-compartment model due to its equal distribution
                    through the body. Around ⅔ of the drug will be cleared via renal excretion
                    unmetabolized, with minimal metabolization by the liver,
                    with renal clearance dependent on creatinine clearance.
                    As of the most recent research, the drug also does not seem
                    to have any interactions with other AEDs and plasma proteins,
                    and also maintains low intra-subject and inter-subject variability,
                    as compared to other AEDs.'
              ),
              br(),
              h4(
                'These pharmacokinetic properties subsequently make Levetiracetam
                    an ideal drug to study. In our models and data, we visualized how',
                strong('Missed Dose'),
                'affected concentrations of Levetiracetam in
                    simulated pediatric populations, as well as clonic and tonic seizure
                    protection.'
              ),
              br(),
              h3(strong('Mechanism of Action')),
              h4(
                'Levetiracetam’s main target is synaptic vesicle protein 2A (SV2A),
                    a widely distributed isoform throughout the entire central nervous system.
                    Although other isoforms, such as SV2B and SV2C, are brain-specific,
                    seizures are more prevalent in SV2A knockout (KO) mice than SV2B KO,
                    supporting SV2A as a drug target'
              ),
              tags$img(src = 'https://www.researchgate.net/profile/Karen_Garlitz/publication/276209133/figure/download/fig2/AS:614275974459427@1523466213864/Pre-and-post-excitatory-neuron-with-neurotransmitter-glutamate-Mechanism-of-action-of.png'),
              h5(
                'Landmark, C.J.',
                em('CNS Drugs'),
                ',2008; Deshpande, L.S., Front Neurol, 2014; Mruk, A.L., et al.,',
                em(' Pediatr Pharmacol Ther'),
                ', 2015'
              )
            )
          ),
          tabPanel(
            h4('Number of Missed Doses'),
            verticalLayout(
              h3(
                strong(
                  'The plots shown below can interactively illustrate the effects of changing the number of consecutive missed doses.'
                )
              ),
              br(),
              column(12, plotlyOutput(outputId = "concrplot")),
              br(),
              h4(
                'Figure 1: Plot modeling Levetiracetam Concentration over Time, Comparing Regular Dosing (Black) to Missed Dose (Green). Parameters are set as a regular 400 mg dose being taken every 12 hours.'
              ),
              br(),
              column(12, plotlyOutput(outputId = 'clonicrplot')),
              br(),
              h4(
                'Figure 2: Plot modeling Clonic Seizure Protection over Time, Comparing Regular Dosing (Black) to Missed Dose (Green). Parameters are set as a regular 400 mg dose being taken every 12 hours.'
              ),
              br(),
              column(12, plotlyOutput(outputId = 'tonicrplot')),
              br(),
              h4(
                'Figure 3: Plot modeling Tonic Seizure Protection over Time, Comparing Regular Dosing (Black) to Missed Dose (Green). Parameters are set as a regular 400 mg dose being taken every 12 hours.'
              )
            )
          ),
          tabPanel(
            h4('Time of Missed Dose'),
            verticalLayout(
              h3(
                strong(
                  'The plots shown below can interactively illustrate the effects of changing the time of the substituted missed dose.'
                )
              ),
              br(),
              column(12, plotlyOutput(outputId = "concplot")),
              br(),
              h4(
                'Figure 1: Plot modeling Levetiracetam Concentration over Time, Comparing Regular Dosing (Black) to Missed Dose (Green). Parameters are set as a regular 400 mg dose being taken every 12 hours.'
              ),
              br(),
              column(12, plotlyOutput(outputId = 'clonicplot')),
              br(),
              h4(
                'Figure 2: Plot modeling Clonic Seizure Protection over Time, Comparing Regular Dosing (Black) to Missed Dose (Green). Parameters are set as a regular 400 mg dose being taken every 12 hours.'
              ),
              br(),
              column(12, plotlyOutput(outputId = 'tonicplot')),
              br(),
              h4(
                'Figure 3: Plot modeling Tonic Seizure Protection over Time, Comparing Regular Dosing (Black) to Missed Dose (Green). Parameters are set as a regular 400 mg dose being taken every 12 hours.'
              )
            )
          )
        )
      )
    )
  )





# =====================================================================================
# App Server



server <- function(input, output) {
  output$md_time <- renderPrint({
    input$time_dif
  })
  
  output$trange <- renderPrint({
    input$timelen
  })
  
  output$skipdose <- renderPrint({
    input$num_skipdose
  })
  
  # build concentration plot, dose time change in app
  output$concplot <- renderPlotly({
    concplot <- ggplot(data = df_missed) +
      geom_line(
        data = filter(
          df_missed,
          Missed == input$time_dif,
          t >= input$timelen[1],
          t <= input$timelen[2]
        ),
        aes(x = t,
            y = Conc,
            color = Missed)
      ) +
      geom_line(data = filter(conc_normal, t.m >= input$timelen[1], t.m <= input$timelen[2]),
                aes(x = t.m,
                    y = Rep.conc)) +
      labs(title = 'Levetiracetam Concentration Over Time',
           x = 'Time (h)',
           y = '[D] (mg/L)') +
      scale_color_brewer(name = 'Missed Dose (h)', palette = 'Accent') +
      scale_y_continuous(limits=c(0, 23))+
      my_theme
    plotly_build(concplot)
  })
  
  
  # build clonic plot, dose time change in app
  output$clonicplot <- renderPlotly({
    clonicplot <- ggplot(data = df_missed) +
      geom_line(
        data = filter(
          df_missed,
          Missed == input$time_dif,
          t >= input$timelen[1],
          t <= input$timelen[2]
        ),
        aes(x = t,
            y = Pclonic,
            color = Missed)
      ) +
      geom_line(data = filter(Pclonic_norm, t.m >= input$timelen[1], t.m <= input$timelen[2]),
                aes(x = t.m,
                    y = P.clonic)) +
      labs(title = 'Clonic Seizure Protection Over Time',
           x = 'Time (h)',
           y = 'Protection From Seizures (%)') +
      scale_color_brewer(name = 'Missed Dose (h)', palette = 'Accent') +
      scale_y_continuous(limits=c(0, 100))+
      my_theme
    plotly_build(clonicplot)
  })
  
  
  # build tonic plot, dose time change in app
  output$tonicplot <- renderPlotly({
    tonicplot <- ggplot(data = df_missed) +
      geom_line(
        data = filter(
          df_missed,
          Missed == input$time_dif,
          t >= input$timelen[1],
          t <= input$timelen[2]
        ),
        aes(x = t,
            y = Ptonic,
            color = Missed)
      ) +
      geom_line(data = filter(Ptonic_norm, t.m >= input$timelen[1], t.m <= input$timelen[2]),
                aes(x = t.m,
                    y = P.tonic)) +
      labs(title = 'Tonic Seizure Protection Over Time',
           x = 'Time (h)',
           y = 'Protection From Seizures (%)') +
      scale_color_brewer(name = 'Missed Dose (h)', palette = 'Accent') +
      scale_y_continuous(limits=c(0, 100))+
      my_theme
    plotly_build(tonicplot)
  })
  
  # build concentration plot, num doses in app
  output$concrplot <- renderPlotly({
    concrplot <- ggplot(data = df_missedr) +
      geom_line(
        data = filter(
          df_missedr,
          Missed == input$num_skipdose,
          t >= input$timelen[1],
          t <= input$timelen[2]
        ),
        aes(x = t,
            y = Conc,
            color = Missed)
      ) +
      geom_line(data = filter(conc_normal, t.m >= input$timelen[1], t.m <= input$timelen[2]),
                aes(x = t.m,
                    y = Rep.conc)) +
      labs(title = 'Levetiracetam Concentration Over Time',
           x = 'Time (h)',
           y = '[D] (mg/L)') +
      scale_color_brewer(name = '# Missed Doses', palette = 'Accent') +
      scale_y_continuous(limits=c(0, 23))+
      my_theme
    plotly_build(concrplot)
  })
  
  
  # build clonic plot, num doses in app
  output$clonicrplot <- renderPlotly({
    clonicrplot <- ggplot(data = df_missedr) +
      geom_line(
        data = filter(
          df_missedr,
          Missed == input$num_skipdose,
          t >= input$timelen[1],
          t <= input$timelen[2]
        ),
        aes(x = t,
            y = Pclonic,
            color = Missed)
      ) +
      geom_line(data = filter(Pclonic_norm, t.m >= input$timelen[1], t.m <= input$timelen[2]),
                aes(x = t.m,
                    y = P.clonic)) +
      labs(title = 'Clonic Seizure Protection Over Time',
           x = 'Time (h)',
           y = 'Protection From Seizures (%)') +
      scale_color_brewer(name = '# Missed Doses', palette = 'Accent') +
      scale_y_continuous(limits=c(0, 100))+
      my_theme
    plotly_build(clonicrplot)
  })
  
  
  # build tonic plot, num doses in app
  output$tonicrplot <- renderPlotly({
    tonicrplot <- ggplot(data = df_missedr) +
      geom_line(
        data = filter(
          df_missedr,
          Missed == input$num_skipdose,
          t >= input$timelen[1],
          t <= input$timelen[2]
        ),
        aes(x = t,
            y = Ptonic,
            color = Missed)
      ) +
      geom_line(data = filter(Ptonic_norm, t.m >= input$timelen[1], t.m <= input$timelen[2]),
                aes(x = t.m,
                    y = P.tonic)) +
      labs(title = 'Tonic Seizure Protection Over Time',
           x = 'Time (h)',
           y = 'Protection From Seizures (%)') +
      scale_color_brewer(name = '# Missed Doses', palette = 'Accent') +
      scale_y_continuous(limits=c(0, 100))+
      my_theme
    plotly_build(tonicrplot)
  })
  
  
}

# Run the application
shinyApp(ui = ui, server = server)
