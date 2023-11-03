addpath('../../../utils')
addpath('../../../Empirical Data')

dataBhvr = load_data("behavData_dam.mat");
monkey = 'Monkey D';
version = "Version 10";

%% params
acc_alpha = 0.641671;
acc_beta = 1.501463;
speed_alpha = 51.402631;
speed_beta = 0.906941;
sgm = 25.608576;
sgmInput =  0.010343;
S = 1353.319413;
tauR = 0.191398;
tauG = 0.141969;
tauD = 0.023299;

%test
% acc_alpha = 4.795599;
% acc_beta = 1.143396;
% speed_alpha = 0.003323;
% speed_beta = 1.54879;
% sigma = 8.645327;
% S = 188.231418;
% tauR = 0.083147;
% tauG = 0.056422;
% tauD = 0.018274;
%% accuracy
acc_filename = "MonkeyD_accuracy_v10";

acc_params = [acc_alpha, acc_beta, sgm, sgmInput, S, tauR, tauG, tauD];

QP_plot_Rndinput(acc_params, dataBhvr, monkey, "accuracy", version, acc_filename);

%% speed
speed_filename = "MonkeyD_speed_v10";

speed_params = [speed_alpha, speed_beta, sgm, sgmInput S, tauR, tauG, tauD];

QP_plot_Rndinput(speed_params, dataBhvr, monkey, "speed", version, speed_filename);