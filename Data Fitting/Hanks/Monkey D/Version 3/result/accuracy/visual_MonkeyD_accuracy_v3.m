addpath(genpath('../../'))

dataBhvr = load_data("Empirical Data/behavData_dam.mat");
monkey = 'Monkey D';
version = "Version 3";
condition = "accuracy";
filename = "MonkeyD_accuracy_v3";

alpha = 0.000057;
beta = 1.484608;
sigma = 20.490942;
S = 929.979004;
tauR = 0.173528;
tauG = 0.123841;
tauD = 0.003046;
params = [alpha, beta, sigma, S, tauR, tauG, tauD];

QP_plot(params, dataBhvr, monkey, condition, version, filename);