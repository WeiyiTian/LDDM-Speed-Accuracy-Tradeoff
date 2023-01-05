addpath(genpath('../../'))

dataBhvr = load_data("Empirical Data/behavData_eli.mat");
monkey = 'Monkey E';
version = "Version 1";
condition = "accuracy";
filename = "MonkeyE_accuracy_v1";

alpha = 0.291544;
beta = 1.762371;
sigma = 26.827648;
S = 294.659576;
tauR = 0.022271;
tauG = 0.103922;
tauD = 0.124474;
params = [alpha, beta, sigma, S, tauR, tauG, tauD];

QP_plot(params, dataBhvr, monkey, condition, version, filename);