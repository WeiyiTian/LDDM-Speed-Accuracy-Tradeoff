addpath('../../../utils')
addpath('../../../Empirical Data')

dataBhvr = load_data("behavData_eli.mat");
acc_simulate_data = load("accuracy/simulate_MonkeyE_accuracy_tst");
speed_simulate_data = load("speed/simulate_MonkeyE_speed_tst");

monkey = 'Monkey E';
version = "Test";
filename = "tst";

combined_distribution_plot(acc_simulate_data, speed_simulate_data, ...
    dataBhvr, monkey, version, filename)