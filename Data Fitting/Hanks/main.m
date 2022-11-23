addpath('../../RecurrentModel');
numNode = 1;
[sortNum, myCluster] = RndCtrl(numNode);
mypool = parpool(myCluster, myCluster.NumWorkers);
​
%% Model fitting with Bayesian Adaptive Direct Search (BADS) optimization algorithm
addpath(genpath('../../RecurrentModel/bads/bads-master'));
addpath('../CoreFunctions/');
addpath('./SvrCode/');
out_dir = '../../RecurrentModel/Fit/Rslts/FitBhvr7ParamsIV_QMLE_SvrGPU';
if ~exist(out_dir,'dir')
    mkdir(out_dir);
end
%%
% Take data from Roitman & Shadlen, 2002
dataDynmc = load('../../RecurrentModel/Fit/Data/Data.mat');
dataBhvr = LoadRoitmanData('../../RecurrentModel/RoitmanDataCode');
% Fix random seed for reproducibility
% rng(1);
% change random seed
t = datenum(clock)*10^10 - floor(datenum(clock)*100)*10^8 + sortNum*10^7;
num2str(t);
rng(t);
% Define optimization starting point and bounds
%     a,    b, noise, scale, Tau
LB = [0    0.1   .1    .1*256 [.001,.001,.001]];
UB = [70   3	100  20*256 [1,1,1]];
PLB = [15  .9	5    1*256 [.01 .01 .01]];
PUB = [60   1.7	40   8*256 [.2 .2 .2]];
​
% Randomize initial starting point inside plausible box
x0 = rand(1,numel(LB)) .* (PUB - PLB) + PLB;
​
% likelihood function
% parpool(6);
nLLfun = @(params) LDDMFitBhvr7ParamsIV_QMLE_GPU(params, dataBhvr);
[fvalbest,~,~] = nLLfun(x0)
fprintf('test succeeded\n');
% change starting points
Collect = [];
parfor i = 1:myCluster.NumWorkers*8
    !ping -c 1 www.amazon.com
    t = datenum(clock)*10^10 - floor(datenum(clock)*100)*10^8 + sortNum*10^7 + i*10^5;
    %num2str(t);
    rng(t);
    
    % Randomize initial starting point inside plausible box
    x0 = rand(1,numel(LB)) .* (PUB - PLB) + PLB;
    dlmwrite(fullfile(out_dir,'x0List.txt'),[sortNum, i, t, x0],'delimiter','\t','precision','%.6f','-append');
    % fit
    options = bads('defaults');     % Default options
    options.Display = 'iter';
    % options.UncertaintyHandling = false;    % Function is deterministic
    options.UncertaintyHandling = true;    % Function is deterministic
    [xest,fval,~,output] = bads(nLLfun,x0,LB,UB,PLB,PUB,options);
    %     xest
    %     fval
    %     output
    dlmwrite(fullfile(out_dir,'RsltList.txt'),[sortNum, i, t, xest fval],'delimiter','\t','precision','%.6f','-append');
    %     if fval < fvalbest
    %         xbest = xest;
    %         fvalbest = fval;
    %         outputbest = output;
    %     end
    % save(fullfile(out_dir,sprintf('./Rslts%i_%i.mat', sortNum, i)),'xest','fval','output');
    Collect(i).rndseed = t;
    Collect(i).x0 = x0;
    Collect(i).xest = xest;
    Collect(i).fval = fval;
    Collect(i).output = output;
    
end
t = datenum(clock)*10^10 - floor(datenum(clock)*100)*10^8 + sortNum*10^7 + i*10^5;
save(fullfile(out_dir,sprintf('CollectRslts%i.mat',t)),'Collect');
​
​
if 0
%% hand tuning
Homedir = 'C:\Users\Bo';
% Homedir = '~';
addpath(fullfile(Homedir,'Documents','LDDM','CoreFunctions'));
addpath(fullfile(Homedir,'Documents','LDDM','utils'));
addpath(genpath(fullfile(Homedir,'Documents','LDDM','Fit')));
cd('G:\My Drive\LDDM\Fit');
% cd('/Volumes/GoogleDrive/My Drive/LDDM/Fit');
out_dir = './Rslts/FitBhvr7ParamsIV_QMLE_SvrGPU';
if ~exist(out_dir,'dir')
    mkdir(out_dir);
end
plot_dir = fullfile(out_dir,'graphics');
if ~exist(plot_dir,'dir')
    mkdir(plot_dir);
