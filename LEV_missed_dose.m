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
add_norm = 1;   % if 1, save the normal dose as well

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
[y_m,t_m,auc_m(MISSED),ctrough_m(MISSED),receptor_m,effect_m,P_tonic_m,P_clonic_m,AUEC_tonic(MISSED) ,E_tonic_trough(MISSED) ,AUEC_clonic(MISSED) ,E_clonic_trough(MISSED)] = Levetiracetam_sim(kA,V,kCL,Dose,TimeLen,q,IC50,Kd,0,1,MISSED);

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

%% Plotting (commented out because plotting in R)
%{
% Plot concentrations
figure;
hold on;
yyaxis left;
ylim([0 40]);
ylabel('[D] (mg/L)', 'FontSize', 12);
plot(t_m, y_m);

if MISSED ~= 6 
PLOT_title = strcat('Missed Dose Taken', {' '}, string(MISSED*12/5), ' Hours Late');
    if MISSED == 5
        PLOT_title = strcat('Double Dose:', {' '}, PLOT_title);
    end
else 
    PLOT_title = 'Skipped Dose';
end

title(PLOT_title, 'FontSize', 16);
xlabel('Time (hrs)', 'FontSize', 12);

yyaxis right;
ylim([0 100]);
ylabel('Protection From Seizures (%)', 'FontSize', 12);
plot(t_m, P_tonic_m);
plot(t_m, P_clonic_m, 'r', 'linewidth', 2);
legend('Plasma Concentration', 'Tonic Seizure Protection', 'Clonic Seizure Protection', 'Location', 'northwest');
hold off;
%}

%{
%% If want to plot each individually
%Plot tonic seizure protection
figure;
plot(t_m, P_tonic_m, 'linewidth', 3);
if MISSED ~= 6 
PLOT_title = strcat('Missed Dose Taken', {' '}, string(MISSED*12/5), ' Hours Late (Tonic Seizure Protection)');
    if MISSED == 5
        PLOT_title = strcat('Double Dose:', {' '}, PLOT_title);
    end
else 
    PLOT_title = 'Skipped Dose (Tonic Seizure Protection)';
end

title(PLOT_title, 'FontSize', 16);
ylabel('Protection From Tonic Seizures (%)', 'FontSize', 12);
xlabel('Time (hrs)', 'FontSize', 12);

%Plot clonic seizure protection
figure;
plot(t_m, P_clonic_m, 'linewidth', 3);
if MISSED ~= 6 
PLOT_title = strcat('Missed Dose Taken', {' '}, string(MISSED*12/5), ' Hours Late (Clonic Seizure Protection)');
    if MISSED == 5
        PLOT_title = strcat('Double Dose:', {' '}, PLOT_title);
    end
else 
    PLOT_title = 'Skipped Dose (Clonic Seizure Protection)';
end

title(PLOT_title, 'FontSize', 16);
ylabel('Protection From Clonic Seizures (%)', 'FontSize', 12);
xlabel('Time (hrs)', 'FontSize', 12);
%}


%% Save concentration and effect data for each missed dose case
Conc_missed = [Conc_missed y_m];
Receptor_missed = [Receptor_missed receptor_m];
Effect_missed = [Effect_missed effect_m];
Ptonic_missed = [Ptonic_missed P_tonic_m];
Pclonic_missed = [Pclonic_missed P_clonic_m];
end

%% Add a normal dose
if add_norm == 1
    MISSED = 0;
    [y_m,t_m,auc_m,~,receptor_m,effect_m,P_tonic_m,P_clonic_m,~ ,~,~,~] = Levetiracetam_sim(kA,V,kCL,Dose,TimeLen,q,IC50,Kd,0,1,MISSED);
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
Tonic_min
Tonic_max
AUEC_tonic
Clonic_min
Clonic_max
AUEC_clonic


%% Save data for missed dosing to import into R

