addpath('../../../utils')
addpath('../../../Empirical Data')

dataBhvr = load_data("behavData_dam.mat");
acc_simulate_data = load("accuracy/simulate_MonkeyD_accuracy_v10");
speed_simulate_data = load("speed/simulate_MonkeyD_speed_v10");

monkey = 'Monkey D';
version = "Version 10";
filename = "Dv10";

combined_distribution_plot(acc_simulate_data, speed_simulate_data, ...
    dataBhvr, monkey, version, filename)