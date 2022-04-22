%% STEP 3:
%Population variability--varying ka and kcl in children

% Source: https://onlinelibrary.wiley.com/doi/10.1111/j.1528-1167.2008.01974.x

%% Generate list of ka values
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


%% Generate list of clearance values
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

%Save data to import into R
save kCL_PopVar.mat kCLPPK;
save kA_PopVar.mat kaPPK;

%% Run Simulations

% PARAMETERS
q = 0;     % units: nmol/hr
V = 21.9; % units: L (volume of distribution)
Dose = 400; %mg
TimeLen = 12; %hours between doses
MASS_BAL_VIS = 0; %Set to 1 to visualize mass balance
DOSEFREQ = 1; %Set to 0 for single dose, 1 for repeated dosing
MISSED = 0; %Not doing missed dose analysis
IC50 = 2.43; %mg/L
Kd = 1.3617; % units: mg/L

%% Vary ka only:
kCL = 0.113; %units: 1/hr (kcl kept constant)

%Run for all patients
for i=1:200
    [y1, t1, auc(i),ctrough(i),receptor,effect,p_tonic,p_clonic,auecT(i),etroughT(i),auecC(i),etroughC(i)] = Levetiracetam_sim(kaPPK(i),V,kCL,Dose,TimeLen,q,IC50,Kd,0,1,0);
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

%Plot AUEC tonic vs. ka
figure;
scatter(kaPPK, auecT);
title('AUEC (tonic) vs. ka in children', 'FontSize', 16);
ylabel('AUEC (% * h)', 'FontSize', 12);
xlabel('ka (1/hr)', 'FontSize', 12);

%Plot AUEC clonic vs. ka
figure;
scatter(kaPPK, auecC);
title('AUEC (clonic) vs. ka in children', 'FontSize', 16);
ylabel('AUEC (% * h)', 'FontSize', 12);
xlabel('ka (1/hr)', 'FontSize', 12);

%Plot Etrough tonic vs. ka
figure;
scatter(kaPPK, etroughT);
title('Etrough (tonic) vs. ka in children', 'FontSize', 16);
ylabel('Etrough (%)', 'FontSize', 12);
xlabel('ka (1/hr)', 'FontSize', 12);

%Plot Etrough clonic vs. ka
figure;
scatter(kaPPK, etroughC);
title('Etrough (clonic) vs. ka in children', 'FontSize', 16);
ylabel('Etrough (%)', 'FontSize', 12);
xlabel('ka (1/hr)', 'FontSize', 12);

%Outputs to import into R
outputs_kA_PopVar = [auc', ctrough', auecT', etroughT', auecC', etroughC'];

save kA_PopVar_params.mat outputs_kA_PopVar;


%% Vary kcl only:
kA = 3.83; %units: 1/h (kA kept constant)

%Run for all patients
for i=1:200
    [y1, t1, auc(i),ctrough(i),receptor,effect,p_tonic,p_clonic,auecT(i),etroughT(i),auecC(i),etroughC(i)] = Levetiracetam_sim(kA,V,kCLPPK(i),Dose,TimeLen,q,IC50,Kd,0,1,0);
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
title('Ctrough vs. kcl in children', 'FontSize', 16);
ylabel('Ctrough (mg/L)', 'FontSize', 12);
xlabel('kcl (1/hr)', 'FontSize', 12);

%Plot AUEC tonic vs. kCL
figure;
scatter(kCLPPK, auecT);
title('AUEC (tonic) vs. kcl in children', 'FontSize', 16);
ylabel('AUEC (% * h)', 'FontSize', 12);
xlabel('kcl (1/hr)', 'FontSize', 12);

%Plot AUEC clonic vs. kCL
figure;
scatter(kCLPPK, auecC);
title('AUEC (clonic) vs. kcl in children', 'FontSize', 16);
ylabel('AUEC (% * h)', 'FontSize', 12);
xlabel('kcl (1/hr)', 'FontSize', 12);

%Plot Etrough tonic vs. kCL
figure;
scatter(kCLPPK, etroughT);
title('Etrough (tonic) vs. kcl in children', 'FontSize', 16);
ylabel('Etrough (%)', 'FontSize', 12);
xlabel('kcl (1/hr)', 'FontSize', 12);

%Plot Etrough clonic vs. kCL
figure;
scatter(kCLPPK, etroughC);
title('Etrough (clonic) vs. kcl in children', 'FontSize', 16);
ylabel('Etrough (%)', 'FontSize', 12);
xlabel('kcl (1/hr)', 'FontSize', 12);

%Outputs to import into R
outputs_kCL_PopVar = [auc', ctrough', auecT', etroughT', auecC', etroughC'];

save kCL_PopVar_params.mat outputs_kCL_PopVar;

%% Vary both ka and kcl:

%Run for all patients
for i=1:200
    [y1, t1, auc(i),ctrough(i),receptor,effect,p_tonic,p_clonic,auecT(i),etroughT(i),auecC(i),etroughC(i)] = Levetiracetam_sim(kaPPK(i),V,kCLPPK(i),Dose,TimeLen,q,IC50,Kd,0,1,0);
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

%Outputs to import into R
outputs_kCL_kA_PopVar = [auc', ctrough', auecT', etroughT', auecC', etroughC'];

save kCL_kA_PopVar_params.mat outputs_kCL_kA_PopVar;
