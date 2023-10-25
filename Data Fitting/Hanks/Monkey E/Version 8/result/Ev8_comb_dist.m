addpath('../../../utils')
addpath('../../../Empirical Data')

dataBhvr = load_data("behavData_eli.mat");
acc_simulate_data = load("accuracy/simulate_MonkeyE_accuracy_v8");
speed_simulate_data = load("speed/simulate_MonkeyE_speed_v8");

monkey = 'Monkey E';
version = "Version 8";
filename = "Ev8";

combined_distribution_plot(acc_simulate_data, speed_simulate_data, ...
    dataBhvr, monkey, version, filename)