% Columns correspond with missed doses taken m/5 (1), 2m/5 (2), 3m/5 (3), 
% and 4m/5 (4) hours late and double dose (5) and skipped dose (6)

save missed_dose_data/MissedDoseConc.mat Conc_missed;
t_m = t_m'; % optimize for R visualization
save missed_dose_data/MissedDoseTime.mat t_m;
save missed_dose_data/MissedDoseAUC.mat auc_m;
save missed_dose_data/MissedDoseCtrough.mat ctrough_m;
save missed_dose_data/MissedDoseReceptor.mat Receptor_missed;
save missed_dose_data/MissedDoseEffect.mat Effect_missed;
save missed_dose_data/MissedDoseP_tonic.mat Ptonic_missed;
save missed_dose_data/MissedDoseP_clonic.mat Pclonic_missed;
save missed_dose_data/MissedDoseAUEC_tonic.mat AUEC_tonic;
save missed_dose_data/MissedDoseAUEC_clonic.mat AUEC_clonic;
save missed_dose_data/MissedDoseE_tonic_trough.mat E_tonic_trough;
save missed_dose_data/MissedDoseE_clonic_trough.mat E_clonic_trough;


%% Population variability with missed dosing

%Generate the same distribution of params used in the population variability section

%Generate list of ka values
cutoffka = 0;
sdka = 0.451*sqrt(44); %Standard deviation (= standard error*sqrt(N))
meanka = 3.83; %Mean ka in population

%Set seed for repoducibility
rng(0,'twister');

katemp = sdka.*randn(200,1)+meanka; %generate 200 virtual patients from normal distribution
a=length(katemp(katemp<cutoffka)); % count people below ka
cycle = 1;
while a>0 % if there are any nonpositives, replace them
    katemp(katemp<cutoffka)=sdka.*randn(a,1)+meanka;        
    a=length(katemp(katemp<cutoffka)); 
    cycle = cycle + 1;
end % check again for nonpositives and loop if necessary

kaPPK = katemp; % This is the final ka parameter distribution


% Generate list of clearance values
cutoffCL = 0;
sdCL = 0.103*sqrt(44); %Standard deviation (= standard error*sqrt(N))
meanCL = 2.47; %Mean kcl in population


CLtemp = sdCL.*randn(200,1)+meanCL; %generate 200 virtual patients from normal distribution
b=length(CLtemp(CLtemp<cutoffCL)); % count people below CL = 0
cycle = 1;
while b>0 % if there are any nonpositives, replace them
    CLtemp(CLtemp<cutoffCL)=sdCL.*randn(b,1)+meanCL;        
    b=length(CLtemp(CLtemp<cutoffCL)); 
    cycle = cycle + 1;
end % check again for nonpositives and loop if nec.

CL = CLtemp; % This is the final clearance rate distribution

%Use CL to generate list of kcl (kcl = CL/V), assuming V = constant = 21.9 L
kCLPPK = CL./21.9;

