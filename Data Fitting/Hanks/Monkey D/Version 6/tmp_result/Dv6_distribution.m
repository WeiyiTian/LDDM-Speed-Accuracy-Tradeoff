addpath('../../../utils')
addpath('../../../Empirical Data')

dataBhvr = load_data("behavData_dam.mat");
acc_simulate_data = load("accuracy/simulate_MonkeyD_accuracy_v6");
speed_simulate_data = load("speed/simulate_MonkeyD_speed_v6");

monkey = 'Monkey D';
version = "Version 6";

%% accuracy
acc_filename = "Dv6_accuracy";
distribution_plot(acc_simulate_data, dataBhvr, monkey, "accuracy", version, acc_filename)

%% speed
speed_filename = "Dv6_speed";
distribution_plot(speed_simulate_data, dataBhvr, monkey, "speed", version, speed_filename)