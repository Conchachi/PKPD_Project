clear all;
close all;

%% Missed Dose Analysis

% Repeated doses, 400 mg every 12 hours
% PARAMETERS
q = 0;     % units: nmol/hr
V = 21.9; % units: L (volume of distribution)
kA  =  3.83; % units: 1/hr (absorption rate constant)
kCL = 0.113; %units: 1/hr (clearance rate constant)
Dose = 400; %mg
TimeLen = 12; %hours between doses
MASS_BAL_VIS = 0; %Set to 1 to visualize mass balance
DOSEFREQ = 1; %Set to 0 for single dose, 1 for repeated dosing
IC50 = 2.43; %mg/L
Kd = 1.3617; % units: mg/L

% Choose dose to miss 
MISSED = 0; 
% 0 = no missed doses 
% 1 = 1 missed dose
% 2 = 2 consecutive missed dose
% 3 = 3 consecutive missed dose
% 4 = 4 consecutive missed dose

Conc_missed = [];
Receptor_missed = [];
Effect_missed = [];
Ptonic_missed = [];
Pclonic_missed = [];

%Missed doses
for MISSED = 1:4
[y_m,t_m,auc_m(MISSED),ctrough_m(MISSED),receptor_m,effect_m,P_tonic_m,P_clonic_m,AUEC_tonic(MISSED) ,E_tonic_trough(MISSED) ,AUEC_clonic(MISSED) ,E_clonic_trough(MISSED)] = Levetiracetam_sim_missed_dose_consecutive(kA,V,kCL,Dose,TimeLen,q,IC50,Kd,0,1,MISSED);

% Calculate Cmin and Cmax for missed doses
y_trough = y_m(240:length(y_m));
ptonic_trough = P_tonic_m(240:length(P_tonic_m));
pclonic_trough = P_clonic_m(240:length(P_clonic_m));
Cmin(MISSED) = min(y_trough, [], 'all');
Cmax(MISSED) = max(y_m, [], 'all');
Tonic_min(MISSED) = min(ptonic_trough, [], 'all');
Tonic_max(MISSED) = max(P_tonic_m, [], 'all');
Clonic_min(MISSED) = min(pclonic_trough, [], 'all');
Clonic_max(MISSED) = max(P_clonic_m, [], 'all');

%% Save concentration and effect data for each missed dose case
Conc_missed = [Conc_missed y_m];
Receptor_missed = [Receptor_missed receptor_m];
Effect_missed = [Effect_missed effect_m];
Ptonic_missed = [Ptonic_missed P_tonic_m];
Pclonic_missed = [Pclonic_missed P_clonic_m];
end

%% Save data for missed dosing to import into R

% Columns correspond with 1 missed dose, 2 missed dose, 3 missed dose, 
% 4 missed dose

save PKPD_Project_Levetiracetam_APP/data/MissedDoseConsecutiveConc.mat Conc_missed;
t_m = t_m'; % optimize for R visualization
save PKPD_Project_Levetiracetam_APP/data/MissedDoseConsecutiveTime.mat t_m;
save PKPD_Project_Levetiracetam_APP/data/MissedDoseConsecutiveAUC.mat auc_m;
save PKPD_Project_Levetiracetam_APP/data/MissedDoseConsecutiveCtrough.mat ctrough_m;
save PKPD_Project_Levetiracetam_APP/data/MissedDoseConsecutiveReceptor.mat Receptor_missed;
save PKPD_Project_Levetiracetam_APP/data/MissedDoseConsecutiveEffect.mat Effect_missed;
save PKPD_Project_Levetiracetam_APP/data/MissedDoseConsecutiveP_tonic.mat Ptonic_missed;
save PKPD_Project_Levetiracetam_APP/data/MissedDoseConsecutiveP_clonic.mat Pclonic_missed;
save PKPD_Project_Levetiracetam_APP/data/MissedDoseConsecutiveAUEC_tonic.mat AUEC_tonic;
save PKPD_Project_Levetiracetam_APP/data/MissedDoseConsecutiveAUEC_clonic.mat AUEC_clonic;
save PKPD_Project_Levetiracetam_APP/data/MissedDoseConsecutiveE_tonic_trough.mat E_tonic_trough;
save PKPD_Project_Levetiracetam_APP/data/MissedDoseConsecutiveE_clonic_trough.mat E_clonic_trough;


