function [nLL, Chi2, BIC, AIC, simulate_accuracy_rt, simulate_accuracy_choice] = LDDM_fit_accuracy(params, dataBhvr)
% reload Hanks data, processed
accuracy_coh = dataBhvr.accuracy_coh;
empirical_accuracy_qmat = dataBhvr.accuracy_qmat;
accuracy_empirical_num = dataBhvr.accuracy_observe_num;
accuracy_empirical_total = dataBhvr.accuracy_observe_total;

% parameters to fit
a = params(1)*eye(2);
b = params(2)*eye(2);
sgm = params(3);
tauR = params(5);
tauG = params(6);
tauI = params(7);
ndt = .09 + .03; % sec, 90ms after stimuli onset, resort to the saccade side,
% the activities reaches peak 30ms before initiation of saccade, according to Roitman & Shadlen
presentt = 0; % changed for this version to move the fitting begin after the time point of recovery
scale = params(4);

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
% simulation
% fprintf('GPU Simulations %i chains ...\t', sims);
V1 = (1 + Cohr)';
V2 = (1 - Cohr)';
Vinput = [V1, V2]*scale;
Vprior = ones(size(Vinput))*(2*mean(w,'all')*eqlb.^2 + (1-a(1)).*eqlb);
% tic
[simulate_accuracy_rt, simulate_accuracy_choice, ~] = LDDM_GPU(Vprior, Vinput, w, a, b,...
    sgm, Tau, predur, dur, dt, presentt, triggert, thresh, initialvals, stimdur, stoprule, sims);
simulate_accuracy_rt = squeeze(simulate_accuracy_rt)'+ndt;
simulate_accuracy_choice = squeeze(simulate_accuracy_choice)';
% toc;

%% for reaction time by histogram
% QMLE, quantile maximum likelihood estimation
% reference: Heathcote & Australia, and Mewhort, 2002.
% Chi-square, reference: Ratcliff & McKoon, 2007.

% accuracy
accuracy_h = figure;
accuracy_simulate_total = [];
accuracy_estimate_qnum = [];
accuracy_f = [];

for vi = 1: length(accuracy_coh)
    correct_RT = simulate_accuracy_rt(simulate_accuracy_choice(:, vi)==1, vi);
    %wrong_RT = simulate_accuracy_rt(simulate_accuracy_choice(:, vi)==0, vi);
    wrong_RT = simulate_accuracy_rt(simulate_accuracy_choice(:, vi)==2, vi);
    accuracy_simulate_total(vi) = length(simulate_accuracy_rt(:, vi));

    if ~any(isnan(empirical_accuracy_qmat(:, 1, vi)))
        temp = histogram(correct_RT, [0; empirical_accuracy_qmat(:, 1, vi); Inf]);
        accuracy_estimate_qnum(:, 1, vi) = temp.Values;
    else
        accuracy_estimate_qnum(:, 1, vi) = NaN(length(empirical_accuracy_qmat(:, 1, vi))+1, 1);
    end

    if ~any(isnan(empirical_accuracy_qmat(:, 2, vi)))
        temp = histogram(wrong_RT, [0; empirical_accuracy_qmat(:, 2, vi); Inf]);
        accuracy_estimate_qnum(:, 2, vi) = temp.Values;
    else
        accuracy_estimate_qnum(:, 2, vi) = NaN(length(empirical_accuracy_qmat(:, 2, vi))+1, 1);
    end

    accuracy_f(:, :, vi) = log(accuracy_estimate_qnum(:, :, vi) / accuracy_simulate_total(vi));
    accuracy_f(accuracy_f(:, 1, vi)==-Inf, 1, vi) = log(.1/accuracy_simulate_total(vi));
    accuracy_f(accuracy_f(:, 2, vi)==-Inf, 2, vi) = log(.1/accuracy_simulate_total(vi));
    accuracy_empirical_adj = accuracy_empirical_num(:, :, vi) * accuracy_simulate_total(vi) ./ accuracy_empirical_total(vi);
end
close(accuracy_h);

accuracy_LL = sum(accuracy_empirical_num(:) .* accuracy_f(:), 'omitnan');
nLL = -accuracy_LL;

Chi2vec = (accuracy_estimate_qnum - accuracy_empirical_adj) .^ 2 ./ accuracy_estimate_qnum;
Chi2 = sum(Chi2vec(:),'omitnan');

n = sum(~isnan(accuracy_empirical_num(:) .* accuracy_f(:)));
k = numel(params);
BIC = k*log(n) - 2*accuracy_LL;
AIC = 2*k - 2*accuracy_LL;