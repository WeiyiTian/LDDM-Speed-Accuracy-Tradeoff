% Fig 6. Data fitting
%% fitting on the server (GPU required)
addpath(genpath('../bads/bads-master'));
addpath(genpath('./FitDynamic/'));
% Please see the code implemented on High performance cluster: main_FitBhvr4ParamsII_QMLE_svr

%% simulating under best fitting parameters, GPU required.
dataDynmc = load('Data.mat');
dataBhvr = LoadRoitmanData('./FitDynamic/RoitmanDataCode');
% a, b, noise, scale,  negtive Loglikelihood - the best fitting by the
% algorithm bads. See the fitting results in
% ./FitDynamic/Rslts/FitBhvr4ParamsII_QMLE_SvrGPU
randseed = 14610483;
rng(randseed);
params = [0.037882	1.340752	30.813328	1343.080397	16943.21813];
w = ones(2);
a = eye(2)*params(1);
b = eye(2)*params(2);
sgm = params(3);
ndt = .03; % sec, resort to the saccade side, the activities reaches peak 30ms before initiation of saccade, according to Roitman & Shadlen
tgap = 0.09; % initial dip for 90ms after stimuli onset
scale = params(4);
deduction = .1;
sims = 1024/deduction;
Cohr = [0 32 64 128 256 512]/1000; % percent of coherence
predur = 0;
triggert = 0;
dur = 5;
thresh = 70; %72.1491;
stimdur = dur;
stoprule = 1;
V1 = (1 + Cohr)';
V2 = (1 - Cohr)';
Vinput = [V1, V2]*scale;
load('Data.mat');
m_mr1c = m_mr1c';
m_mr2c = m_mr2c';
m_mr1cD = m_mr1cD';
m_mr2cD = m_mr2cD';
dot_ax = dot_ax';
sac_ax = sac_ax';
Rstar = 35; % mean(mean([m_mr1c(1:5,:); m_mr2c(1:5,:)])); % 34.6004
initialvals = [Rstar,Rstar; 2*Rstar,2*Rstar; 0,0];
Vprior = ones(6,2)*((1-a(1,1))*Rstar + 2*Rstar^2);
% simulation
name = sprintf('a%2.1f_b%1.1f_tau%1.2f_%1.2f_%1.2fscl%2.1f',a(1,1),b(1,1),Tau,scale);
output = fullfile(datadir,sprintf('FitDynamic_%s.mat',name));
if ~exist(output,'file')
    [rtmat, choicemat, argmaxR, sm_mr1c, sm_mr2c, sm_mr1cD, sm_mr2cD] = LcD_Dynmc_Trim_GPU(Vprior, Vinput, w, a, b,...
        sgm, Tau, predur, dur, dt, tgap, triggert, thresh, initialvals, stimdur, stoprule, sims, dot_ax, sac_ax);
    rtmat = squeeze(rtmat)+ndt;
    choicemat = squeeze(choicemat);
    save(output,...
        'rtmat','choicemat','sm_mr1c','sm_mr2c','sm_mr1cD','sm_mr2cD','a','b','w','sgm','Tau','ndt','scale');
else
    load(output);
end
%% pre-caulculation
rate = length(rtmat)/1024;
maxrt = max(max(rtmat));
minrt = min(min(rtmat));
bank1 = [];
bank2 = [];
acc = [];
meanrtc = [];
meanrtw = [];
for ii = 1:6
    gap = (dataBhvr.rtrange(ii,2) - dataBhvr.rtrange(ii,1))/dataBhvr.numbins;
    BinEdge = [minrt:gap:(maxrt+gap)];
    hg = histogram(rtmat(ii, choicemat(ii,:)==1),'BinEdges',BinEdge, 'Visible',0);
    bank1{ii} = hg.Values/rate;
    hg = histogram(rtmat(ii, choicemat(ii,:)==2),'BinEdges',BinEdge, 'Visible',0);
    bank2{ii}= hg.Values/rate;
    BinMiddle{ii} = hg.BinEdges(1:end-1) + hg.BinWidth/2;
    acc(ii) = sum(choicemat(ii,:)==1)/(sum(choicemat(ii,:)==1) + sum(choicemat(ii,:)==2));
    meanrtc(ii) = mean(rtmat(ii, choicemat(ii,:)==1));
    meanrtw(ii) = mean(rtmat(ii, choicemat(ii,:)==2));
end
% loading Roitman's data
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
    hg = histogram(RT_corr,'BinEdges',BinEdge, 'Visible',0);
    bank1r(:,i) = hg.Values;
    if ~isempty(RT_wro)
        hg = histogram(RT_wro,'BinEdges',BinEdge, 'Visible',0);
        bank2r(:,i) = hg.Values;
    else
        bank2r(:,i) = zeros(1,bins);
    end
