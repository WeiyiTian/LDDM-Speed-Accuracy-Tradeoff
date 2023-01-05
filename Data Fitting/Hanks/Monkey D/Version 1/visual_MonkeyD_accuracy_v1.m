addpath(genpath('../../'))

dataBhvr = load_data("Empirical Data/behavData_dam.mat");
monkey = 'Monkey D';
version = "Version 1";
condition = "accuracy";
filename = "MonkeyD_accuracy_v1";

alpha = 34.695025;
beta = 0.978248;
sigma = 16.577909;
S = 350.064641;
tauR = 0.008438;
tauG = 0.112152;
tauD = 0.155874;
params = [alpha, beta, sigma, S, tauR, tauG, tauD];

QP_plot(params, dataBhvr, monkey, condition, version, filename);