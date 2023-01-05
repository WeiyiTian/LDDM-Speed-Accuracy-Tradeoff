addpath(genpath('../../'))

dataBhvr = load_data("Empirical Data/behavData_dam.mat");
monkey = 'Monkey D';
version = "Version 2";
condition = "accuracy";
filename = "MonkeyD_accuracy_v2";

alpha = 10.023037;
beta = 1.346402;
sigma = 22.771158;
S = 747.633308;
tauR = 0.087281;
tauG = 0.1465;
tauD = 0.014338;
params = [alpha, beta, sigma, S, tauR, tauG, tauD];

QP_plot(params, dataBhvr, monkey, condition, version, filename);