end
BinMiddler = hg.BinEdges(1:end-1) + hg.BinWidth/2;
%% panel a, ditribution of RT and fitted line
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
    savefig(h, filename, outdir, fontsize, aspect8);
end

%% panel b, Q-Q plot
ColumnNames608
load T1RT.mat;
h = figure;
hold on;
Rprop = [];
ywro = [];
ycorr = [];
for i = 1:length(cohlist)
    Lcoh = x(:,R_COH)==cohlist(i);
    if i == 1
        Dir1 = x(:,R_TRG) == 2;
        Dir2 = x(:,R_TRG) == 1;
        RT.corr = x(Lcoh & Dir1,R_RT);
        RT.wro = x(Lcoh & Dir2, R_RT);
    else
        Corr = x(:,R_DIR) == x(:,R_TRG);
        Wro = x(:,R_DIR) ~= x(:,R_TRG);
        RT.corr = x(Lcoh & Corr,R_RT);
        RT.wro = x(Lcoh & Wro, R_RT);
    end
    if length(RT.wro) > 0
        ywro(:,i) = quantile(RT.wro,[.1 .3 .5 .7 .9]);
    else
        ywro(:,i) = ones(1,5)*nan;
    end
    ycorr(:,i) = quantile(RT.corr,[.1 .3 .5 .7 .9]);
    Rprop = [length(RT.wro)/(length(RT.corr)+length(RT.wro)), Rprop, length(RT.corr)/(length(RT.corr)+length(RT.wro))];
    % plot([ones(1,5)*length(RT.wro)/(length(RT.corr)+length(RT.wro)) ones(1,5)*length(RT.corr)/(length(RT.corr)+length(RT.wro))], [ywro(:,i)' ycorr(:,i)'],'.k', 'MarkerSize', 20);
end

for qi = 1:5
    mask = [2:6, 7:12];
    hg(qi) = plot(Rprop(mask),[ywro(qi,5:-1:1),ycorr(qi,:)],'.-k','MarkerSize', 14);
end
ylabel('RT quantile (ms)');
xlabel('Response proportion');

Rprop = [];
ywro = [];
ycorr = [];
for ii = 1:6
    RT.corr = rtmat(ii, choicemat(ii,:)==1); %rtmat(choicemat(:,ii)==1,ii);
    RT.wro = rtmat(ii, choicemat(ii,:)==2); %rtmat(choicemat(:,ii)==2,ii);
    if length(RT.wro) > 0
        ywro(:,ii) = quantile(RT.wro,[.1 .3 .5 .7 .9]);
    else
        ywro(:,ii) = ones(1,5)*nan;
    end
    ycorr(:,ii) = quantile(RT.corr,[.1 .3 .5 .7 .9]);
    Rprop = [length(RT.wro)/(length(RT.corr)+length(RT.wro)), Rprop, length(RT.corr)/(length(RT.corr)+length(RT.wro))];
    % plot([ones(1,5)*length(RT.wro)/(length(RT.corr)+length(RT.wro)) ones(1,5)*length(RT.corr)/(length(RT.corr)+length(RT.wro))], [ywro(:,ii)' ycorr(:,ii)'],'rx');
end
for qi = 1:5
    mask = [2:6, 7:12];
    hq(qi) = plot(Rprop(mask),[ywro(qi,5:-1:1),ycorr(qi,:)]*1000,'x-r');
end
legend([hg(1), hq(1)],'Empirical data','Estimated data');

h.PaperUnits = 'inches';
h.PaperPosition = [0 0 8 5];
%saveas(h,fullfile(out_dir,sprintf('QuantileProbability_BADS.fig')),'fig');
saveas(h,fullfile(outdir,sprintf('Fig5_Addtion_QuantileProbability_BADS.eps')),'epsc2');