%% Run Simulations
        
        %Base case for varying kA and kCL (no missed or repeated doses)
        for i=1:200
            [y0,t0,auc0(i),ctrough0(i),receptor0,effect0,ptonic0,pclonic0,auecTonic0(i),Etrough_tonic0(i),auecClonic0(i),Etrough_clonic0(i)] = Levetiracetam_sim(kaPPK(i),V,kCL,Dose,TimeLen,q,IC50,Kd,0,1,0);
        end
        
        %Missed dose analysis within population--obtain efficacy metric
        %values for each individual
        for j = 1:6
            for i=1:200
                [y1, t1, auc(j,i),ctrough(j,i),receptor,effect,p_tonic,p_clonic,auecT(j,i),etroughT(j,i),auecC(j,i),etroughC(j,i)] = Levetiracetam_sim(kaPPK(i),V,kCLPPK(i),Dose,TimeLen,q,IC50,Kd,0,1,j);
            end
        end
        
      
 %% Calculate relative difference from baseline for missed, double, and skipped dose
 
 %Choose key metric to plot
    KEY_METRIC = 1;
    % 1 = AUC
    % 2 = AUEC tonic
    % 3 = AUEC clonic
    % 4 = Ctrough
    % 5 = Etrough tonic
    % 6 = Etrough clonic
 
        if KEY_METRIC == 1
        Diff_m = (auc(2,:) - auc0)./auc0;
        Diff_dd = (auc(5,:) - auc0)./auc0;
        Diff_skip = (auc(6,:) - auc0)./auc0;
        Plot_title = 'Relative Change in AUC Within Population: ';
        xlab = 'Relative change in AUC ((AUC - AUC0)/AUC0)';
        limits = [-1 3.5];
        
        elseif KEY_METRIC == 2
        Diff_m = (auecT(2,:) - auecTonic0)./auecTonic0;
        Diff_dd = (auecT(5,:) - auecTonic0)./auecTonic0;
        Diff_skip = (auecT(6,:) - auecTonic0)./auecTonic0;
        Plot_title = 'Relative Change in AUEC (Tonic) Within Population: ';
        xlab = 'Relative change in AUEC_{tonic} ((AUEC - AUEC0)/AUEC0)';
        limits = [-0.3 0.3];

        elseif KEY_METRIC == 3
        Diff_m = (auecC(2,:) - auecClonic0)./auecClonic0;
        Diff_dd = (auecC(5,:) - auecClonic0)./auecClonic0;
        Diff_skip = (auecC(6,:) - auecClonic0)./auecClonic0;
        Plot_title = 'Relative Change in AUEC (Clonic) Within Population: ';
        xlab = 'Relative change in AUEC_{clonic} ((AUEC - AUEC0)/AUEC0)';
        limits = [-0.3 0.3];

        elseif KEY_METRIC == 4
        Diff_m = (ctrough(2,:) - ctrough0)./ctrough0;
        Diff_dd = (ctrough(5,:) - ctrough0)./ctrough0;
        Diff_skip = (ctrough(6,:) - ctrough0)./ctrough0;
        Plot_title = 'Relative Change in Ctrough Within Population: ';
        xlab = 'Relative change in Ctrough ((Ctrough - Ctrough0)/Ctrough0)';
        limits = [-1 10];

        elseif KEY_METRIC == 5
        Diff_m = (etroughT(2,:) - Etrough_tonic0)./Etrough_tonic0;
        Diff_dd = (etroughT(5,:) - Etrough_tonic0)./Etrough_tonic0;
        Diff_skip = (etroughT(6,:) - Etrough_tonic0)./Etrough_tonic0;
        Plot_title = 'Relative Change in Etrough (Tonic) Within Population: ';
        xlab = 'Relative change in Etrough_{tonic} ((Etrough - Etrough0)/Etrough0)';
        limits = [-0.7 0.6];

        elseif KEY_METRIC == 6
        Diff_m = (etroughC(2,:) - Etrough_clonic0)./Etrough_clonic0;
        Diff_dd = (etroughC(5,:) - Etrough_clonic0)./Etrough_clonic0;
        Diff_skip = (etroughC(6,:) - Etrough_clonic0)./Etrough_clonic0;
        Plot_title = 'Relative Change in Etrough (Clonic) Within Population: ';
        xlab = 'Relative change in Etrough_{clonic} ((Etrough - Etrough0)/Etrough0)';
        limits = [-0.7 0.6];

        end
        
%% Plot Histograms

        %Missed dose taken 2m/5 (4.8 h) late
        figure;
        histogram(Diff_m);
        title({Plot_title, 'Missed Dose Taken 4.8 h Late'}); 
        xlabel(xlab);
        ylabel('Number of Patients');
        xlim(limits);
        
        %Double dose
        figure;
        histogram(Diff_dd);
        title({Plot_title, 'Double Dose'}); 
        xlabel(xlab);
        ylabel('Number of Patients');
        xlim(limits);

        %Skipped dose
        figure;
        histogram(Diff_skip);
        title({Plot_title, 'Skipped Dose'}); 
        xlabel(xlab);
        ylabel('Number of Patients');
        xlim(limits);
        
