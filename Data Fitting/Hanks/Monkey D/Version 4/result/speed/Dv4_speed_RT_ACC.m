addpath(genpath('../../'))

dataBhvr = load_data("Empirical Data/behavData_dam.mat");
simulate_data = load("simulate_MonkeyD_speed_v4");

monkey = 'Monkey D';
version = "Version 4";
condition = "speed";
filename = "Dv4_speed_visual_RT_ACC";

RT_ACC_plot(simulate_data, dataBhvr, monkey, condition, version, filename)