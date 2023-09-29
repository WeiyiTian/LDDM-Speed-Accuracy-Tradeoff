addpath(genpath('../../../../'))

dataBhvr = load_data("Empirical Data/behavData_eli.mat");
monkey = 'Monkey E';
version = "Version 3";
condition = "accuracy";
filename = "MonkeyE_accuracy_v3";

alpha = 0.000001;
beta = 0.713513;
sigma = 0.999837;
S = 43.513769;
tauR = 0.001;
tauG = 0.00167;
tauD = 0.508641;
params = [alpha, beta, sigma, S, tauR, tauG, tauD];

QP_plot_Rndinput(params, dataBhvr, monkey, condition, version, filename);