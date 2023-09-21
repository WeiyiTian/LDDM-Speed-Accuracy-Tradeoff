addpath(genpath('../../'))

dataBhvr = load_data("Empirical Data/behavData_dam.mat");
simulate_data = load("simulate_MonkeyD_accuracy_v4");

monkey = 'Monkey D';
version = "Version 4";
condition = "accuracy";
filename = "Dv4_acc_visual_RT_ACC";

RT_ACC_plot(simulate_data, dataBhvr, condition, filename)