end
dataDynmc = load('./Data/Data.mat');
dataBhvr = LoadRoitmanData('../RoitmanDataCode');
randseed = 24356545;
rng(randseed);
% a, b, noise, scale, tauRGI, nLL
params = [0.000056	1.433901	24.837397	3254.833078	0.183152	0.248698	0.309921	16542.77267]; % 16542.77267 ± 2.7264
% params = [0	1.433631	25.35945	3251.289056	0.185325	0.224459	0.323132
% 16539.138186]; % the old results
name = sprintf('a%2.2f_b%1.2f_sgm%2.1f_scale%4.1f_tau%1.2f_%1.2f_%1.2f_nLL%5.2f',params);
if ~exist(fullfile(plot_dir,sprintf('PlotData_%s.mat',name)),'file')
    tic;
    [nLL, Chi2, BIC, AIC, rtmat, choicemat] = LDDMFitBhvr7ParamsIV_QMLE_GPU(params, dataBhvr);
    toc
    save(fullfile(plot_dir,sprintf('PlotData_%s.mat',name)),...
        'rtmat','choicemat','params','nLL','Chi2','AIC','BIC');
else
    load(fullfile(plot_dir,sprintf('PlotData_%s.mat',name)));
end
​
%% Example dynamics
lwd = 1;
mksz = 3;
fontsize = 11;
rng(randseed);
% a, b, noise, scale, tauRGI, nLL
simname = sprintf('LDDM_Dynmc_a%2.2f_b%1.2f_sgm%2.1f_scale%4.1f_tau%1.2f_%1.2f_%1.2f_nLL%4.0f',params);
​
a = params(1)*eye(2);
b = params(2)*eye(2);
sgm = params(3)/5;
tauR = params(5);
tauG = params(6);
tauI = params(7);
Tau = [tauR tauG tauI];
ndt = .09 + .03; % sec, 90ms after stimuli onset, resort to the saccade side,
% the activities reaches peak 30ms before initiation of saccade, according to Roitman & Shadlen
presentt = 0; % changed for this version to move the fitting begin after the time point of recovery
scale = params(4);
​
predur = 0;
triggert = 0;
dur = 5;
dt =.001;
thresh = 70; %70.8399; % mean(max(m_mr1cD))+1; 
stimdur = dur;
stoprule = 1;
w = [1 1; 1 1];
Rstar = 32; % ~ 32 Hz at the bottom of initial fip, according to Roitman and Shadlen's data
initialvals = [Rstar,Rstar; sum(w(1,:))*Rstar,sum(w(2,:))*Rstar; 0,0];
eqlb = Rstar; % set equilibrium value before task as R^*
Vprior = [1, 1]*(2*mean(w,'all')*eqlb.^2 + (1-a(1)).*eqlb);
​
Cohr = [0 32 64 128 256 512]/1000; % percent of coherence
c1 = (1 + Cohr)';
c2 = (1 - Cohr)';
cplist = [c1, c2];
mygray = flip(gray(length(cplist)));
​
h = figure; 
% subplot(2,1,1);
hold on;
filename = sprintf('%s',simname);
randseed = 75245522;
rng(randseed);
for vi = 2:6
    Vinput = cplist(vi,:)*scale;
%     [R, G, I, rt, choice] = LcDsInhbt(Vinput, w, a, b, sgm, Tau, dur,...
%         dt, presentt, triggert, thresh, initialvals, stimdur, stoprule);
    [~, ~, R, G, I] = LDDM(Vprior, Vinput, w, a, b, sgm, Tau, predur, dur,...
    dt, presentt, triggert, thresh, initialvals, stimdur, stoprule);
    lgd2(vi-1) = plot(R(:,2), 'k-.', 'Color', mygray(vi,:), 'LineWidth',lwd);
    lgd1(vi-1) = plot(R(R(:,1)<=thresh,1), 'k-', 'Color', mygray(vi,:), 'LineWidth',lwd);
