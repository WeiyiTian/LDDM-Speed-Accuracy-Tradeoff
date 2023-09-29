addpath('../../../utils')
addpath('../../../Empirical Data')

dataBhvr = load_data("behavData_eli.mat");
monkey = 'Monkey E';
version = "Version 3";

%% params
acc_alpha = 0.000001;
acc_beta = 0.713513;
speed_alpha = 0.000015;
speed_beta = 1.051663;
sigma = 0.999837;
S = 43.513769;
tauR = 0.001;
tauG = 0.00167;
tauD = 0.508641;

%% accuracy
acc_filename = "MonkeyE_accuracy_v3";

acc_params = [acc_alpha, acc_beta, sigma, S, tauR, tauG, tauD];

QP_plot_Rndinput(acc_params, dataBhvr, monkey, "accuracy", version, acc_filename);

%% speed
speed_filename = "MonkeyE_speed_v3";

speed_params = [speed_alpha, speed_beta, sigma, S, tauR, tauG, tauD];

QP_plot_Rndinput(speed_params, dataBhvr, monkey, "speed", version, speed_filename);