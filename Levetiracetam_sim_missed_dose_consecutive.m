function [Conc,Time,AUC,Ctrough, R, E, P_tonic, P_clonic,AUEC_tonic,E_tonic_trough,AUEC_clonic,E_clonic_trough] = Levetiracetam_sim_missed_dose_consecutive(kA, V, kCL, Dose, TimeLen, q, IC50, Kd, MASS_BAL_VIS, DOSEFREQ, MISSED);

%% PARAMETERS
p.q = 0;     % units: nmol/hr
p.V = V; % units: L (volume of distribution)
p.kA  =  kA; % units: 1/hr (absorption rate constant
p.kCL = kCL; %units: 1/hr (clearance rate constant)
p.Dose = Dose;
alpha1 = 2.8366;
beta1 = -154.44;
alpha2 = 3.2205;
beta2 = -169.11;

y0 = [0 0 Dose]'; 
% y0(1) = concentration in central compartment
% y0(2) = amount cleared
% y0(3) = amount in gut 

%% SIMULATIONS

%% Single dose
if DOSEFREQ == 0
y0 = [0 0 Dose]'; % Initial Conditions; units: mg/L
options = odeset('MaxStep',5e-2, 'AbsTol', 1e-5,'RelTol', 1e-5,'InitialStep', 1e-2);
[T1,Y1] = ode45(@Levetiracetam_eqns,[0 TimeLen],y0,options,p); % simulate model
CurrentD1 = Y1(:,1)*p.V + Y1(:,3) ; % Total drug amount in system
Conc = Y1;
Time = T1;
DrugIn = 0;
end

%% Repeated dosing (also double dosing and skipped dose)
% MISSED = 0 -> no missed doses 
% MISSED = 1 -> 1 missed dose
% MISSED = 2 -> 2 consecutive missed dose
% MISSED = 3 -> 3 consecutive missed dose
% MISSED = 4 -> 4 consecutive missed dose

if DOSEFREQ == 1
    y0 = [0 0 Dose]'; % Initial Conditions; units: mg/L
    options = odeset('MaxStep',5e-2, 'AbsTol', 1e-5,'RelTol', 1e-5,'InitialStep', 1e-2);
    Y1 = [];
    DrugIn = [];

    %Repeated dosing
    for i = 1:10
        [T,Ystep] = ode45(@Levetiracetam_eqns,[0:TimeLen/240:TimeLen-TimeLen/240],y0,options,p); % simulate model
        Y1 = [Y1; Ystep];
        y0 = Ystep(length(Ystep),:); % Initial Conditions; units: nM
        y0(3) = y0(3) + Dose;

        %Calculating DrugIn depending on time step 
        DrugAdded = ones(length(Ystep),1)*(i-1)*Dose;

        %1st missed dose (4th dose is taken normaly)
        if i == 4 && (MISSED == 1 || MISSED == 2 || MISSED == 3 || MISSED == 4)
            y0(3) = y0(3) - Dose;
        end

        %2nd missed dose (4th dose is taken normally)
        if i == 5 && (MISSED == 2 || MISSED == 3 || MISSED == 4)
            y0(3) = y0(3) - Dose;
        end

        %3rd missed dose (4th dose is taken normally)
        if i == 6 && (MISSED == 3 || MISSED == 4)
            y0(3) = y0(3) - Dose;
        end

        %4th missed dose (4th dose is taken normally)
        if i == 7 && (MISSED == 4)
            y0(3) = y0(3) - Dose;
        end
        
        %All doses following the 1st missed dose are 1 less
        if i > 4 && (MISSED == 1 || MISSED == 2 || MISSED == 3 || MISSED == 4)
            DrugAdded = ones(length(Ystep),1)*(i-2)*Dose;
        end
        
        %All doses following the 2nd missed dose are 2 less
        if i > 5 && (MISSED == 2 || MISSED == 3 || MISSED == 4)
            DrugAdded = ones(length(Ystep),1)*(i-3)*Dose;
        end
        
        %All doses following the 2nd missed dose are 3 less
        if i > 6 && (MISSED == 3 || MISSED == 4)
            DrugAdded = ones(length(Ystep),1)*(i-4)*Dose;
        end
        
        %All doses following the 2nd missed dose are 3 less
        if i > 7 && (MISSED == 4)
            DrugAdded = ones(length(Ystep),1)*(i-5)*Dose;
        end
        
        %Amount of drug going into system
        DrugIn = [DrugIn; DrugAdded];
        
    end
    
    T1 = [0:TimeLen/240:TimeLen*10-TimeLen/240]; %Total time
    CurrentD1 = Y1(:,1)*p.V + Y1(:,3); % Total drug amount in system
    Conc = Y1(:,1);
    Time = T1;
    
end
%% Effect models for receptor occupancy
R = (100.*Y1(:,1))./(IC50+Y1(:,1)); %Percent receptors occupied based on IC50
E = (100.*Y1(:,1))./(Kd+Y1(:,1)); %Percent receptors occupied based on Kd
P_tonic = alpha2.*E+beta2; %Protection from tonic seizures based on receptor occupancy
P_clonic = alpha1.*E+beta1; %Protection from clonic seizures based on receptor occupancy

%% Updating negative values and normalizing
ind = P_tonic<0;
P_tonic(ind) = 0;
P_tonic = P_tonic./(1.5294);

ind2 = P_clonic<0;
P_clonic(ind2) = 0;
P_clonic = P_clonic./(1.2922);

%% MASS BALANCE
InitialDrug = Dose;
DrugOut = Y1(:,2);
BalanceD1 = DrugIn - DrugOut - CurrentD1 + InitialDrug; %(zero = balance)

% Add an automated check/report on mass balance, since we don't want to 
% look at hundreds of mass balance graphs
if mean(BalanceD1)>1e-6
    disp('Mass imbalance possible: ');
    disp(BalanceD1);
end

%% calculate AUEC by integrating the protection against tonic seizures curve (trapezoidal rule)
AUEC_tonic = 0;
for i=1:(length(P_tonic)-1)
    AUEC_tonic = AUEC_tonic + 0.5*(P_tonic(i,1)+P_tonic(i+1,1))*(T1(i+1)-T1(i));
end

%Calculate Ctrough
E_tonic_trough = P_tonic(length(P_tonic), 1);

%% calculate AUEC by integrating the protection against clonic seizures curve (trapezoidal rule)
AUEC_clonic = 0;
for i=1:(length(P_tonic)-1)
    AUEC_clonic = AUEC_clonic + 0.5*(P_clonic(i,1)+P_clonic(i+1,1))*(T1(i+1)-T1(i));
end

%Calculate Ctrough
E_clonic_trough = P_clonic(length(P_clonic), 1);

%% calculate AUC by integrating the concentration curve (trapezoidal rule)
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

