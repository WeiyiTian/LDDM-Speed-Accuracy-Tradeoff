addpath(genpath('../../'))

dataBhvr = load_data("Empirical Data/behavData_dam.mat");
monkey = 'Monkey D';
version = "Version 4";
condition = "accuracy";
filename = "MonkeyD_accuracy_v4";

alpha = 11.172996;
beta = 1.710862;
sigma = 1.998291;
S = 142.085607;
tauR = 0.979158;
tauG = 0.001016;
tauD = 0.001226;
params = [alpha, beta, sigma, S, tauR, tauG, tauD];


QP_plot(params, dataBhvr, monkey, condition, version, filename);