%% panel c, acc and RT
cplist = Cohr*100;
h = figure;hold on;
filename = 'Fig5b';
plot(cplist, accr*100, 'xk', 'MarkerSize', mksz/2);
plot(cplist,acc*100,'-k','LineWidth',lwd);
ylim([.5,1]*100);
xlim([0,100]);
ylabel('Accuracy (%)');
xlabel('Input strength (% coh)');
set(gca, 'XScale', 'log');
legend({'Data','Model'},'NumColumns',1,'Location','SouthEast','FontSize',fontsize-5);
legend('boxoff');
savefig(h, filename, outdir, fontsize, aspect10);
% panel c, median RT
h = figure; hold on;
filename = 'Fig5c';
lg1 = plot(cplist, meanrtcr, '.k', 'MarkerSize', mksz);
lg2 = plot(cplist, meanrtc, '-k','LineWidth',lwd);
lg3 = plot(cplist, meanrtwr, 'ok', 'MarkerSize', mksz/3);
lg4 = plot(cplist, meanrtw, '--k','LineWidth',lwd);
xlim([0,100]);
ylabel('Reaction time (s)');
xlabel('Input strength (% coh)');
set(gca, 'XScale', 'log');
lgd = legend([lg3,lg1,lg4,lg2],{'','','Error','Correct'},'NumColumns',2,...
    'Location','SouthWest','FontSize',fontsize-5,'Box','off');
savefig(h, filename, outdir, fontsize, aspect10);

%% panel d, time course
h = figure;
filename = 'Fig5d';
subplot(1,2,1);hold on;
% colvec = flip({[218,166,109]/256,[155 110 139]/256,'#32716d','#af554d','#708d57','#3b5d64'});
colvec = flip({'#e5a042','#923682','#00abda','#d33638','#009d4b','#31337d'});
%colvec = colorpalette;
for ci = 1:6
    %plot((-100:1)/1000, [initialvals(1,1)*ones(1,101) sm_mr1c(6,ci)],'Color',colvec{ci},'LineWidth',lwd);
    lg(ci) = plot(dot_ax/1000, sm_mr1c(:,ci),'Color',colvec{ci},'LineWidth',lwd);
    %plot((-100:1)/1000, [initialvals(1,2)*ones(1,101) sm_mr2c(6,ci)],'Color',colvec{ci},'LineWidth',lwd);
    plot(dot_ax/1000, sm_mr2c(:,ci),'--','Color',colvec{ci},'LineWidth',lwd);
end
ylim([10,70.5]);
ylabel('Firing rate (sp/s)');
xlabel('Time (s)');
xlim([0,.8]);
xticks(0:.2:.8);
xticklabels({'0','.2','.4','.6','.8'});
legend(flip(lg),flip({'0','3.2','6.4','12.8','25.6','51.2'}),'NumColumns',1,...
    'Location','northwest','FontSize',fontsize-5,'Box','off');
savefig(h, filename, outdir, fontsize, aspect9);
subplot(1,2,2);hold on;
plot([0,0],[20,71],'--k');
for ci = 1:6
    plot(sac_ax/1000, sm_mr1cD(:,ci),'Color',colvec{ci},'LineWidth',lwd);
    plot(sac_ax/1000, sm_mr2cD(:,ci),'--','Color',colvec{ci},'LineWidth',lwd);
end
yticks([]);
set(gca,'ycolor',[1 1 1]);
xticks(-.4:.2:.2);
xticklabels({'-.4','-.2','0','.2'});
ylim([10,70.5]);
savefig(h, filename, outdir, fontsize, aspect9);

%% panel e, picked out FR at four places
h = figure;
filename = 'Fig5e';
subplot(2,1,1);hold on;
x = Cohr*100;
y = sm_mr1c(12,:);
plot(x, y,'k.','MarkerSize',mksz);
p = polyfit(x,y,1);
mdl = fitlm(x,y,'linear')
plot(x,p(1)*x+p(2),'k-','LineWidth',lwd);
y = sm_mr2c(12,:);
plot(x, y,'k.','MarkerSize',mksz);
p = polyfit(x,y,1);
mdl = fitlm(x,y,'linear')
plot(x,p(1)*x+p(2),'k-','LineWidth',lwd);
ylim([10,25]);
xlim([-4,55.2]);
yticks([10:5:25]);
xticks([0:10:50]);
xticklabels({});
ylabel('Firing rate (sp/s)');
savefig(h, filename, outdir, fontsize, aspect6);

subplot(2,1,2);hold on;
y = sm_mr1cD(end-17,:);
plot(x, y,'k.','MarkerSize',mksz);
p = polyfit(x,y,1);
mdl = fitlm(x,y,'linear')
plot(x,p(1)*x+p(2),'k-','LineWidth',lwd);
y = sm_mr2cD(end-17,:);
plot(x, y,'k.','MarkerSize',mksz);
p = polyfit(x,y,1);
mdl = fitlm(x,y,'linear')
plot(x,p(1)*x+p(2),'k-','LineWidth',lwd);
ylim([0,60]);
xlim([-4,55.2]);
yticks([0:20:70]);
xticks([0:10:50]);
xlabel('Input strength (% coh)');
ylabel('Firing rate (sp/s)');
savefig(h, filename, outdir, fontsize, aspect6);
