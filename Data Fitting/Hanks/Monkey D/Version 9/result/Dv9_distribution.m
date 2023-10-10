addpath('../../../utils')
addpath('../../../Empirical Data')

dataBhvr = load_data("behavData_dam.mat");
acc_simulate_data = load("accuracy/simulate_MonkeyD_accuracy_v9");
speed_simulate_data = load("speed/simulate_MonkeyD_speed_v9");

monkey = 'Monkey D';
version = "Version 9";

%% accuracy
acc_filename = "Dv9_accuracy";
distribution_plot(acc_simulate_data, dataBhvr, monkey, "accuracy", version, acc_filename)

%% speed
speed_filename = "Dv9_speed";
distribution_plot(speed_simulate_data, dataBhvr, monkey, "speed", version, speed_filename)