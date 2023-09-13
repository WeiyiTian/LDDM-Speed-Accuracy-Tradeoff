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