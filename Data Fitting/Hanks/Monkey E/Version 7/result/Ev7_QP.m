addpath('../../../utils')
addpath('../../../Empirical Data')

dataBhvr = load_data("behavData_eli.mat");
monkey = 'Monkey E';
version = "Version 7";

%% params
acc_alpha = 31.131484;
acc_beta = 1.094403;
speed_alpha = 45.529097;
speed_beta = 1.061746;
sigma = 14;% 7.861514;
S = 265.231773;
tauR = 0.01836;
tauG = 0.209793;
tauD = 0.186693;

%% accuracy
acc_filename = "MonkeyE_accuracy_v7";

acc_params = [acc_alpha, acc_beta, sigma, S, tauR, tauG, tauD];

QP_plot_Rndinput(acc_params, dataBhvr, monkey, "accuracy", version, acc_filename);

%% speed
speed_filename = "MonkeyE_speed_v7";

speed_params = [speed_alpha, speed_beta, sigma, S, tauR, tauG, tauD];

QP_plot_Rndinput(speed_params, dataBhvr, monkey, "speed", version, speed_filename);