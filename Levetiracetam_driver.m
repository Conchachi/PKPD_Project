clear all;
close all;

%% STEP 1:
%Build model, mass/mole balance

%% Single dose, 1000 mg (to compare to plot from paper)
% PARAMETERS
q = 0;     % units: nmol/hr
V = 42; % units: L (volume of distribution)
kA  =  0.464; % units: 1/hr (absorption rate constant)
kCL = 0.096; %units: 1/hr (clearance rate constant)
Dose = 1000; %mg
TimeLen = 14; %hours between doses
MASS_BAL_VIS = 1; %Set to 1 to visualize mass balance
DOSEFREQ = 0; %Set to 0 for single dose, 1 for repeated dosing
IC50 = 2.43; %mg/L
Kd = 1.3617; % units: mg/L

%Run simulation for single dose and print concentrations, amounts, and mass balance
[Conc,Time,AUC0,Ctrough0,Receptor,Effect,P_tonic,P_clonic] = Levetiracetam_sim(kA,V,kCL,Dose,TimeLen,q,IC50,Kd,MASS_BAL_VIS,DOSEFREQ);

% Plot single dose to compare to paper figure
figure;
plot(Time, Conc(:,1), 'linewidth', 3);
title('Concentration of Levetiracetam in Compartment: Single Dose', 'FontSize', 16);
ylabel('[D] (mg/L)', 'FontSize', 12);
xlabel('Time (hrs)', 'FontSize', 12);
ylim([0 50]);

figure;
plot(Time, Receptor, 'linewidth', 3);
title('SV2A Protein Receptor Occupancy by LEV After Single Dose', 'FontSize', 16);
ylabel('% Occupied', 'FontSize', 12);
xlabel('Time (hrs)', 'FontSize', 12);

%% Repeated doses, 500 mg every 12 hours
% PARAMETERS
q = 0;     % units: nmol/hr
V = 42; % units: L (volume of distribution)
kA  =  0.464; % units: 1/hr (absorption rate constant)
kCL = 0.096; %units: 1/hr (clearance rate constant)
Dose = 500; %mg
TimeLen = 12; %hours between doses
MASS_BAL_VIS = 1; %Set to 1 to visualize mass balance
DOSEFREQ = 1; %Set to 0 for single dose, 1 for repeated dosing
IC50 = 2.43; %mg/L
Kd = 1.3617; % units: mg/L

%Run simulation for repeated doses and print concentrations, amounts, and mass balance
[Conc,Time,AUC0,Ctrough0,Receptor,Effect,P_tonic,P_clonic] = Levetiracetam_sim(kA,V,kCL,Dose,TimeLen,q,IC50,Kd,MASS_BAL_VIS,DOSEFREQ);

%% STEP 2:
% Identify and simulate key time-dependent variables for a range of doses

% Perform sensitivity analysis for model parameters for key metrics of treatment efficacy

%% SIMULATIONS

% Simulate range of doses for key PK/PD variables:

