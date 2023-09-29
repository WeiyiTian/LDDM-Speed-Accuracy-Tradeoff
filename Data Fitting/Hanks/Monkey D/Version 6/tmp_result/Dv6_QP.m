addpath('../../../utils')
addpath('../../../Empirical Data')

dataBhvr = load_data("behavData_dam.mat");
monkey = 'Monkey D';
version = "Version 6";

%% params
acc_alpha = 7.061902;
acc_beta = 0.512764;
speed_alpha = 15.994436;
speed_beta = 0.693072;
sigma = 1.999034;
S = 386.655701;
tauR = 0.001553;
tauG = 0.131919;
tauD = 0.080181;

%% accuracy
acc_filename = "MonkeyD_accuracy_v6";

acc_params = [acc_alpha, acc_beta, sigma, S, tauR, tauG, tauD];

QP_plot_Rndinput(acc_params, dataBhvr, monkey, "accuracy", version, acc_filename);

%% speed
speed_filename = "MonkeyD_speed_v6";

speed_params = [speed_alpha, speed_beta, sigma, S, tauR, tauG, tauD];

QP_plot_Rndinput(speed_params, dataBhvr, monkey, "speed", version, speed_filename);