addpath('../../../utils')
addpath('../../../Empirical Data')

dataBhvr = load_data("behavData_dam.mat");
monkey = 'Monkey D';
version = "Version 9";

%% params
acc_alpha = 19.942144;
acc_beta = 1.147256;
speed_alpha = 0.000052;
speed_beta = 1.601794;
sigma = 5.621544;
S = 444.654483;
tauR = 0.040878;
tauG = 0.01;
tauD = 0.153047;

%% accuracy
acc_filename = "MonkeyD_accuracy_v9";

acc_params = [acc_alpha, acc_beta, sigma, S, tauR, tauG, tauD];

QP_plot_Rndinput(acc_params, dataBhvr, monkey, "accuracy", version, acc_filename);

%% speed
speed_filename = "MonkeyD_speed_v9";

speed_params = [speed_alpha, speed_beta, sigma, S, tauR, tauG, tauD];

QP_plot_Rndinput(speed_params, dataBhvr, monkey, "speed", version, speed_filename);