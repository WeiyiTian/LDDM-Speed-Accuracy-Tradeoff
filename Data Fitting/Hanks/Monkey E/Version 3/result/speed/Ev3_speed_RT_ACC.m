addpath(genpath('../../'))

dataBhvr = load_data("Empirical Data/behavData_eli.mat");
simulate_data = load("simulate_MonkeyE_speed_v3");

monkey = 'Monkey E';
version = "Version 3";
condition = "speed";
filename = "MonkeyE_speed_v3";

RT_ACC_plot(simulate_data, dataBhvr, monkey, condition, version, filename)