%% Save data for R visualization
 
%Choose key metric to plot
    KEY_METRIC = 1;
    % 1 = AUC
    % 2 = AUEC tonic
    % 3 = AUEC clonic
    % 4 = Ctrough
    % 5 = Etrough tonic
    % 6 = Etrough clonic
 
    for KEY_METRIC = 1:1
        
        if KEY_METRIC == 1 % AUC
        Diff_m = ((auc(2,:) - auc0)./auc0)';
        Diff_dd = ((auc(5,:) - auc0)./auc0)';
        Diff_skip = ((auc(6,:) - auc0)./auc0)';
        save missed_dose_pop_data/AUC_missed.mat Diff_m
        save missed_dose_pop_data/AUC_double.mat Diff_dd
        save missed_dose_pop_data/AUC_skipped.mat Diff_skip
        
        elseif KEY_METRIC == 2 % AUEC tonic
        Diff_m = ((auecT(2,:) - auecTonic0)./auecTonic0)';
        Diff_dd = ((auecT(5,:) - auecTonic0)./auecTonic0)';
        Diff_skip = ((auecT(6,:) - auecTonic0)./auecTonic0)';
        save missed_dose_pop_data/AUEC_tonic_missed.mat Diff_m
        save missed_dose_pop_data/AUEC_tonic_double.mat Diff_dd
        save missed_dose_pop_data/AUEC_tonic_skipped.mat Diff_skip

        elseif KEY_METRIC == 3 % AUEC clonic
        Diff_m = ((auecC(2,:) - auecClonic0)./auecClonic0)';
        Diff_dd = ((auecC(5,:) - auecClonic0)./auecClonic0)';
        Diff_skip = ((auecC(6,:) - auecClonic0)./auecClonic0)';
        save missed_dose_pop_data/AUEC_clonic_missed.mat Diff_m
        save missed_dose_pop_data/AUEC_clonic_double.mat Diff_dd
        save missed_dose_pop_data/AUEC_clonic_skipped.mat Diff_skip

        elseif KEY_METRIC == 4 % Ctrough
        Diff_m = ((ctrough(2,:) - ctrough0)./ctrough0)';
        Diff_dd = ((ctrough(5,:) - ctrough0)./ctrough0)';
        Diff_skip = ((ctrough(6,:) - ctrough0)./ctrough0)';
        save missed_dose_pop_data/Ctrough_missed.mat Diff_m
        save missed_dose_pop_data/Ctrough_double.mat Diff_dd
        save missed_dose_pop_data/Ctrough_skipped.mat Diff_skip

        elseif KEY_METRIC == 5
        Diff_m = ((etroughT(2,:) - Etrough_tonic0)./Etrough_tonic0)';
        Diff_dd = ((etroughT(5,:) - Etrough_tonic0)./Etrough_tonic0)';
        Diff_skip = ((etroughT(6,:) - Etrough_tonic0)./Etrough_tonic0)';
        save missed_dose_pop_data/Etrough_tonic_missed.mat Diff_m
        save missed_dose_pop_data/Etrough_tonic_double.mat Diff_dd
        save missed_dose_pop_data/Etrough_tonic_skipped.mat Diff_skip

        elseif KEY_METRIC == 6
        Diff_m = ((etroughC(2,:) - Etrough_clonic0)./Etrough_clonic0)';
        Diff_dd = ((etroughC(5,:) - Etrough_clonic0)./Etrough_clonic0)';
        Diff_skip = ((etroughC(6,:) - Etrough_clonic0)./Etrough_clonic0)';
        save missed_dose_pop_data/Etrough_clonic_missed.mat Diff_m
        save missed_dose_pop_data/Etrough_clonic_double.mat Diff_dd
        save missed_dose_pop_data/Etrough_clonic_skipped.mat Diff_skip

        end
    end
