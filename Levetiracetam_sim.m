function [Conc,Time,AUC,Ctrough] = Levetiracetam_sim(kA, V, kCL, Dose, TimeLen, q, MASS_BAL_VIS, DOSEFREQ);

%% PARAMETERS
p.q = 0;     % units: nmol/hr
p.V = V; % units: L (volume of distribution)
p.kA  =  kA; % units: 1/hr (absorption rate constant
p.kCL = kCL; %units: 1/hr (clearance rate constant)
p.Dose = Dose; %mg

y0 = [0 0 p.Dose]'; 
% y0(1) = concentration in central compartment
% y0(2) = amount cleared
% y0(3) = amount in gut 

%% SIMULATIONS

if DOSEFREQ == 0
%Single dose
y0 = [0 0 p.Dose]'; % Initial Conditions; units: mg/L
options = odeset('MaxStep',5e-2, 'AbsTol', 1e-5,'RelTol', 1e-5,'InitialStep', 1e-2);
[T1,Y1] = ode45(@Levetiracetam_eqns,[0 TimeLen],y0,options,p); % simulate model
CurrentD1 = Y1(:,1)*p.V + Y1(:,3) ; % Total drug amount in system
Conc = Y1;
Time = T1;
end

if DOSEFREQ == 1
% Repeated dosing
y0 = [0 0 p.Dose]'; % Initial Conditions; units: mg/L
options = odeset('MaxStep',5e-2, 'AbsTol', 1e-5,'RelTol', 1e-5,'InitialStep', 1e-2);
Y1 = [];
for i = 1:10
[T,Ystep] = ode45(@Levetiracetam_eqns,[0:TimeLen/240:TimeLen-TimeLen/240],y0,options,p); % simulate model
Y1 = [Y1; Ystep];
y0 = Ystep(length(Ystep),:); % Initial Conditions; units: nM
y0(3) = y0(3) + p.Dose;
end
T1 = [0:TimeLen/240:TimeLen*10-TimeLen/240];
CurrentD1 = Y1(:,1)*p.V + Y1(:,3) ; % Total drug amount in system
Conc = Y1(:,1);
Time = T1;

end

% MASS BALANCE
InitialDrug = p.Dose;
DrugIn = floor(T1./TimeLen)*p.Dose;
DrugIn = DrugIn';
%DrugIn = 0;
DrugOut = Y1(:,2);
BalanceD1 = DrugIn - DrugOut - CurrentD1 + InitialDrug ; %(zero = balance)

% Add an automated check/report on mass balance, since we don't want to 
% look at hundreds of mass balance graphs
if mean(BalanceD1)>1e-6
    disp('Mass imbalance possible: ');
    disp(BalanceD1);
end

% calculate AUC by integrating the concentration curve (trapezoidal rule)
AUC = 0;
for i=1:(length(Y1)-1)
    AUC = AUC + 0.5*(Y1(i,1)+Y1(i+1,1))*(T1(i+1)-T1(i));
end

Ctrough = Y1(length(Y1), 1);


%% VISUALIZATION OF MASS BALANCE

if MASS_BAL_VIS == 1
%Concentration of Lev in central comp
figure; 
ax1=subplot(2,2,1); 
plot(ax1,T1,Y1(:,1),'linewidth',3)
title(ax1,'Concentration of Levetiracetam in Compartment')
ylabel(ax1,'[D] (mg/L)')
xlabel(ax1,'Time (hrs)')

%Amount of drug cleared
ax2=subplot(2,2,2);
plot(ax2,T1,Y1(:,2),'linewidth',3)
title(ax2,'Total Amount of Drug Cleared')
ylabel(ax2,'Total Drug (mg)')
xlabel(ax2,'Time (hrs)')

%Amount of drug in gut
ax3=subplot(2,2,3);
plot(ax3,T1,Y1(:,3),'linewidth',3)
title(ax3,'Total Amount of Drug In Gut')
ylabel(ax3,'Total Drug (mg)')
xlabel(ax3,'Time (hrs)')

%Mass balance
ax4=subplot(2,2,4);
plot(ax4,T1,BalanceD1,'linewidth',3)
title(ax4,'Mass/molecular balance for the drug')
ylabel(ax4,'Balance of drug (mg)')
xlabel(ax4,'Time (hrs)')
end