%First key variable: drug concentration in central compartment
Conc = [];
Time = [];
Receptor = [];
Effect = [];
P_tonic = [];
P_clonic = [];
%Test range of doses 250-1500mg
for i=1:6
    Dose = 250*i;
    [Conc1, Time1, AUC(i), Ctrough(i), Receptor1, Effect1, P_tonic1, P_clonic1] = Levetiracetam_sim(kA,V,kCL,Dose,TimeLen,q,IC50,Kd,0,1);
    Conc = [Conc Conc1];
    Time = [Time Time1'];
    Receptor = [Receptor Receptor1];
    Effect = [Effect Effect1];
    P_tonic = [P_tonic P_tonic1];
    P_clonic = [P_clonic P_clonic1];
end

%Plot drug concentrations for range of doses
figure; 
for i = 1:6
    hold on;
    plot(Time(:,i), Conc(:,i), 'linewidth',3);
end
    title('Concentration of Levetiracetam in Compartment', 'FontSize', 20);
    ylabel('[D] (mg/L)', 'FontSize', 16);
    xlabel('Time (hrs)', 'FontSize', 16);
    leg = legend('250', '500', '750', '1000', '1250', '1500');
    title(leg, 'Dose (mg)');
    
% Second key variable: PD Effect Model

%Plot P_tonic for range of doses
figure; 
for i = 1:6
    hold on;
    plot(Time(:,i), P_tonic(:,i), 'linewidth',3);
end
    title('Protection Against Tonic Seizures', 'FontSize', 20);
    ylabel('Protection (%)', 'FontSize', 16);
    xlabel('Time (hrs)', 'FontSize', 16);
    leg = legend('250', '500', '750', '1000', '1250', '1500');
    title(leg, 'Dose (mg)');

% Third key variable: PD Effect Model
figure; 
for i = 1:6
    hold on;
    plot(Time(:,i), P_clonic(:,i), 'linewidth',3);
end
    title('Protection Against Clonic Seizures', 'FontSize', 20);
    ylabel('Protection (%)', 'FontSize', 16);
    xlabel('Time (hrs)', 'FontSize', 16);
    leg = legend('250', '500', '750', '1000', '1250', '1500');
    title(leg, 'Dose (mg)');

%% Perform sensitivity analysis for AUC and Ctrough for parameters

% Model parameters for array p
q = 0;     % units: nmol/hr
V = 40; % units: L (volume of distribution)
kA  =  2.44; % units: 1/hr (absorption rate constant)
kCL = 0.096; %units: 1/hr (clearance rate constant)
Dose = 500; %mg
TimeLen = 12; %hours between doses
IC50 = 2.43; %mg/L
Kd = 1.3617; % units: mg/L

% Initial concentrations
y0 = [0, 0, Dose]; %mg

ParamDelta = 0.05; % test sensitivity to a 5% change

%% RUN BASE CASE

p0 = [kA V kCL Dose TimeLen q]';
p0labels = {'kA' 'V' 'kCL' 'Dose' 'TimeLen' 'q'}';

[y0,t0,auc0,ctrough0,receptor0,effect0,ptonic0,pclonic0] = Levetiracetam_sim(kA,V,kCL,Dose,TimeLen,q,IC50,Kd,0,1);
t = t0';
y = y0;
receptor = receptor0;
effect = effect0;
ptonic = ptonic0;
pclonic = pclonic0;

%% RUN SENSITIVITY SIMULATIONS

% LOCAL UNIVARIATE

for i=1:length(p0)
    p=p0;
    p(i)=p0(i)*(1.0+ParamDelta);
    [y1, t1, auc(i),ctrough(i),receptor1,effect1,ptonic1,pclonic1] = Levetiracetam_sim(p(1),p(2),p(3),p(4),p(5),p(6),IC50,Kd,0,1);
    t = [t t1'];
    y = [y y1];
    receptor = [receptor receptor1];
    effect = [effect effect1];
    ptonic = [ptonic ptonic1];
    pclonic = [pclonic pclonic1];
    
    Sens(i) = ((auc(i)-auc0)/auc0)/((p(i)-p0(i))/p0(i)); % relative sensitivity vs parameter
    SensB(i) = ((auc(i)-auc0))/((p(i)-p0(i))); % absolute sensitivity vs parameter
    SensAbs(i) = ((auc(i)-auc0)/auc0); % relative change (not normalized to parameter)
    SensT = ((y1-y0)./y0)/((p(i)-p0(i))/p0(i)); % time-dependent relative sensitivity
    [maxS,indT] = max(abs(SensT)); 
    SensTmax(i) = t1(indT); % time to max relative sensitivity
    SensCtrough(i) = ((ctrough(i)-ctrough0)/ctrough0)/((p(i)-p0(i))/p0(i)); % relative sensitivity vs parameter

    if i==1
        SensTarr = SensT;
    else
        SensTarr = [SensTarr SensT];
    end
end

%Concentration Plots
figure;
hold on
for i=1:(length(p0))
    plot(t(:,i+1),y(:,i));
end
ax = gca; % assign a handle (ax) for the current axes
ax.FontSize = 14;
ylabel('Concentration, Y')
xlabel('Time (hr)')
lgd = legend(p0labels);
lgd.Location = 'eastoutside';
lgd.Title.String = ['Parameter' newline 'being' newline 'changed'];

%Plot of relative sensitivity of concentrations
figure;
hold on
colors=lines(length(p0));
for i=1:length(p0)
    plot(t(:,i+1),SensTarr(:,i),'LineWidth',3);
    text(t(end,i+1)+.5,SensTarr(end,i),strcat(p0labels{i},{''}),'HorizontalAlignment','left','Color',colors(i,:));
end
ax = gca; % assign a handle (ax) for the current axes
ax.FontSize = 14;
ylabel({'Relative sensitivity of concentration','(dY/Y)/(dP/P)'})
xlabel('Time (hr)')
    
%Relative sensitivity of AUC Plot
    figure;
    bar(Sens);  
	ax = gca; % assign a handle (ax) for the current axes
    ax.FontSize = 14;
    ylabel({'Relative sensitivity of AUC';'(dY/Y)/(dP/P)'})
    xlabel('Parameters')
    xticks([1:1:length(p0)])
    xticklabels(p0labels);
    xlim([.5 (length(p0)+.5)])

% Absolute sensitivity of AUC plot
    figure;
    bar(SensB);
	ax = gca; % assign a handle (ax) for the current axes
    ax.FontSize = 14;
    ylabel({'Absolute sensitivity of AUC';'(dY/dP)'})
    xlabel('Parameters')
    xticks([1:1:length(p0)])
    xticklabels(p0labels);
    xlim([.5 (length(p0)+.5)])
    
% Time of maximum sensitivity plot
    figure;
    bar(SensTmax);
	ax = gca; % assign a handle (ax) for the current axes
    ax.FontSize = 14;
    ylabel({'Time of maximum sensitivity of concentration','(hr)'})
    xlabel('Parameters')
    xticks([1:1:length(p0)])
    xticklabels(p0labels);
    xlim([.5 (length(p0)+.5)])
    

%Relative sensitivity for Ctrough Plot
figure;
    bar(SensCtrough);  
	ax = gca; % assign a handle (ax) for the current axes
    ax.FontSize = 14;
    ylabel({'Relative sensitivity of Ctrough';'(dY/Y)/(dP/P)'})
    xlabel('Parameters')
    xticks([1:1:length(p0)])
    xticklabels(p0labels);
    xlim([.5 (length(p0)+.5)])
    
%% Need to do global sensitivity analysis in addition or instead of LSA???
    



%% STEP 3:
%Population variability--varying ka and kcl in children and adults

%% Children (https://onlinelibrary.wiley.com/doi/10.1111/j.1528-1167.2008.01974.x)

% Generate list of ka values
cutoffka = 0;
sdka = 0.451*sqrt(44);
meanka = 3.83;

%Set seed for repoducibility
rng(0,'twister');

katemp = sdka.*randn(100,1)+meanka; %initial list
a=length(katemp(katemp<cutoffka)); % count people below ka
cycle = 1;
while a>0 % if there are any nonpositives, replace them
    katemp(katemp<cutoffka)=sdka.*randn(a,1)+meanka;        
    a=length(katemp(katemp<cutoffka)); 
    cycle = cycle + 1;
end % check again for nonpositives and loop if necessary

kaPPK = katemp; % This is the final weight distribution


% Generate list of clearance values
cutoffCL = 0;
sdCL = 0.103*sqrt(44);
meanCL = 2.47;

%Set seed for repoducibility
rng(0,'philox');

CLtemp = sdCL.*randn(100,1)+meanCL; %initial list
b=length(CLtemp(CLtemp<cutoffCL)); % count people below CL = 0
cycle = 1;
while b>0 % if there are any nonpositives, replace them
    CLtemp(CLtemp<cutoffCL)=sdCL.*randn(b,1)+meanCL;        
    b=length(CLtemp(CLtemp<cutoffCL)); 
    cycle = cycle + 1;
end % check again for nonpositives and loop if nec.

CL = CLtemp; % This is the final weight distribution

%Use CL to generate list of kcl (kcl = CL/V)
kCLPPK = CL./21.9;

%% Simulations

% PARAMETERS
q = 0;     % units: nmol/hr
V = 21.9; % units: L (volume of distribution)
Dose = 330; %mg
TimeLen = 12; %hours between doses
MASS_BAL_VIS = 0; %Set to 1 to visualize mass balance
DOSEFREQ = 1; %Set to 0 for single dose, 1 for repeated dosing

%Vary ka only:
kCL = 0.113; %units: 1/hr (clearance rate constant)
t = [];
y = [];
for i=1:100
    [y1, t1, auc(i),ctrough(i),effect] = Levetiracetam_sim(kaPPK(i),V,kCL,Dose,TimeLen,q,IC50,Kd,0,1);
    t = [t t1'];
    y = [y y1];
end

%Plot AUC vs. ka
figure;
scatter(kaPPK, auc);
title('AUC vs. ka in children', 'FontSize', 16);
ylabel('AUC (mg*h/L)', 'FontSize', 12);
xlabel('ka (1/hr)', 'FontSize', 12);

%Plot Ctrough vs. ka
figure;
scatter(kaPPK, ctrough);
title('Ctrough vs. ka in children', 'FontSize', 16);
ylabel('Ctrough (mg/L)', 'FontSize', 12);
xlabel('ka (1/hr)', 'FontSize', 12);


%Vary kcl only:
kA = 3.83; %units: 1/h
t = [];
y = [];
for i=1:100
    [y1, t1, auc(i),ctrough(i)] = Levetiracetam_sim(kA,V,kCLPPK(i),Dose,TimeLen,q,IC50,Kd,0,1);
    t = [t t1'];
    y = [y y1];
end

%Plot AUC vs. kCL
figure;
scatter(kCLPPK, auc);
title('AUC vs. kcl in children', 'FontSize', 16);
ylabel('AUC (mg*h/L)', 'FontSize', 12);
xlabel('kcl (1/hr)', 'FontSize', 12);

%Plot Ctrough vs. kCL
figure;
scatter(kCLPPK, ctrough);
title('Ctrough vs. kCL in children', 'FontSize', 16);
ylabel('Ctrough (mg/L)', 'FontSize', 12);
xlabel('kCL (1/hr)', 'FontSize', 12);


%Vary both ka and kcl:
t = [];
y = [];
for i=1:100
    [y1, t1, auc(i),ctrough(i)] = Levetiracetam_sim(kaPPK(i),V,kCLPPK(i),Dose,TimeLen,q,IC50,Kd,0,1);
    t = [t t1'];
    y = [y y1];
end

%Plot AUC vs. ka and kcl
figure;
scatter3(kaPPK, kCLPPK, auc);
title('AUC vs. ka and kcl in children', 'FontSize', 16);
zlabel('AUC (mg*h/L)', 'FontSize', 12);
ylabel('kcl (1/hr)', 'FontSize', 12);
xlabel('ka (1/hr)', 'FontSize', 12);

%Plot Ctrough vs. ka and kcl
figure;
scatter3(kaPPK, kCLPPK, ctrough);
title('Ctrough vs. ka and kcl in children', 'FontSize', 16);
zlabel('Ctrough (mg/L)', 'FontSize', 12);
ylabel('kcl (1/hr)', 'FontSize', 12);
xlabel('ka (1/hr)', 'FontSize', 12);

%% In adults (https://doi.org/10.1080/00498254.2020.1746981)

%Set seed for repoducibility
rng(0,'twister');
%Generate list from distribution
kaPPK_Adult = 0.616*exp(0.327*randn(100,1)+0);

%Set seed for repoducibility
rng(0,'philox');
%Generate list from distribution
CLPPK = 3.26*exp(0.159*randn(100,1)+0);
kCLPPK_Adult = CLPPK./34.7;

%% Simulations

% PARAMETERS
q = 0;     % units: nmol/hr
V = 34.7; % units: L (volume of distribution)
Dose = 1000; %mg
TimeLen = 12; %hours between doses
MASS_BAL_VIS = 0; %Set to 1 to visualize mass balance
DOSEFREQ = 1; %Set to 0 for single dose, 1 for repeated dosing

%Vary ka only:
kCL = 3.26/34.7; %units: 1/hr (clearance rate constant)
t = [];
y = [];
for i=1:100
    [y1, t1, auc(i),ctrough(i)] = Levetiracetam_sim(kaPPK_Adult(i),V,kCL,Dose,TimeLen,q,IC50,Kd,0,1);
    t = [t t1'];
    y = [y y1];
end

%Plot AUC vs. ka
figure;
scatter(kaPPK_Adult, auc);
title('AUC vs. ka in adults', 'FontSize', 16);
ylabel('AUC (mg*h/L)', 'FontSize', 12);
xlabel('ka (1/hr)', 'FontSize', 12);

%Plot Ctrough vs. ka
figure;
scatter(kaPPK_Adult, ctrough);
title('Ctrough vs. ka in adults', 'FontSize', 16);
ylabel('Ctrough (mg/L)', 'FontSize', 12);
xlabel('ka (1/hr)', 'FontSize', 12);

%Vary only kcl:
kA = 0.616; %units: 1/hr (clearance rate constant)
t = [];
y = [];
for i=1:100
    [y1, t1, auc(i),ctrough(i)] = Levetiracetam_sim(kA,V,kCLPPK_Adult(i),Dose,TimeLen,q,IC50,Kd,0,1);
    t = [t t1'];
    y = [y y1];
end

%Plot AUC vs. kCL
figure;
scatter(kCLPPK_Adult, auc);
title('AUC vs. kcl in adults', 'FontSize', 16);
ylabel('AUC (mg*h/L)', 'FontSize', 12);
xlabel('kcl (1/hr)', 'FontSize', 12);

%Plot Ctrough vs. kCL
figure;
scatter(kCLPPK_Adult, ctrough);
title('Ctrough vs. kCL in adults', 'FontSize', 16);
ylabel('Ctrough (mg/L)', 'FontSize', 12);
xlabel('kcl (1/hr)', 'FontSize', 12);

%Vary both ka and kcl:
t = [];
y = [];
for i=1:100
    [y1, t1, auc(i),ctrough(i)] = Levetiracetam_sim(kaPPK_Adult(i),V,kCLPPK_Adult(i),Dose,TimeLen,q,IC50,Kd,0,1);
    t = [t t1'];
    y = [y y1];
end

%Plot AUC vs. ka and kcl
figure;
scatter3(kaPPK_Adult, kCLPPK_Adult, auc);
title('AUC vs. ka and kcl in adults', 'FontSize', 16);
zlabel('AUC (mg*h/L)', 'FontSize', 12);
ylabel('kcl (1/hr)', 'FontSize', 12);
xlabel('ka (1/hr)', 'FontSize', 12);

%Plot Ctrough vs. ka and kcl
figure;
scatter3(kaPPK_Adult, kCLPPK_Adult, ctrough);
title('Ctrough vs. ka and kcl in adults', 'FontSize', 16);
zlabel('Ctrough (mg/L)', 'FontSize', 12);
ylabel('kcl (1/hr)', 'FontSize', 12);
xlabel('ka (1/hr)', 'FontSize', 12);

