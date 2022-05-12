%% STEP 2:

% Perform sensitivity analysis for AUC and Ctrough for PK parameters, and
% for AUEC and Etrough for PD parameters

% Model parameters for array p
q = 0;     % units: nmol/hr
V = 21.9; % units: L (volume of distribution)
kA  =  3.83; % units: 1/hr (absorption rate constant)
kCL = 0.113; %units: 1/hr (clearance rate constant)
Dose = 400; %mg
TimeLen = 12; %hours between doses
IC50 = 2.43; %mg/L
Kd = 1.3617; % units: mg/L
MISSED = 0;

% Initial concentrations
y0 = [0, 0, Dose]; %mg

ParamDelta = 0.05; % test sensitivity to a 5% change

%% RUN BASE CASE

p0 = [kA V kCL Dose TimeLen]';
p0labels = {'kA' 'V' 'kCL' 'Dose' 'TimeLen'}';

[y0,t0,auc0,ctrough0,receptor0,effect0,ptonic0,pclonic0,auecTonic0,Etrough_tonic0,auecClonic0,Etrough_clonic0] = Levetiracetam_sim(kA,V,kCL,Dose,TimeLen,q,IC50,Kd,0,1,0);
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
    [y1, t1, auc(i),ctrough(i),receptor1,effect1,ptonic1,pclonic1,auecTonic(i),Etrough_tonic(i),auecClonic(i),Etrough_clonic(i)] = Levetiracetam_sim(p(1),p(2),p(3),p(4),p(5),q,IC50,Kd,0,1,0);
    t = [t t1'];
    y = [y y1];
    receptor = [receptor receptor1];
    effect = [effect effect1];
    ptonic = [ptonic ptonic1];
    pclonic = [pclonic pclonic1];
    
    %Relative sensitivity analysis for all model efficacy metrics
    Sens(i) = ((auc(i)-auc0)/auc0)/((p(i)-p0(i))/p0(i)); % relative sensitivity vs parameter
    SensCtrough(i) = ((ctrough(i)-ctrough0)/ctrough0)/((p(i)-p0(i))/p0(i)); % relative sensitivity vs parameter
    SensPD_TonicAUC(i) = ((auecTonic(i)-auecTonic0)/auecTonic0)/((p(i)-p0(i))/p0(i)); % relative sensitivity vs parameter
    SensPD_ClonicAUC(i) = ((auecClonic(i)-auecClonic0)/auecClonic0)/((p(i)-p0(i))/p0(i)); % relative sensitivity vs parameter
    SensPD_TonicEtrough(i) = ((Etrough_tonic(i)-Etrough_tonic0)/Etrough_tonic0)/((p(i)-p0(i))/p0(i)); % relative sensitivity vs parameter
    SensPD_ClonicEtrough(i) = ((Etrough_clonic(i)-Etrough_clonic0)/Etrough_clonic0)/((p(i)-p0(i))/p0(i)); % relative sensitivity vs parameter
    
end
    
    %% Save data for sensitivity analysis to import into R
    % Columns correspond to parameters kA, V, kCL, Dose, and TimeLen 
    save sens_analysis_data/SensAUC.mat Sens;
    save sens_analysis_data/SensCtrough.mat SensCtrough;
    save sens_analysis_data/SensTonicAUEC.mat SensPD_TonicAUC;
    save sens_analysis_data/SensClonicAUEC.mat SensPD_ClonicAUC;
    save sens_analysis_data/SensTonicEtrough.mat SensPD_TonicEtrough;
    save sens_analysis_data/SensClonicEtrough.mat SensPD_ClonicEtrough;
    
    