addpath('../../../utils')
addpath('../../../Empirical Data')

dataBhvr = load_data("behavData_eli.mat");
monkey = 'Monkey E';
version = "Version 7";

%% params
acc_alpha = 0;
acc_beta = 1.315471;
speed_alpha = 31.020709;
speed_beta = 1.137552;
sigma = 12.16234;
S = 325.418603;
tauR = 0.036966;
tauG = 0.119684;
tauD = 0.123737;

%% accuracy
acc_filename = "MonkeyE_accuracy_v8";

acc_params = [acc_alpha, acc_beta, sigma, S, tauR, tauG, tauD];

QP_plot_Rndinput(acc_params, dataBhvr, monkey, "accuracy", version, acc_filename);

%% speed
speed_filename = "MonkeyE_speed_v8";

speed_params = [speed_alpha, speed_beta, sigma, S, tauR, tauG, tauD];

QP_plot_Rndinput(speed_params, dataBhvr, monkey, "speed", version, speed_filename);