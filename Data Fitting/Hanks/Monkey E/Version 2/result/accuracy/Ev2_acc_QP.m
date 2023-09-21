addpath(genpath('../../'))

dataBhvr = load_data("Empirical Data/behavData_eli.mat");
monkey = 'Monkey E';
version = "Version 2";
condition = "accuracy";
filename = "MonkeyE_accuracy_v2";

alpha = 9.037483;
beta = 1.717009;
sigma = 1.999669;
S = 86.775616;
tauR = 0.942601;
tauG = 0.001063;
tauD = 0.001003;
params = [alpha, beta, sigma, S, tauR, tauG, tauD];

QP_plot(params, dataBhvr, monkey, condition, version, filename);