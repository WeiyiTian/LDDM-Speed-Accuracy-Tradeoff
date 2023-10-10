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
% avec = 10.^[-1:.01:1.9];
avec = 0.5:.5:80;
% bvec = linspace(0,4,401);
bvec = 0.01:.01:2;
[Amat,Bmat] = meshgrid(avec,bvec);
scale = params(2);
tauR = params(3);
tauG = params(4);
tauI = params(5);
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
cp = .128;
sgm = .3;

effN = [];
SK = [];
KT = [];
M = [];
SD = [];
ACC = [];
name = sprintf('Amat%i_Bmat%i_sgm%2.1f_tau%1.2f_%1.2f_%1.2f_%i',numel(avec),numel(bvec),params([1,3:5]),sims*Npiles);
if ~exist(fullfile(out_dir,sprintf('PlotData_%s.mat',name)),'file')
    for pi = 1:Npiles
        for bi = 1:Nbs
            startp = ((bi-1)*Bsec + 1);
            endp = min((bi*Bsec), Bdim);
            bbvec = bvec(startp:endp);
            [amat,bmat] = meshgrid(avec,bbvec);
            scale = scale * ones(size(amat));
            %scale = 2*1*eqlb.^2 + (1-amat).*eqlb; % a = 1-(scale/eqlb - 2*eqlb)
            Vinput.V1 = (1+cp)*scale;
            Vinput.V2 = (1-cp)*scale;
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
            ACC(bi,ai) = mean(2-choicemat(bi,ai,:),'omitnan');
            effN(bi,ai) = numel(simdata);
            SK(bi,ai) = skewness(simdata);
            KT(bi,ai) = kurtosis(simdata);
            M(bi,ai) = mean(simdata);
            SD(bi,ai) = std(simdata);
            PrcSK(bi,ai) = (M(bi,ai) - median(simdata))/SD(bi,ai);
        end
    end

    save(fullfile(out_dir,sprintf('PlotData_%s.mat',name)),...
                'rtmat','choicemat','-v7.3');
    save(fullfile(out_dir,sprintf('CalculatedData_%s.mat',name)),...
                'ACC','effN','SK','PrcSK','KT','M','SD');
    
else
    load(fullfile(out_dir,sprintf('PlotData_%s.mat',name)));
    load(fullfile(out_dir,sprintf('CalculatedData_%s.mat',name)));
end

%% visualization
h = figure;
font_size = 14;

subplot(2,3,1); hold on;
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
set_fig(h, font_size, [8 12]);

subplot(2,3,2); hold on;
s=surf(Bmat,Amat,KT);
s.EdgeColor = 'none';
%set(gca,'YScale','log');
xlim([0,1.8]);
title('Kurtosis');
view(0,90);
c = colorbar;
% ylabel(c, 'Kurtosis');
xlabel('\beta');
ylabel('\alpha');
set_fig(h, font_size, [8 12]);

subplot(2,3,4); hold on;
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
set_fig(h, font_size, [8 12]);

subplot(2,3,5); hold on;
s=surf(Bmat,Amat,SD);
s.EdgeColor = 'none';
%set(gca,'YScale','log');
xlim([0,1.8]);
title('Deviance');
view(0,90);
c = colorbar;
% ylabel(c, 'Deviance');
xlabel('\beta');
ylabel('\alpha');
set_fig(h, font_size, [8 12]);

subplot(2,3,6); hold on;
s=surf(Bmat,Amat,ACC);
s.EdgeColor = 'none';
%set(gca,'YScale','log');
xlim([0,1.8]);
title('Accuracy');
view(0,90);
c = colorbar;
% ylabel(c, 'Accuracy');
xlabel('\beta');
ylabel('\alpha');

savefigs(h, filename+"_heatmap", out_dir, font_size, [2 10]);