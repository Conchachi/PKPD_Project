# PKPD_Project

- Levetiracetam_eqns.m contains the PK model equations.
- Levetiracetam_sim.m is the function called to run the simulation. This function outputs all of the key metrics (concentrations, effects, AUC, AUEC, Ctrough, and Etrough)
- Levetiracetam_build_model.m builds the model and generates the data for Figures 3-6.
- Mass_balance_vis.R generates Figure 3.
- Lev_ConcCurve.R generates Figure 4.
- Single_dose_repeated_dose.R generates Figures 5 and 6.
- LEV_Sens_Analysis.m runs the local sensitivity analysis and generates the data for Figure 7.
- LEV_Sens_Analysis.R generates Figure 7.
- LEV_GSA.m runs the global sensitivity analysis and generates the data for Figure 8.
- LEV_GSA.R generates Figure 8. 
- LEV_PopVar.m generates a virtual population and runs the population variability analysis, outputting the data for Figures 9-11.
- LEV_PopVar.R generates Figures 9-11.
- LEV_missed_dose.m runs the missed dose analysis and generates data for Figures 12-14.
- LEV_missed_dose_vis.R generates Figures 12. 
- missed_dose_pop_histogram.R generates Figures 13 and 14.
- Levetiracetam_sim_missed_dose_consecutive.m is the function called to run the missed dose simulation for consecutive missed doses. 
- LEV_missed_dose_consecutive.m runs the consecutive missed dose analysis and generates data for the Shiny app (Figure 17).
- app.R generates the Shiny app.

To generate the desired data and Figures, first run all the MATLAB code files in this order:
1. Levetiracetam_build_model.m
2. LEV_Sens_Analysis.m
3. LEV_GSA.m
4. LEV_PopVar.m
5. LEV_missed_dose.m
6. LEV_missed_dose_consecutive.m

Then run the visualization code to generate the figures and app:
1. Mass_balance_vis.R (Figure 3)
2. Lev_ConcCurve.R (Figure 4)
3. single_dose_repeated_dose.R (Figures 5 and 6)
4. LEV_Sens_Analysis.R (Figure 7)
5. LEV_GSA.R (Figure 8)
6. LEV_PopVar.R (Figures 9-11)
7. LEV_missed_dose_vis.R (Figure 12)
8. missed_dose_pop_histogram.R (Figures 13 and 14)
9. app.R (Shiny App: link access: https://connie-chang-chien.shinyapps.io/PKPD_Project_Levetiracetam/?_ga=2.144305398.210535369.1651115737-794475808.1649938165)
