addpath('../../../utils')
addpath('../../../Empirical Data')

dataBhvr = load_data("behavData_eli.mat");
monkey = 'Monkey E';
version = "Version 6";

%% params
acc_alpha = 23.651141;
acc_beta = 1.056569;
speed_alpha = 39.541186;
speed_beta = 1.016159;
sigma = 8.098061;
S = 292.056008;
tauR = 0.021871;
tauG = 0.164919;
tauD = 0.126078;

%% accuracy
acc_filename = "MonkeyE_accuracy_v6";

acc_params = [acc_alpha, acc_beta, sigma, S, tauR, tauG, tauD];

QP_plot_Rndinput(acc_params, dataBhvr, monkey, "accuracy", version, acc_filename);

%% speed
speed_filename = "MonkeyE_speed_v6";

speed_params = [speed_alpha, speed_beta, sigma, S, tauR, tauG, tauD];

QP_plot_Rndinput(speed_params, dataBhvr, monkey, "speed", version, speed_filename);