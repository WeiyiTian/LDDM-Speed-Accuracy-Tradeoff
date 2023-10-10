addpath('../../../utils')
addpath('../../../Empirical Data')

dataBhvr = load_data("behavData_dam.mat");
acc_simulate_data = load("accuracy/simulate_MonkeyD_accuracy_v9");
speed_simulate_data = load("speed/simulate_MonkeyD_speed_v9");

monkey = 'Monkey D';
version = "Version 9";
filename = "Dv9";

combined_distribution_plot(acc_simulate_data, speed_simulate_data, ...
    dataBhvr, monkey, version, filename)