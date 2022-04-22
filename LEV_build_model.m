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

%% Single dose, 400 mg (to compare to plot from paper)
Dose = 400; %mg
TimeLen = 14; %hours between doses
MASS_BAL_VIS = 1; %Set to 1 to visualize mass balance
DOSEFREQ = 0; %Set to 0 for single dose, 1 for repeated dosing

%Run simulation for single dose and print concentrations, amounts, and mass balance
[Conc,Time,AUC0,Ctrough0,Receptor,Effect,P_tonic,P_clonic,AUEC_tonic,E_tonic_trough,AUEC_clonic,E_clonic_trough] = Levetiracetam_sim(kA,V,kCL,Dose,TimeLen,q,IC50,Kd,MASS_BAL_VIS,DOSEFREQ,MISSED);

% Plot single dose to compare to paper figure
figure;
plot(Time, Conc(:,1), 'linewidth', 3);
title('Concentration of Levetiracetam in Compartment: Single Dose', 'FontSize', 16);
ylabel('[D] (mg/L)', 'FontSize', 12);
xlabel('Time (hrs)', 'FontSize', 12);
ylim([0 50]);

%Plot receptor occupancy for single dose using R/Rmax model
figure;
plot(Time, Receptor, 'linewidth', 3);
title('SV2A Protein Receptor Occupancy by LEV After Single Dose', 'FontSize', 16);
ylabel('% Occupied (R/Rmax)', 'FontSize', 12);
xlabel('Time (hrs)', 'FontSize', 12);

%Plot receptor occupancy for single dose using E/Emax model
figure;
plot(Time, Effect, 'linewidth', 3);
title('SV2A Protein Receptor Occupancy by LEV After Single Dose', 'FontSize', 16);
ylabel('% Occupied (E/Emax)', 'FontSize', 12);
xlabel('Time (hrs)', 'FontSize', 12);

%Plot protection from tonic seizures
figure;
plot(Time, P_tonic, 'linewidth', 3);
title('Protection Against Tonic Seizures', 'FontSize', 16);
ylabel('% Protection', 'FontSize', 12);
xlabel('Time (hrs)', 'FontSize', 12);

%Plot protection from clonic seizures
figure;
plot(Time, P_clonic, 'linewidth', 3);
title('Protection Against Clonic Seizures', 'FontSize', 16);
ylabel('% Protection', 'FontSize', 12);
xlabel('Time (hrs)', 'FontSize', 12);

%Import into R to plot
%{
save Conc SingleDoseConc.mat;
save Time SingleDoseTime.mat;
save Receptor SingleDoseReceptor.mat;
save Effect SingleDoseEffect.mat;
save P_tonic SingleDoseP_tonic.mat;
save P_clonic SingleDoseP_clonic.mat;
%}


%% Repeated dosing, 400 mg 

% PARAMETERS
q = 0;     % units: nmol/hr
V = 21.9; % units: L (volume of distribution)
kA  =  3.83; % units: 1/hr (absorption rate constant)
kCL = 0.113; %units: 1/hr (clearance rate constant)
IC50 = 2.43; %mg/L
Kd = 1.3617; % units: mg/L
MISSED = 0; %for missed dose analysis, not relevant here
Dose = 400; %mg
TimeLen = 12; %hours between doses
MASS_BAL_VIS = 1; %Set to 1 to visualize mass balance
DOSEFREQ = 1; %Set to 0 for single dose, 1 for repeated dosing

%Run simulation for repeated dose and print concentrations, amounts, and mass balance
[Conc,Time,AUC0,Ctrough0,Receptor,Effect,P_tonic,P_clonic,AUEC_tonic,E_tonic_trough,AUEC_clonic,E_clonic_trough] = Levetiracetam_sim(kA,V,kCL,Dose,TimeLen,q,IC50,Kd,MASS_BAL_VIS,DOSEFREQ,MISSED);

