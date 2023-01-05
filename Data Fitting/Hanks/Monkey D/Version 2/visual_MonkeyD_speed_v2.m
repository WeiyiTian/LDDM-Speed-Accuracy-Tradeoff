addpath(genpath('../../'))

dataBhvr = load_data("Empirical Data/behavData_dam.mat");
monkey = 'Monkey D';
version = "Version 2";
condition = "speed";
filename = "MonkeyD_speed_v2";

alpha = 0.000229;
beta = 1.774878;
sigma = 37.742538;
S = 247.933594;
tauR = 0.014851;
tauG = 0.10153;
tauD = 0.031509;
params = [alpha, beta, sigma, S, tauR, tauG, tauD];

QP_plot(params, dataBhvr, monkey, condition, version, filename);