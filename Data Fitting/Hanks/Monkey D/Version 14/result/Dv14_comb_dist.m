addpath('../../../utils')
addpath('../../../Empirical Data')

dataBhvr = load_data("behavData_dam.mat");
acc_simulate_data = load("accuracy/simulate_MonkeyD_accuracy_v14");
speed_simulate_data = load("speed/simulate_MonkeyD_speed_v14");

monkey = 'Monkey D';
version = "Version 14";
filename = "Dv14";

combined_distribution_plot(acc_simulate_data, speed_simulate_data, ...
    dataBhvr, monkey, version, filename)