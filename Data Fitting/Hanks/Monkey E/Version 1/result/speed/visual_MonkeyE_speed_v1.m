addpath(genpath('../../'))

dataBhvr = load_data("Empirical Data/behavData_eli.mat");
monkey = 'Monkey E';
version = "Version 1";
condition = "speed";
filename = "MonkeyE_speed_v1";

alpha = 11.113324;
beta = 1.088494;
sigma = 24.168393;
S = 114.621915;
tauR = 0.022982;
tauG = 0.102119;
tauD = 0.001963;
params = [alpha, beta, sigma, S, tauR, tauG, tauD];

QP_plot(params, dataBhvr, monkey, condition, version, filename);