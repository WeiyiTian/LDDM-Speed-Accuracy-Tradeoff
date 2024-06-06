addpath('../../../utils')
addpath('../../../Empirical Data')

dataBhvr = load_data("behavData_dam.mat");
acc_simulate_data = load("accuracy/simulate_MonkeyD_accuracy_tst");
speed_simulate_data = load("speed/simulate_MonkeyD_speed_tst");

monkey = 'Monkey D';
version = "Test";
filename = "tst";

combined_distribution_plot(acc_simulate_data, speed_simulate_data, ...
    dataBhvr, monkey, version, filename)