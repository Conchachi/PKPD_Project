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

%Run simulation for single dose and print concentrations, amounts, and mass balance
[Conc,Time,AUC0,Ctrough0] = Levetiracetam_sim(kA,V,kCL,Dose,TimeLen,q,MASS_BAL_VIS,DOSEFREQ);

% Plot single dose to compare to paper figure
figure;
plot(Time, Conc(:,1), 'linewidth', 3);
title('Concentration of Levetiracetam in Compartment: Single Dose', 'FontSize', 16);
ylabel('[D] (mg/L)', 'FontSize', 12);
xlabel('Time (hrs)', 'FontSize', 12);
ylim([0 50]);

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

%Run simulation for repeated doses and print concentrations, amounts, and mass balance
[Conc,Time,AUC0,Ctrough0] = Levetiracetam_sim(kA,V,kCL,Dose,TimeLen,q,MASS_BAL_VIS,DOSEFREQ);

%% STEP 2:
% Identify and simulate key time-dependent variables for a range of doses

% Perform sensitivity analysis for model parameters for key metrics of treatment efficacy

%% SIMULATIONS

% Simulate range of doses for key PK/PD variables:

%First key variable: drug concentration in central compartment
Conc = [];
Time = [];
%Test range of doses 250-1500mg
for i=1:6
    Dose = 250*i;
    [Conc1, Time1, AUC(i), Ctrough(i)] = Levetiracetam_sim(kA,V,kCL,Dose,TimeLen,q,0,1);
    Conc = [Conc Conc1];
    Time = [Time Time1'];
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
    
% Second key variable: PD Effect Model TBD

% Third key variable: PD Effect Model TBD

%% Perform sensitivity analysis for AUC and Ctrough for parameters

% Model parameters for array p
q = 0;     % units: nmol/hr
V = 40; % units: L (volume of distribution)
kA  =  2.44; % units: 1/hr (absorption rate constant)
kCL = 0.096; %units: 1/hr (clearance rate constant)
Dose = 500; %mg
TimeLen = 12; %hours between doses

% Initial concentrations
y0 = [0, 0, Dose]; %mg

ParamDelta = 0.05; % test sensitivity to a 5% change

%% RUN BASE CASE

p0 = [kA V kCL Dose TimeLen q]';
p0labels = {'kA' 'V' 'kCL' 'Dose' 'TimeLen' 'q'}';

[y0,t0,auc0,ctrough0] = Levetiracetam_sim(kA,V,kCL,Dose,TimeLen,q,0,1);
t = t0';
y = y0;

%% RUN SENSITIVITY SIMULATIONS

% LOCAL UNIVARIATE

for i=1:length(p0)
    p=p0;
    p(i)=p0(i)*(1.0+ParamDelta);
    [y1, t1, auc(i),ctrough(i)] = Levetiracetam_sim(p(1),p(2),p(3),p(4),p(5),p(6),0,1);
    t = [t t1'];
    y = [y y1];
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
%Population variability




