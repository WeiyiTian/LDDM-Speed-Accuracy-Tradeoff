function QP_plot_Rndinput(params, dataBhvr, monkey, condition, version, filename)

out_dir = ".\" + condition;
new_title = monkey + " " + condition + " " + version;

if ~exist(out_dir, 'dir')
    mkdir(out_dir);
end

% reload Hanks data, processed
if condition == "accuracy"
    empirical_qmat = dataBhvr.accuracy_qmat;
    empirical_proportion_mat = dataBhvr.accuracy_proportionmat;
elseif condition == "speed"
    empirical_qmat = dataBhvr.speed_qmat;
    empirical_proportion_mat = dataBhvr.speed_proportionmat;
end


% parameters to fit
a = params(1)*eye(2);
b = params(2)*eye(2);
tauR = params(5);
tauG = params(6);
tauI = params(7);
ndt = .09 + .03; % sec, 90ms after stimuli onset, resort to the saccade side,
% the activities reaches peak 30ms before initiation of saccade, according to Roitman & Shadlen
presentt = 0; % changed for this version to move the fitting begin after the time point of recovery
scale = params(4);
sgmInput = params(3)*scale;

% other fixed parameters
% sims = 1024;
deduction = .1;
sims = 1024/deduction;
Cohr = [0 32 64 128 256 512]/1000; % percent of coherence
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
Tau = [tauR tauG tauI];
sgm = .3;

% simulation
% fprintf('GPU Simulations %i chains ...\t', sims);

V1 = [(1 + Cohr)'].^1.5;
V2 = [(1 - Cohr)'].^1.5;
% V1 = (1 + Cohr)';
% V2 = (1 - Cohr)';

Vinput = [V1, V2]*scale;
Vprior = ones(size(Vinput))*(2*mean(w,'all')*eqlb.^2 + (1-a(1)).*eqlb);
% tic
[simulate_rt, simulate_choice, ~] = LDDM_Rndinput_GPU(Vprior, Vinput, w, a, b,...
    sgm, sgmInput, Tau, predur, dur, dt, presentt, triggert, thresh, initialvals, stimdur, stoprule, sims);
simulate_rt = squeeze(simulate_rt)'+ndt;
simulate_choice = squeeze(simulate_choice)';
save(fullfile(out_dir, sprintf('simulate_%s.mat', filename)), 'simulate_rt', 'simulate_choice');
% toc;


% visualization
lwd = 1.0;
mksz = 3;
fontsize = 14;

empirical_y = empirical_qmat;
h = figure; hold on;
x_coords = [];
simulate_qmat = [];

for vi = 1:length(empirical_proportion_mat)
    % empirical data
    x_correct_coords = empirical_proportion_mat(vi) * ones(size(empirical_y(:, 1, vi)));
    x_wrong_coords = (1-empirical_proportion_mat(vi)) * ones(size(empirical_y(:, 2, vi)));
    lg1 = plot(x_correct_coords, empirical_y(:, 1, vi), 'x', 'Color', '#5D9C59', 'MarkerSize', mksz+1, 'LineWidth', lwd);
    lg2 = plot(x_wrong_coords, empirical_y(:, 2, vi), 'x', 'Color', '#FF8787', 'MarkerSize', mksz+1, 'LineWidth', lwd);

    % fitted value
    simulate_RT_corr = simulate_rt(simulate_choice(:, vi) == 1, vi);
    simulate_RT_wro = simulate_rt(simulate_choice(:, vi) == 2, vi);
    simulate_qmat(:, 1, vi) = quantile(simulate_RT_corr, .1:.1:.9);
    simulate_qmat(:, 2, vi) = quantile(simulate_RT_wro, .1:.1:.9);
    x_coords(vi) = numel(simulate_RT_corr) / (numel(simulate_RT_corr) + numel(simulate_RT_wro));
end

x_coords = [flip(1-x_coords), x_coords]';
for qi = 1:size(simulate_qmat, 1)
    plot(x_coords, [squeeze(flip(simulate_qmat(qi, 2, :))); squeeze(simulate_qmat(qi, 1, :))], ...
        'k-o', 'MarkerSize', mksz, 'LineWidth', lwd/2, 'DisplayName', '')
end

legend([lg1, lg2], {'Correct', 'Error'}, 'Box', 'off');
xlim([-.05 1.05]);
title(new_title)
xlabel('Proportion');
ylabel('RT (s)');
savefigs(h, filename+"_QP", out_dir, fontsize, [2.5 2.5]);