function RT_heatmap(params, monkey, version, filename)
%% set up
out_dir = ".\" + "combined";
new_title = monkey + " " + version;

if ~exist(out_dir, 'dir')
    mkdir(out_dir);
end

randseed = 24356545;
rng(randseed);
%% parameters
avec = 0.5:.5:80;
bvec = 0.01:.01:2;
[Amat,Bmat] = meshgrid(avec,bvec);

scale = params(2);
amp = params(3);
gamma = params(4);
Cmax = amp / .512 ^ gamma;
tauR = params(5);
tauG = params(6);
tauI = params(7);
sgmInput = params(1) * scale;

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
cp = .256;
sgm = .3;

effN = [];
SK = [];
KT = [];
M = [];
SD = [];
ACC = [];

name = filename;
if ~exist(fullfile(out_dir,sprintf('PlotData_%s.mat',name)),'file')
    for pi = 1:Npiles
        for bi = 1:Nbs
            startp = ((bi-1)*Bsec + 1);
            endp = min((bi*Bsec), Bdim);
            bbvec = bvec(startp:endp);
            [amat,bmat] = meshgrid(avec,bbvec);
            scale = 2*1*eqlb.^2 + (1-amat).*eqlb; % a = 1-(scale/eqlb - 2*eqlb)
            Vinput.V1 = (1 + Cmax * cp .^ gamma) * scale;
            Vinput.V2 = (1 - Cmax * cp .^ gamma) * scale;
            Vprior.V1 = scale;
            Vprior.V2 = scale;
            tic;
            [rt, choice, ~] = LDDM_GPU_ABMtrx(Vprior, Vinput, w, amat, bmat,...
                sgm, sgmInput, Tau, predur, dur, dt, presentt, triggert, thresh, initialvals, stimdur, stoprule, sims);
            toc;
            rtmat(startp:endp,:,(sims*(pi-1)+1):(sims*pi)) = rt;
            choicemat(startp:endp,:,(sims*(pi-1)+1):(sims*pi)) = choice;
        end
    end

    for ai = 1:numel(avec)
        for bi = 1:numel(bvec)
            % mode: mean, deviance, skewness, turkosis
            simdata = rtmat(bi,ai,~isnan(choicemat(bi,ai,:)));
            SK(bi,ai) = skewness(simdata);
            M(bi,ai) = mean(simdata);
        end
    end

    save(fullfile(out_dir,sprintf('PlotData_%s.mat',name)),...
                'rtmat','choicemat', '-v7.3');
    save(fullfile(out_dir,sprintf('CalculatedData_%s.mat',name)),...
                'SK','M');
    
else
    load(fullfile(out_dir,sprintf('PlotData_%s.mat',name)));
    load(fullfile(out_dir,sprintf('CalculatedData_%s.mat',name)));
end

%% visualization
h = figure;
font_size = 14;

subplot(2,1,1); hold on;
s=surf(Bmat,Amat,SK);
s.EdgeColor = 'none';
%set(gca,'YScale','log');
xlim([0,1.8]);
title('Skewness');
view(0,90);
c = colorbar;
% ylabel(c, 'Skewness');
xlabel('\beta');
ylabel('\alpha');
set_fig(h, font_size, [5 10]);

subplot(2,1,2); hold on;
s=surf(Bmat,Amat,M);
s.EdgeColor = 'none';
%set(gca,'YScale','log');
xlim([0,1.8]);
title('Mean');
view(0,90);
c = colorbar;
% ylabel(c, 'Mean');
xlabel('\beta');
ylabel('\alpha');
set_fig(h, font_size, [5 10]);

savefigs(h, filename+"_heatmap", out_dir, font_size, [5 10]);