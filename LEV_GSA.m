%% Global sensitivity analysis

% PARAMETERS
kA = 3.83; %units: 1/h (kA kept constant)
q = 0;     % units: nmol/hr
V = 21.9; % units: L (volume of distribution)
Dose = 400; %mg
TimeLen = 12; %hours between doses
MASS_BAL_VIS = 0; %Set to 1 to visualize mass balance
DOSEFREQ = 1; %Set to 0 for single dose, 1 for repeated dosing
MISSED = 0; %Not doing missed dose analysis
IC50 = 2.43; %mg/L
Kd = 1.3617; % units: mg/L

%Run for range of TimeLen and kCL:
TimeLen_dist = [6:0.5:17.5];
kCL_dist = [0.01:0.01:0.24];

for i = 1:24
for j= 1:24
    [y1, t1, auc(i, j),ctrough(i, j),receptor,effect,p_tonic,p_clonic,auecT(i, j),etroughT(i, j),auecC(i, j),etroughC(i, j)] = Levetiracetam_sim(kA,V,kCL_dist(j),Dose,TimeLen_dist(i),q,IC50,Kd,0,1,0);
end
end

%Save to import into R
save sens_analysis_data/TimeLen_GSA.mat TimeLen_dist;
save sens_analysis_data/kCL_GSA.mat kCL_dist;
save sens_analysis_data/Ctrough_GSA.mat ctrough;
save sens_analysis_data/EtroughTONIC_GSA.mat etroughT;
save sens_analysis_data/EtroughCLONIC_GSA.mat etroughC;
