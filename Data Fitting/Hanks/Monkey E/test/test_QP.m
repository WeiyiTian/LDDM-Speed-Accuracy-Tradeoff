addpath('../../../utils')
addpath('../../../Empirical Data')

dataBhvr = load_data("behavData_eli.mat");
monkey = 'Monkey E';
version = "test";

%% params
acc_alpha = 0.077200;
acc_beta = 1.526299;
speed_alpha = 40.271380;
speed_beta = 1.422431;
sgmInput = 13.207987;
S = 487.001085;
amp = 0.763046;
gamma = 0.785960;
tauR = 0.072108;
tauG = 0.087336;
tauD = 0.236019;

%% accuracy
acc_filename = "MonkeyE_accuracy_tst";

acc_params = [acc_alpha, acc_beta, sgmInput, S, gamma, amp, tauR, tauG, tauD];

QP_plot_Rndinput(acc_params, dataBhvr, monkey, "accuracy", version, acc_filename);

%% speed
speed_filename = "MonkeyE_speed_tst";

speed_params = [speed_alpha, speed_beta, sgmInput, S, gamma, amp, tauR, tauG, tauD];

QP_plot_Rndinput(speed_params, dataBhvr, monkey, "speed", version, speed_filename);