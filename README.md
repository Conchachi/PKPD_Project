# PKPD_Project

- Levetiracetam_eqns.m contains the PK model equations.
- Levetiracetam_sim.m is the function called to run the simulation. This function outputs all of the key metrics (concentrations, effects, AUC, AUEC, Ctrough, and Etrough)
- Levetiracetam_build_model.m builds the model and generates the data for Figures 2 and 3.
- Single_dose_repeated_dose.R generates Figures 2 and 3. (You have to set the working directory to the repeated_dose_data subfolder when run in R.)
- LEV_Sens_Analysis.m runs the local sensitivity analysis and generates the data for Figure 4.
- LEV_Sens_Analysis.R generates Figure 4. (You have to set the working directory to the sens_analysis_data subfolder when run in R.)
- LEV_GSA.m runs the global sensitivity analysis and generates the data for Figure 5.
- LEV_GSA.R generates Figure 5. (You have to set the working directory to the sens_analysis_data subfolder when run in R.)
- LEV_PopVar.m generates a virtual population and runs the population variability analysis, outputting the data for Figures 6, 7, and 8.
- LEV_PopVar.R generates Figures 6, 7, and 8. (You have to set the working directory to the pop_var_data subfolder when run in R.)
- LEV_missed_dose.m runs the missed dose analysis and generates data for figures 9, 10, and 11.
- LEV_missed_dose_vis.R generates figures 9, 10, and 11. (You have to set the working directory to the main folder, not the subfolder, to generate these figures)
- Levetiracetam_sim_missed_dose_consecutive.m is the function called to run missed dose simulation for consecutive missed doses. 
- LEV_missed_dose_consecutive.m runs the consecutive missed dose analysis and generates the data for the Shiny app (figure 12).
- app.R generates the shiny app.

To generate the desired data, run the code in this order:
1. Levetiracetam_build_model.m
2. LEV_Sens_Analysis.m
3. LEV_GSA.m
4. LEV_PopVar.m
5. LEV_missed_dose.m
6. LEV_missed_dose_consecutive.m
7. LEV App (Link access: https://connie-chang-chien.shinyapps.io/PKPD_Project_Levetiracetam/?_ga=2.144305398.210535369.1651115737-794475808.1649938165)
