clear all;
close all;

%% STEP 1:
%Build model, mass/mole balance

%% PARAMETERS
q = 0;     % units: nmol/hr
V = 21.9; % units: L (volume of distribution)
kA  =  3.83; % units: 1/hr (absorption rate constant)
kCL = 0.113; %units: 1/hr (clearance rate constant)
IC50 = 2.43; %mg/L
Kd = 1.3617; % units: mg/L
MISSED = 0; %for missed dose analysis, not relevant here

%% Single dose, 400 mg (To compare to Chhun et al figure-Figure 4)
Dose = 400; %mg
TimeLen = 14; %hours between doses
MASS_BAL_VIS = 0; %Set to 1 to visualize mass balance
DOSEFREQ = 0; %Set to 0 for single dose, 1 for repeated dosing

%Run simulation for single dose and print concentrations, amounts, and mass balance
[Conc,Time,AUC0,Ctrough0,Receptor,Effect,P_tonic,P_clonic,AUEC_tonic,E_tonic_trough,AUEC_clonic,E_clonic_trough] = Levetiracetam_sim(kA,V,kCL,Dose,TimeLen,q,IC50,Kd,MASS_BAL_VIS,DOSEFREQ,MISSED);

%Import into R to plot
single_dose_conc = [Conc(:,1), Time];
save build_model_data/SingleDoseComparisonConc.mat single_dose_conc;
%save build_model_data/SingleDoseComparisonTime.mat Time;

%% Single dose, 400 mg (Figure 5A and Figure 3 mass balance for single dose)
Dose = 400; %mg
TimeLen = 12; %hours between doses
MASS_BAL_VIS = 1; %Set to 1 to visualize mass balance
DOSEFREQ = 0; %Set to 0 for single dose, 1 for repeated dosing

%Run simulation for single dose and print concentrations, amounts, and mass balance
[Conc,Time,AUC0,Ctrough0,Receptor,Effect,P_tonic,P_clonic,AUEC_tonic,E_tonic_trough,AUEC_clonic,E_clonic_trough] = Levetiracetam_sim(kA,V,kCL,Dose,TimeLen,q,IC50,Kd,MASS_BAL_VIS,DOSEFREQ,MISSED);

%Import into R to plot
single_dose_conc = Conc(:,1);
save build_model_data/SingleDoseConc.mat single_dose_conc;
save build_model_data/SingleDoseTime.mat Time;

%% Repeated dose, 400 mg (Figure 3 to generate mass balance output for repeated dosing)
Dose = 400; %mg
TimeLen = 12; %hours between doses
MASS_BAL_VIS = 1; %Set to 1 to visualize mass balance
DOSEFREQ = 1; %Set to 0 for single dose, 1 for repeated dosing

%Run simulation for single dose and print concentrations, amounts, and mass balance
[Conc,Time,AUC0,Ctrough0,Receptor,Effect,P_tonic,P_clonic,AUEC_tonic,E_tonic_trough,AUEC_clonic,E_clonic_trough] = Levetiracetam_sim(kA,V,kCL,Dose,TimeLen,q,IC50,Kd,MASS_BAL_VIS,DOSEFREQ,MISSED);

Rep_conc = Conc(:,1);
save build_model_data/RepeatedDoseConc.mat Rep_conc;
save build_model_data/RepeatedDoseTime.mat Time;
save build_model_data/RepeatedDoseP_clonic.mat P_clonic;
save build_model_data/RepeatedDoseP_tonic.mat P_tonic;

%Save to data folder for Shiny App
save PKPD_Project_Levetiracetam_APP/data/RepeatedDoseConc.mat Rep_conc;
save PKPD_Project_Levetiracetam_APP/data/RepeatedDoseTime.mat Time;
save PKPD_Project_Levetiracetam_APP/data/RepeatedDoseP_clonic.mat P_clonic;
save PKPD_Project_Levetiracetam_APP/data/RepeatedDoseP_tonic.mat P_tonic;

%% STEP 2:
% Identify and simulate key time-dependent variables for a range of doses

% Repeated doses, every 12 hours

%Pediatric population data
q = 0;     % units: nmol/hr
V = 21.9; % units: L (volume of distribution)
kA  =  3.83; % units: 1/hr (absorption rate constant)
kCL = 0.113; %units: 1/hr (clearance rate constant)
IC50 = 2.43; %mg/L
Kd = 1.3617; % units: mg/L
MISSED = 0; %for missed dose analysis, not relevant here

%% SIMULATIONS

% Simulate range of doses for key PK/PD variables: 
% Concentration in central compartment
% Receptor occupancy (2 models)
% Protection from tonic seizures
% Protection from clonic seizures

% Initialize matrices to store outputs
Conc = [];
Time = [];
Receptor = [];
Effect = [];
P_tonic = [];
P_clonic = [];

%Simulate range of drug doses 100-600mg
for i=1:6
    Dose = 100*i;
    [Conc1, Time1, AUC(i), Ctrough(i), Receptor1, Effect1, P_tonic1, P_clonic1, AUEC_tonic(i) ,E_tonic_trough(i) ,AUEC_clonic(i) ,E_clonic_trough(i)] = Levetiracetam_sim(kA,V,kCL,Dose,TimeLen,q,IC50,Kd,0,1,0);
    Conc = [Conc Conc1];
    Time = [Time Time1'];
    Receptor = [Receptor Receptor1];
    Effect = [Effect Effect1];
    P_tonic = [P_tonic P_tonic1];
    P_clonic = [P_clonic P_clonic1];
end

% Save data for repeated dosing for range of drug doses to import into R
%Columns correspond to drug doses: 100, 200, 300, 400, 500, and 600 mg
time = Time(:,1);
save build_model_data/DoseRangeConc.mat Conc;
save build_model_data/DoseRangeTime.mat Time;
save build_model_data/DoseRangeAUC.mat AUC;
save build_model_data/DoseRangeCtrough.mat Ctrough;
save build_model_data/DoseRangeReceptor.mat Receptor;
save build_model_data/DoseRangeEffect.mat Effect;
save build_model_data/DoseRangeP_tonic.mat P_tonic;
save build_model_data/DoseRangeP_clonic.mat P_clonic;
save build_model_data/DoseRangeAUEC_tonic.mat AUEC_tonic;
save build_model_data/DoseRangeAUEC_clonic.mat AUEC_clonic;
save build_model_data/DoseRangeE_tonic_trough.mat E_tonic_trough;
save build_model_data/DoseRangeE_clonic_trough.mat E_clonic_trough;

