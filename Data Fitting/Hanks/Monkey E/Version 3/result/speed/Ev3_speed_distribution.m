addpath(genpath('../../'))

dataBhvr = load_data("Empirical Data/behavData_eli.mat");
simulate_data = load("simulate_MonkeyE_speed_v3");

monkey = 'Monkey E';
version = "Version 3";
condition = "speed";
filename = "Ev3_acc_visual_dist";

distribution_plot(simulate_data, dataBhvr, condition, filename)