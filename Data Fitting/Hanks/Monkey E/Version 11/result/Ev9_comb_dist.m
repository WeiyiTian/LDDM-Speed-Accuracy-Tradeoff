addpath('../../../utils')
addpath('../../../Empirical Data')

dataBhvr = load_data("behavData_eli.mat");
acc_simulate_data = load("accuracy/simulate_MonkeyE_accuracy_v9");
speed_simulate_data = load("speed/simulate_MonkeyE_speed_v9");

monkey = 'Monkey E';
version = "Version 9";
filename = "Ev9";

combined_distribution_plot(acc_simulate_data, speed_simulate_data, ...
    dataBhvr, monkey, version, filename)