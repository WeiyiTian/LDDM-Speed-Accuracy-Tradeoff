addpath('../../../utils')
addpath('../../../Empirical Data')

dataBhvr = load_data("behavData_dam.mat");
monkey = 'Monkey D';
version = "Version 8";

%% params
acc_alpha = 15.855082;
acc_beta = 1.109831;
speed_alpha = 0.014097;
speed_beta = 1.475015;
sigma = 5.171322;
S = 443.805901;
tauR = 0.036448;
tauG = 0.009316;
tauD = 0.135328;

%% accuracy
acc_filename = "MonkeyD_accuracy_v8";

acc_params = [acc_alpha, acc_beta, sigma, S, tauR, tauG, tauD];

QP_plot_Rndinput(acc_params, dataBhvr, monkey, "accuracy", version, acc_filename);

%% speed
speed_filename = "MonkeyD_speed_v8";

speed_params = [speed_alpha, speed_beta, sigma, S, tauR, tauG, tauD];

QP_plot_Rndinput(speed_params, dataBhvr, monkey, "speed", version, speed_filename);