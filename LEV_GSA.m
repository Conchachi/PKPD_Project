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

%%

% %Heatmap of Ctrough
% figure;
% h1 = heatmap(kCL_dist, TimeLen_dist, ctrough);
% h1.Colormap = parula;
% h1.FontSize = 14;
% h1.Title = 'Global sensitivity: C_{trough}';
% h1.XLabel = 'kCL';
% h1.YLabel = 'TimeLen';
% 
% %Heatmap of Etrough tonic
% figure;
% h1 = heatmap(kCL_dist, TimeLen_dist, etroughT);
% h1.Colormap = parula;
% h1.FontSize = 14;
% h1.Title = 'Global sensitivity: E_{trough} Tonic';
% h1.XLabel = 'kCL';
% h1.YLabel = 'TimeLen';
% 
% %Heatmap of Etrough clonic
% figure;
% h1 = heatmap(kCL_dist, TimeLen_dist, etroughC);
% h1.Colormap = parula;
% h1.FontSize = 14;
% h1.Title = 'Global sensitivity: E_{trough} Clonic';
% h1.XLabel = 'kCL';
% h1.YLabel = 'TimeLen';

% %Save to import into R
% save TimeLen_GSA.mat TimeLen_dist;
% save kCL_GSA.mat kCL_dist;
% save Ctrough_GSA.mat ctrough;
% save EtroughTONIC_GSA.mat etroughT;
% save EtroughCLONIC_GSA.mat etroughC;


%% PARAMETERS
kA = 3.83; %units: 1/h (kA kept constant)
q = 0;     % units: nmol/hr
V = 21.9; % units: L (volume of distribution)
kCL = 0.113; %units: 1/h
Dose = 400; %mg
TimeLen = 12; %hours between doses
MASS_BAL_VIS = 0; %Set to 1 to visualize mass balance
DOSEFREQ = 1; %Set to 0 for single dose, 1 for repeated dosing
MISSED = 0; %Not doing missed dose analysis
IC50 = 2.43; %mg/L
Kd = 1.3617; % units: mg/L

%Run for range of TimeLen and Dose:
TimeLen_dist = [6:0.5:17.5];
Dose_dist = [100:39.13043:1000];

for i = 1:24
for j= 1:24
    [y1, t1, auc(i, j),ctrough(i, j),receptor,effect,p_tonic,p_clonic,auecT(i, j),etroughT(i, j),auecC(i, j),etroughC(i, j)] = Levetiracetam_sim(kA,V,kCL,Dose_dist(j),TimeLen_dist(i),q,IC50,Kd,0,1,0);
end
end

% %Heatmap of Ctrough
% figure;
% h1 = heatmap(Dose_dist, TimeLen_dist, ctrough);
% h1.Colormap = parula;
% h1.FontSize = 14;
% h1.Title = 'Global sensitivity: C_{trough}';
% h1.XLabel = 'Dose';
% h1.YLabel = 'TimeLen';
% 
% %Heatmap of Etrough tonic
% figure;
% h1 = heatmap(Dose_dist, TimeLen_dist, etroughT);
% h1.Colormap = parula;
% h1.FontSize = 14;
% h1.Title = 'Global sensitivity: E_{trough} Tonic';
% h1.XLabel = 'Dose';
% h1.YLabel = 'TimeLen';
% 
% %Heatmap of Etrough clonic
% figure;
% h1 = heatmap(Dose_dist, TimeLen_dist, etroughC);
% h1.Colormap = parula;
% h1.FontSize = 14;
% h1.Title = 'Global sensitivity: E_{trough} Clonic';
% h1.XLabel = 'Dose';
% h1.YLabel = 'TimeLen';

%Save to import into R
save TimeLen_GSA.mat TimeLen_dist;
save Dose_GSA.mat Dose_dist;
save Ctrough_GSA.mat ctrough;
save EtroughTONIC_GSA.mat etroughT;
save EtroughCLONIC_GSA.mat etroughC;
