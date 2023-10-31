addpath('../../../utils')
addpath('../../../Empirical Data')

dataBhvr = load_data("behavData_eli.mat");
monkey = 'Monkey E';
version = "Version 9";

%% params
acc_alpha = 24.855469;
acc_beta = 1.095846;
speed_alpha = 41.146379;
speed_beta = 1.072591;
sigma = 9.417925;
S = 250.68329;
tauR = 0.020028;
tauG = 0.18263;
tauD = 0.168546;

%% accuracy
acc_filename = "MonkeyE_accuracy_v9";

acc_params = [acc_alpha, acc_beta, sigma, S, tauR, tauG, tauD];

QP_plot_Rndinput(acc_params, dataBhvr, monkey, "accuracy", version, acc_filename);

%% speed
speed_filename = "MonkeyE_speed_v9";

speed_params = [speed_alpha, speed_beta, sigma, S, tauR, tauG, tauD];

QP_plot_Rndinput(speed_params, dataBhvr, monkey, "speed", version, speed_filename);