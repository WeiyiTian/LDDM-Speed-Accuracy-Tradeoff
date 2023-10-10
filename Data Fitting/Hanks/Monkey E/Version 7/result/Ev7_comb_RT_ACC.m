addpath('../../../utils')
addpath('../../../Empirical Data')

dataBhvr = load_data("behavData_eli.mat");
acc_simulate_data = load("accuracy/simulate_MonkeyE_accuracy_v7");
speed_simulate_data = load("speed/simulate_MonkeyE_speed_v7");

monkey = 'Monkey E';
version = "Version 7";
filename = "Ev7";

combined_RT_ACC(acc_simulate_data, speed_simulate_data, ...
    dataBhvr, monkey, version, filename)