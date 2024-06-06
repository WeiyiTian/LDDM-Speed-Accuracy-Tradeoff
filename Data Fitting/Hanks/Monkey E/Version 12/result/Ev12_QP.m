addpath('../../../utils')
addpath('../../../Empirical Data')

dataBhvr = load_data("behavData_eli.mat");
monkey = 'Monkey E';
version = "Version 12";

%% params
acc_alpha = 14.159229;
acc_beta = 1.165233;
speed_alpha = 36.361776;
speed_beta = 1.093541;
sgmInput = 11.875469;
S = 309.729124;
amp = 0.776279;
gamma = 0.698394;
tauR = 0.035021;
tauG = 0.132645;
tauD = 0.131028;

%% accuracy
acc_filename = "MonkeyE_accuracy_v12";

acc_params = [acc_alpha, acc_beta, sgmInput, S, gamma, amp, tauR, tauG, tauD];

QP_plot_Rndinput(acc_params, dataBhvr, monkey, "accuracy", version, acc_filename);

%% speed
speed_filename = "MonkeyE_speed_v12";

speed_params = [speed_alpha, speed_beta, sgmInput, S, gamma, amp, tauR, tauG, tauD];

QP_plot_Rndinput(speed_params, dataBhvr, monkey, "speed", version, speed_filename);