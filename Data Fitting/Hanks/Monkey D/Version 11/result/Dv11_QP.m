addpath('../../../utils')
addpath('../../../Empirical Data')

dataBhvr = load_data("behavData_dam.mat");
monkey = 'Monkey D';
version = "Version 11";

%% params
acc_alpha = 6.449021;
acc_beta = 1.103709;
speed_alpha = 0.000738;
speed_beta = 1.411234;
sigma = 6.531205;
S = 302.153151;
tauR = 0.050009;
tauG = 0.0204;
tauD = 0.075077;

%% accuracy
acc_filename = "MonkeyD_accuracy_v11";

acc_params = [acc_alpha, acc_beta, sigma, S, tauR, tauG, tauD];

QP_plot_Rndinput(acc_params, dataBhvr, monkey, "accuracy", version, acc_filename);

%% speed
speed_filename = "MonkeyD_speed_v11";

speed_params = [speed_alpha, speed_beta, sigma, S, tauR, tauG, tauD];

QP_plot_Rndinput(speed_params, dataBhvr, monkey, "speed", version, speed_filename);