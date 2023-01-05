addpath(genpath('../../'))

dataBhvr = load_data("Empirical Data/behavData_dam.mat");
monkey = 'Monkey D';
version = "Version 3";
condition = "speed";
filename = "MonkeyD_speed_v3";

alpha = 3.491279;
beta = 1.446276;
sigma = 23.049477;
S = 60.477674;
tauR = 0.006396;
tauG = 0.006256;
tauD = 0.078333;
params = [alpha, beta, sigma, S, tauR, tauG, tauD];

QP_plot(params, dataBhvr, monkey, condition, version, filename);