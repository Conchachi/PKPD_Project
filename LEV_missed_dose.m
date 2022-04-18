%% Missed Dose Analysis

% Repeated doses, 500 mg every 12 hours
% PARAMETERS
q = 0;     % units: nmol/hr
V = 42; % units: L (volume of distribution)
kA  =  0.464; % units: 1/hr (absorption rate constant)
kCL = 0.096; %units: 1/hr (clearance rate constant)
Dose = 500; %mg
TimeLen = 12; %hours between doses
MASS_BAL_VIS = 0; %Set to 1 to visualize mass balance
DOSEFREQ = 2; %Set to 0 for single dose, 1 for repeated dosing, 2 for missed dose
IC50 = 2.43; %mg/L
Kd = 1.3617; % units: mg/L

% Choose dose to miss 
MISSED = 0; 
% 0 = no missed doses 
% 1 = missed dose m/5 late
% 2 = missed dose 2m/5 late
% 3 = missed dose 3m/5 late
% 4 = missed dose 4m/5 late
% 5 = missed dose m late (double dose)
% 6 = missed dose (skipped entirely)

Conc_missed = [];
Receptor_missed = [];
Effect_missed = [];
Ptonic_missed = [];
Pclonic_missed = [];

%Missed doses
for MISSED = 1:6
[y_m,t_m,auc_m(MISSED),ctrough_m(MISSED),receptor_m,effect_m,P_tonic_m,P_clonic_m] = Levetiracetam_sim(kA,V,kCL,Dose,TimeLen,q,IC50,Kd,0,1,MISSED);

% Calculate Cmin and Cmax for missed doses
y_trough = y_m(240:length(y_m));
Cmin(MISSED) = min(y_trough, [], 'all');
Cmax(MISSED) = max(y_m, [], 'all');

% Plot concentrations
figure;
plot(t_m, y_m, 'linewidth', 3);
if MISSED ~= 6 
PLOT_title = strcat('Missed Dose Taken', {' '}, string(MISSED*12/5), ' Hours Late');
    if MISSED == 5
        PLOT_title = strcat(PLOT_title, ' (Double Dose)');
    end
else 
    PLOT_title = 'Skipped Dose';
end

title(PLOT_title, 'FontSize', 16);
ylabel('[D] (mg/L)', 'FontSize', 12);
xlabel('Time (hrs)', 'FontSize', 12);
ylim([0 18]);

%Plot tonic seizure protection
figure;
plot(t_m, P_tonic_m, 'linewidth', 3);
if MISSED ~= 6 
PLOT_title = strcat('Missed Dose Taken', {' '}, string(MISSED*12/5), ' Hours Late');
    if MISSED == 5
        PLOT_title = strcat(PLOT_title, ' (Double Dose)');
    end
else 
    PLOT_title = 'Skipped Dose';
end

title(PLOT_title, 'FontSize', 16);
ylabel('Protection From Tonic Seizures (%)', 'FontSize', 12);
xlabel('Time (hrs)', 'FontSize', 12);

%Plot clonic seizure protection
figure;
plot(t_m, P_clonic_m, 'linewidth', 3);
if MISSED ~= 6 
PLOT_title = strcat('Missed Dose Taken', {' '}, string(MISSED*12/5), ' Hours Late');
    if MISSED == 5
        PLOT_title = strcat(PLOT_title, ' (Double Dose)');
    end
else 
    PLOT_title = 'Skipped Dose';
end

title(PLOT_title, 'FontSize', 16);
ylabel('Protection From Clonic Seizures (%)', 'FontSize', 12);
xlabel('Time (hrs)', 'FontSize', 12);


%Save concentration and effect data to plot in R
Conc_missed = [Conc_missed y_m];
Receptor_missed = [Receptor_missed receptor_m];
Effect_missed = [Effect_missed effect_m];
Ptonic_missed = [Ptonic_missed P_tonic_m];
Pclonic_missed = [Pclonic_missed P_clonic_m];
end

%Print Cmin, Cmax, and AUCs to compare
% m/5, 2m/5, 3m/5, 4m/5, double dose, skipped dose
Cmin
Cmax
auc_m

%{
%% Save data for missed dosing to import into R

% Columns correspond with missed doses taken m/5 (1), 2m/5 (2), 3m/5 (3), 
% and 4m/5 (4) hours late and double dose (5) and skipped dose (6)

save MissedDoseConc.mat Conc_missed;
save MissedDoseTime.mat t_m;
save MissedDoseAUC.mat auc_m;
save MissedDoseCtrough.mat ctrough_m;
save MissedDoseReceptor.mat Receptor_missed;
save MissedDoseEffect.mat Effect_missed;
save MissedDoseP_tonic.mat P_tonic_missed;
save MissedDoseP_clonic.mat P_clonic_missed;
%}