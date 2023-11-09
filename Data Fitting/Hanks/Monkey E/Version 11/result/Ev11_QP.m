addpath('../../../utils')
addpath('../../../Empirical Data')

dataBhvr = load_data("behavData_eli.mat");
monkey = 'Monkey E';
version = "Version 11";

%% params
acc_alpha = 12.231445;
acc_beta = 1.342578;
speed_alpha = 41.784668;
speed_beta = 1.212891;
sgmInput = 5.463867;
S = 217.5;
gamma = 0.724121;
Cmax = 0.458936;
tauR = 0.067888;
tauG = 0.081818;
tauD = 0.197986;

%% accuracy
acc_filename = "MonkeyE_accuracy_v11";

acc_params = [acc_alpha, acc_beta, sgmInput, S, gamma, Cmax, tauR, tauG, tauD];

QP_plot_Rndinput(acc_params, dataBhvr, monkey, "accuracy", version, acc_filename);

%% speed
speed_filename = "MonkeyE_speed_v11";

speed_params = [speed_alpha, speed_beta, sgmInput, S, gamma, Cmax, tauR, tauG, tauD];

QP_plot_Rndinput(speed_params, dataBhvr, monkey, "speed", version, speed_filename);