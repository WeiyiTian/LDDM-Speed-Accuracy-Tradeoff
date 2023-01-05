addpath(genpath('../../'))

dataBhvr = load_data("Empirical Data/behavData_dam.mat");
monkey = 'Monkey D';
version = "Version 1";
condition = "speed";
filename = "MonkeyD_speed_v1";

alpha = 33.842539;
beta = 1.821676;
sigma = 35.723187;
S = 2368.22093;
tauR = 0.33628;
tauG = 0.001002;
tauD = 0.226118;
params = [alpha, beta, sigma, S, tauR, tauG, tauD];

QP_plot(params, dataBhvr, monkey, condition, version, filename);