%Import into R to plot
save Conc RepeatedDoseConc.mat;
save Time RepeatedDoseTime.mat;
save Receptor RepeatedDoseReceptor.mat;
save Effect RepeatedDoseEffect.mat;
save P_tonic RepeatedDoseP_tonic.mat;
save P_clonic RepeatedDoseP_clonic.mat;


%Plot
% Plot single dose to compare to paper figure
figure;
plot(Time, Conc(:,1), 'linewidth', 3);
title('Concentration of Levetiracetam in Compartment: Repeated Dosing', 'FontSize', 16);
ylabel('[D] (mg/L)', 'FontSize', 12);
xlabel('Time (hrs)', 'FontSize', 12);

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

%Simulate range of drug doses 110-550mg
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

%Print AUC and Ctrough/AUEC and Etrough for range of drug doses
AUC
Ctrough
AUEC_tonic
E_tonic_trough
AUEC_clonic
E_clonic_trough

%Plot drug concentrations for range of doses
figure; 
for i = 1:6
    hold on;
    plot(Time(:,i), Conc(:,i), 'linewidth',3);
end
    title('Concentration of Levetiracetam in Compartment', 'FontSize', 20);
    ylabel('[D] (mg/L)', 'FontSize', 16);
    xlabel('Time (hrs)', 'FontSize', 16);
    leg = legend('100', '200', '300', '400', '500', '600');
    title(leg, 'Dose (mg)');
    
%Plot receptor occupancy for range of doses with two models
%R/Rmax model
figure; 
ax1=subplot(2,1,1); 
for i = 1:6
    hold on;
    plot(ax1, Time(:,i), Receptor(:,i), 'linewidth',3);
end
    title('R/Rmax', 'FontSize', 20);
    ylabel('% Occupied', 'FontSize', 16);
    xlabel('Time (hrs)', 'FontSize', 16);
    leg = legend('100', '200', '300', '400', '500', '600');
    title(leg, 'Dose (mg)');
    
%E/Emax model
ax2=subplot(2,1,2); 
for i = 1:6
    hold on;
    plot(ax2, Time(:,i), Effect(:,i), 'linewidth',3);
end
    title('E/Emax', 'FontSize', 20);
    ylabel('% Occupied', 'FontSize', 16);
    xlabel('Time (hrs)', 'FontSize', 16);
    leg = legend('100', '200', '300', '400', '500', '600');
    title(leg, 'Dose (mg)');
    
%Plot P_tonic for range of doses
figure; 
for i = 1:6
    hold on;
    plot(Time(:,i), P_tonic(:,i), 'linewidth',3);
end
    title('Protection Against Tonic Seizures', 'FontSize', 20);
    ylabel('Protection (%)', 'FontSize', 16);
    xlabel('Time (hrs)', 'FontSize', 16);
    leg = legend('100', '200', '300', '400', '500', '600');
    title(leg, 'Dose (mg)');

% Plot P_clonic for range of doses
figure; 
for i = 1:6
    hold on;
    plot(Time(:,i), P_clonic(:,i), 'linewidth',3);
end
    title('Protection Against Clonic Seizures', 'FontSize', 20);
    ylabel('Protection (%)', 'FontSize', 16);
    xlabel('Time (hrs)', 'FontSize', 16);
    leg = legend('100', '200', '300', '400', '500', '600');
    title(leg, 'Dose (mg)');

  %{
%% Save data for repeated dosing for range of drug doses to import into R
% Columns correspond to drug doses: 250, 500, 750, 1000, 1250, and 1500 mg
save DoseRangeConc.mat Conc;
save DoseRangeTime.mat Time;
save DoseRangeAUC.mat AUC;
save DoseRangeCtrough.mat Ctrough;
save DoseRangeReceptor.mat Receptor;
save DoseRangeEffect.mat Effect;
save DoseRangeP_tonic.mat P_tonic;
save DoseRangeP_clonic.mat P_clonic;
save DoseRangeAUEC_tonic.mat AUEC_tonic;
save DoseRangeAUEC_clonic.mat AUEC_clonic;
save DoseRangeE_tonic_trough.mat E_tonic_trough;
save DoseRangeE_clonic_trough.mat E_clonic_trough;

%}

