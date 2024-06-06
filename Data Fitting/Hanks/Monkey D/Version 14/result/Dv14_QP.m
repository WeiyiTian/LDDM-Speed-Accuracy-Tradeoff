addpath('../../../utils')
addpath('../../../Empirical Data')

dataBhvr = load_data("behavData_dam.mat");
monkey = 'Monkey D';
version = "Version 14";

%% params
acc_alpha = 26.318359;
acc_beta = 0.983301;
speed_alpha = 0.454102;
speed_beta = 1.569824;
sgmInput = 8.979492;
S = 306.750000;
amp = 0.895508;
gamma = 0.909521;
tauR = 0.037411;
tauG = 0.011934;
tauD = 0.176436;

%% accuracy
acc_filename = "MonkeyD_accuracy_v14";

acc_params = [acc_alpha, acc_beta, sgmInput, S, gamma, amp, tauR, tauG, tauD];

QP_plot_Rndinput(acc_params, dataBhvr, monkey, "accuracy", version, acc_filename);

%% speed
speed_filename = "MonkeyD_speed_v14";

speed_params = [speed_alpha, speed_beta, sgmInput, S, gamma, amp, tauR, tauG, tauD];

QP_plot_Rndinput(speed_params, dataBhvr, monkey, "speed", version, speed_filename);