end
% legend()
plot([.2, 1.2]/dt,[thresh,thresh], 'k-');
text(600,thresh*1.1,'threshold');
yticks([0,32,70]);
yticklabels({'0','32','70'});
ylabel('Activity (Hz)');
ylim([0,74]);
xticks([0, 500, 1000, 1500]);
xticklabels({'0','.5','1.0','1.5'});
xlim([-50, 1200]);
xlabel('Time (s)');
savefigs(h, filename, plot_dir, fontsize, [2 1.5]);
% 
% subplot(2,1,2); hold on;
% for vi = 2:6
%     Vinput = cplist(vi,:)*scale;
%     [~, ~, R, G, I] = LDDM(Vinput, w, a, b, sgm, Tau, dur,...
%     dt, presentt, triggert, thresh, initialvals, stismdur, stoprule);
%     lgd2(vi-1) = plot(diff(R(:,2)), 'k--', 'Color', mygray(vi+1,:), 'LineWidth',lwd);
%     lgd1(vi-1) = plot(diff(R(:,1)), 'k-', 'Color', mygray(vi+1,:), 'LineWidth',lwd);
% end
% ylabel('Time derivative');
% xticks([0, 500, 1000, 1500]);
% xticklabels({'0','.5','1.0','1.5'});
% xlim([-50, 1800]);
% yticks([-.1,0,.3]);
% ylim([-.1, .35]);
% xlabel('Time (s)');
% savefigs(h, filename, plot_dir, fontsize, [1.8 2.5]);
​
%% plot RT distribution - fitted
rate = length(rtmat)/1024;
maxrt = max(max(rtmat));
minrt = min(min(rtmat));
%segrt = maxrt - minrt;
bank1 = [];
bank2 = [];
acc = [];
meanrtc = [];
meanrtw = [];
for ii = 1:6
    gap = (dataBhvr.rtrange(ii,2) - dataBhvr.rtrange(ii,1))/dataBhvr.numbins;
    %gap = 1.757/60;
    BinEdge = [minrt:gap:(maxrt+gap)];
    hg = histogram(rtmat(choicemat(:,ii)==1,ii),'BinEdges',BinEdge);
    bank1{ii} = hg.Values/rate;
    hg = histogram(rtmat(choicemat(:,ii)==2,ii),'BinEdges',BinEdge);
    bank2{ii}= hg.Values/rate;
    BinMiddle{ii} = hg.BinEdges(1:end-1) + hg.BinWidth/2;
    acc(ii) = sum(choicemat(:,ii)==1)/(sum(choicemat(:,ii)==1) + sum(choicemat(:,ii)==2));
    meanrtc(ii) = mean(rtmat(choicemat(:,ii)==1,ii));
    meanrtw(ii) = mean(rtmat(choicemat(:,ii)==2,ii));
end
% loading Roitman's data
addpath('../RoitmanDataCode');
ColumnNames608
load T1RT.mat;
x(:,R_RT) = x(:,R_RT)/1000;
cohlist = unique(x(:,R_COH));
maxrt = max(x(:,R_RT));
minrt = min(x(:,R_RT));
segrt = maxrt - minrt;
bins = 30;
BinEdge = [minrt:segrt/bins:maxrt];
bank1r = [];
bank2r = [];
accr = [];
meanrtcr = [];
meanrtwr = [];
for i = 1:length(cohlist)
    Lcoh = x(:,R_COH)==cohlist(i);
    if i == 1
        Dir1 = x(:,R_TRG) == 1;
        Dir2 = x(:,R_TRG) == 2;
        RT_corr = x(Lcoh & Dir1,R_RT);
        RT_wro = x(Lcoh & Dir2, R_RT);
    else
        Corr = x(:,R_DIR) == x(:,R_TRG);
        Wro = x(:,R_DIR) ~= x(:,R_TRG);
        RT_corr = x(Lcoh & Corr,R_RT);
        RT_wro = x(Lcoh & Wro, R_RT);
    end
    accr(i) = numel(RT_corr)/(numel(RT_corr) + numel(RT_wro));
    meanrtcr(i) = mean(RT_corr);
    meanrtwr(i) = mean(RT_wro);
    hg = histogram(RT_corr,'BinEdges',BinEdge);
    bank1r(:,i) = hg.Values;
    if ~isempty(RT_wro)
        hg = histogram(RT_wro,'BinEdges',BinEdge);
        bank2r(:,i) = hg.Values;
    else
        bank2r(:,i) = zeros(1,bins);
    end
