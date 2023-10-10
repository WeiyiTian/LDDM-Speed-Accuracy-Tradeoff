addpath('../../../utils')

monkey = 'Monkey D';
version = "Version 8";
filename = "Dv8";

sigma = 5.171322;
S = 443.805901;
tauR = 0.036448;
tauG = 0.009316;
tauD = 0.135328;
params = [sigma, S, tauR, tauG, tauD];

RT_heatmap(params, monkey, version, filename)

%% ness
scale = params(2);
tauR = params(3);
tauG = params(4);
tauI = params(5);
sgmInput = params(1) * scale;

avec = 0.5:.5:80;
% bvec = linspace(0,4,401);
bvec = 0.01:.01:2;
[Amat,Bmat] = meshgrid(avec,bvec);

predur = 0;
presentt = 0; 
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
Tau = [tauR tauG tauI];
sims = 10240;
Npiles = 1;
Bdim = numel(bvec);
Nbs = 20;
Bsec = ceil(Bdim/Nbs);
cp = .128;
sgm = .3;
a_accuracy = params(1)*eye(2);
b_accuracy = params(2)*eye(2);
Tau = [tauR tauG tauI];
Cohr = [0, .032, .064, .128, .256, .0512];

bi=3;
startp = ((bi-1)*Bsec + 1);
endp = min((bi*Bsec), Bdim);
bbvec = bvec(startp:endp);
[amat,bmat] = meshgrid(avec,bbvec);
scale = scale * ones(size(amat));
Vinput = struct();
Vprior = struct();

Vinput.V1 = (1+cp)*scale;
Vinput.V2 = (1-cp)*scale;
Vprior.V1 = scale;
Vprior.V2 = scale;

[rt, choice, ~] = LDDM_GPU_ABMtrx(Vprior, Vinput, w, amat, bmat,...
                sgm, sgmInput, Tau, predur, dur, dt, presentt, triggert, thresh, initialvals, stimdur, stoprule, sims);