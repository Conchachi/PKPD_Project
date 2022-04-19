%% STEP 2:

% Perform sensitivity analysis for AUC and Ctrough for PK parameters, and
% for AUEC and Etrough for PD parameters

% Model parameters for array p
q = 0;     % units: nmol/hr
V = 40; % units: L (volume of distribution)
kA  =  2.44; % units: 1/hr (absorption rate constant)
kCL = 0.096; %units: 1/hr (clearance rate constant)
Dose = 500; %mg
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
    
    %{
    %I DON'T THINK WE NEED THESE
    SensB(i) = ((auc(i)-auc0))/((p(i)-p0(i))); % absolute sensitivity vs parameter
    SensAbs(i) = ((auc(i)-auc0)/auc0); % relative change (not normalized to parameter)
    SensT = ((y1-y0)./y0)/((p(i)-p0(i))/p0(i)); % time-dependent relative sensitivity
    [maxS,indT] = max(abs(SensT)); 
    SensTmax(i) = t1(indT); % time to max relative sensitivity
    
    if i==1
        SensTarr = SensT;
    else
        SensTarr = [SensTarr SensT];
    end
    %}
end
    
    %Relative sensitivity of AUC Plot
    figure;
    bar(Sens);  
	ax = gca; % assign a handle (ax) for the current axes
    ax.FontSize = 14;
    title('Relative sensitivity of AUC');
    ylabel({'Relative sensitivity of AUC';'(dY/Y)/(dP/P)'})
    xlabel('Parameters')
    xticks([1:1:length(p0)])
    xticklabels(p0labels);
    xlim([.5 (length(p0)+.5)])
    ylim([-1.75 1.75]);
    
    
    %Relative sensitivity for Ctrough Plot
    figure;
    bar(SensCtrough);  
	ax = gca; % assign a handle (ax) for the current axes
    ax.FontSize = 14;
    title('Relative sensitivity of Ctrough');
    ylabel({'Relative sensitivity of Ctrough';'(dY/Y)/(dP/P)'})
    xlabel('Parameters')
    xticks([1:1:length(p0)])
    xticklabels(p0labels);
    xlim([.5 (length(p0)+.5)])
    ylim([-1.75 1.75]);

    
    %Relative sensitivity of AUEC (tonic) Plot
    figure;
    bar(SensPD_TonicAUC);  
	ax = gca; % assign a handle (ax) for the current axes
    ax.FontSize = 14;
    title('Relative sensitivity of AUEC: Tonic Seizure Protection');
    ylabel({'Relative sensitivity of AUEC_{Tonic}';'(dY/Y)/(dP/P)'})
    xlabel('Parameters')
    xticks([1:1:length(p0)])
    xticklabels(p0labels);
    xlim([.5 (length(p0)+.5)])
    ylim([-1.75 1.75]);
    
    %Relative sensitivity of AUEC (clonic) Plot
    figure;
    bar(SensPD_ClonicAUC);  
	ax = gca; % assign a handle (ax) for the current axes
    ax.FontSize = 14;
    title('Relative sensitivity of AUEC: Clonic Seizure Protection');
    ylabel({'Relative sensitivity of AUEC_{Clonic}';'(dY/Y)/(dP/P)'})
    xlabel('Parameters')
    xticks([1:1:length(p0)])
    xticklabels(p0labels);
    xlim([.5 (length(p0)+.5)])
    ylim([-1.75 1.75]);
    
     %Relative sensitivity of AUEC (tonic) Plot
    figure;
    bar(SensPD_TonicEtrough);  
	ax = gca; % assign a handle (ax) for the current axes
    ax.FontSize = 14;
    title('Relative sensitivity of Etrough: Tonic Seizure Protection');
    ylabel({'Relative sensitivity of Etrough_{Tonic}';'(dY/Y)/(dP/P)'})
    xlabel('Parameters')
    xticks([1:1:length(p0)])
    xticklabels(p0labels);
    xlim([.5 (length(p0)+.5)])
    ylim([-1.75 1.75]);
    
    %Relative sensitivity of AUEC (clonic) Plot
    figure;
    bar(SensPD_ClonicEtrough);  
	ax = gca; % assign a handle (ax) for the current axes
    ax.FontSize = 14;
    title('Relative sensitivity of Etrough: Clonic Seizure Protection');
    ylabel({'Relative sensitivity of Etrough_{Clonic}';'(dY/Y)/(dP/P)'})
    xlabel('Parameters')
    xticks([1:1:length(p0)])
    xticklabels(p0labels);
    xlim([.5 (length(p0)+.5)])
    ylim([-1.75 1.75]);
    
    %{

    %Concentration Plots (Sensitivity Analysis)
figure;
hold on
for i=1:(length(p0))
    plot(t(:,i+1),y(:,i));
end
ax = gca; 
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
ax = gca;
ax.FontSize = 14;
ylabel({'Relative sensitivity of concentration','(dY/Y)/(dP/P)'})
xlabel('Time (hr)')
    
    
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
    
%}
    
    %% Save data for sensitivity analysis to import into R
    % Columns correspond to parameters kA, V, kCL, Dose, and TimeLen 
    save SensAUC.mat Sens;
    save SensCtrough.mat SensCtrough;
    save SensTonicAUEC.mat SensPD_TonicAUC;
    save SensClonicAUEC.mat SensPD_ClonicAUC;
    save SensTonicEtrough.mat SensPD_TonicEtrough;
    save SensClonicEtrough.mat SensPD_ClonicEtrough;
    
    
%% Need to do global sensitivity analysis in addition or instead of LSA???
    