end
BinMiddler = hg.BinEdges(1:end-1) + hg.BinWidth/2;
h = figure;
for ii = 1:6
    subplot(6,1,ii);
    % bar(BinMiddler,bank1r(:,ii),'FaceColor','#0072BD','EdgeAlpha',0);
    bar(dataBhvr.bincenter(ii,1:30),dataBhvr.histmat(ii,1:30)*1024,'FaceColor','#0072BD','EdgeAlpha',0);
    hold on;
    % bar(BinMiddler,-bank2r(:,ii),'FaceColor','#D95319','EdgeAlpha',0);
    %plot(BinMiddle{ii},bank1{ii},'c','LineWidth',1.5);
    %plot(BinMiddle{ii},-bank2{ii},'r','LineWidth',1.5);
    bar(dataBhvr.bincenter(ii,1:30),-dataBhvr.histmat(ii,31:60)*1024,'FaceColor','#D95319','EdgeAlpha',0,'EdgeColor','none');
    plot(BinMiddle{ii},bank1{ii},'c','LineWidth',2);
    plot(BinMiddle{ii},-bank2{ii},'m','LineWidth',2);
    if ii == 7
        legend({'','','Correct','Error'},'NumColumns',2,'Location','North');
        legend('boxoff');
    end
    ylim([-60,100]);
    yticks([-50:50:100]);
    yticklabels({'50','0','50','100'});
    xlim([100 1762]/1000);
    xticks([.5,1.0,1.5]);
    if ii == 6
        xticklabels({'.5','1.0','1.5'});
        xlabel('Reaction time (secs)');
    else
        xticklabels({});
    end
    if ii == 1
        ylabel('Frequency');
    end
    % title(sprintf('coherence %2.1f %%',cohlist(ii)*100));
    set(gca,'FontSize',16);
    set(gca,'TickDir','out');
    H = gca;
    H.LineWidth = 1;
    set(gca, 'box','off');
end
%set(gca,'FontSize',18);
​
h.PaperUnits = 'inches';
h.PaperPosition = [0 0 3.0 10];
%saveas(h,fullfile(plot_dir,sprintf('RTDistrb_%s.fig',name)),'fig');
saveas(h,fullfile(plot_dir,sprintf('RTDistrb_%s.eps',name)),'epsc2');
%% panel a, ditribution of RT and fitted line
lwd = 1;
fontsize = 11;
colorpalette = {'#ef476f','#ffd166','#06d6a0','#118ab2','#073b4c'};
aspect8 = [2, 6.4]; % for the long format RT distribution fitting panels
h = figure;
filename = 'Fig5a';
for ii = 1:6
    subplot(6,1,ii);hold on;
    bar(dataBhvr.bincenter(ii,1:30),dataBhvr.histmat(ii,1:30)*1024,'FaceColor',colorpalette{3},'EdgeAlpha',0);
    bar(dataBhvr.bincenter(ii,1:30),-dataBhvr.histmat(ii,31:60)*1024,'FaceColor',colorpalette{2},'EdgeAlpha',0,'EdgeColor','none');
    plot(BinMiddle{ii},bank1{ii},'Color',colorpalette{4},'LineWidth',lwd);
    plot(BinMiddle{ii},-bank2{ii},'Color',colorpalette{1},'LineWidth',lwd);
    if ii == 7
        legend({'','','Correct','Error'},'NumColumns',2,'Location','North');
        legend('boxoff');
    end
    ylim([-60,100]);
    yticks([-50:50:100]);
    yticklabels({'50','0','50','100'});
    xlim([100 1762]/1000);
    xticks([.5,1.0,1.5]);
    if ii == 6
        xticklabels({'.5','1.0','1.5'});
        xlabel('Reaction time (s)');
    else
        xticklabels({});
    end
    if ii == 1
        ylabel(' ');
    end
    set(gca, 'box','off');
    savefigs(h, filename, plot_dir, fontsize, aspect8);
end
%% aggregated RT & ACC
lwd = 1;
mksz = 3;
fontsize = 11;
Cohr = [0 32 64 128 256 512]/1000;
cplist = Cohr*100;
cplist(1) = 1.1;
h = figure;
filename = sprintf('RT&ACC_%s',name);
subplot(2,1,1);
hold on;
plot(cplist, accr*100, 'xk', 'MarkerSize', mksz+1);
plot(cplist, acc*100,'-k','LineWidth',lwd);
ylim([.45,1]*100);
yticks([50,100]);
xlim([1,100]);
xticks([1,10,100]);
xticklabels({'0','10','100'});
ylabel('Correct (%)');
xlabel('Input coherence (%)');
set(gca, 'XScale', 'log');
legend({'data','model'},'NumColumns',1,'Location','SouthEast','FontSize',fontsize-2);
legend('boxoff');
savefigs(h,filename,plot_dir,fontsize,[2,3.0]);
​
subplot(2,1,2);
hold on;
lg1 = plot(cplist, meanrtcr, '.k', 'MarkerSize', mksz*3);
lg2 = plot(cplist, meanrtc, '-k','LineWidth',lwd);
lg3 = plot(cplist, meanrtwr, 'ok', 'MarkerSize', mksz);
lg4 = plot(cplist, meanrtw, '--k','LineWidth',lwd);
xlim([1,100]);
xticks([1,10,100]);
xticklabels({'0','10','100'});
yticks([.4,1]);
ylim([.4, 1]);
ylabel('RT (secs)');
xlabel('Input coherence (%)');
set(gca, 'XScale', 'log');
% lgd = leg...