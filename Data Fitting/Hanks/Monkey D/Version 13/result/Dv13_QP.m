addpath('../../../utils')
addpath('../../../Empirical Data')

dataBhvr = load_data("behavData_dam.mat");
monkey = 'Monkey D';
version = "Version 13";

%% params
% acc_alpha = 39.18457;
% acc_beta = 1.673437;
% speed_alpha = 39.873047;
% speed_beta = 1.342578;
% sgmInput = 8.466797;
% S = 1653.375;
% gamma = 1.564209;
% % Cmax = 0.419092;
% Amp = .5;
% tauR = 0.046061;
% tauG = 0.03042;
% tauD = 0.095657;

acc_alpha = 4.795599;
acc_beta = 1.043396;
speed_alpha = 0.003323;
speed_beta = 1.34879;
sgmInput = 7.145327;
S = 188.231418;
amp = .41;
gamma = 0.5;
tauR = 0.033147;
tauG = 0.026422;
tauD = 0.058274;

%% accuracy
acc_filename = "MonkeyD_accuracy_v13";

acc_params = [acc_alpha, acc_beta, sgmInput, S, gamma, amp, tauR, tauG, tauD];

QP_plot_Rndinput(acc_params, dataBhvr, monkey, "accuracy", version, acc_filename);

%% speed
speed_filename = "MonkeyD_speed_v13";

speed_params = [speed_alpha, speed_beta, sgmInput, S, gamma, amp, tauR, tauG, tauD];

QP_plot_Rndinput(speed_params, dataBhvr, monkey, "speed", version, speed_filename);