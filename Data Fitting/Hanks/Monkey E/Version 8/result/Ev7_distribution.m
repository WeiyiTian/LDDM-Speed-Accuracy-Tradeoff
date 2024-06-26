addpath('../../../utils')
addpath('../../../Empirical Data')

dataBhvr = load_data("behavData_eli.mat");
acc_simulate_data = load("accuracy/simulate_MonkeyE_accuracy_v8");
speed_simulate_data = load("speed/simulate_MonkeyE_speed_v8");

monkey = 'Monkey E';
version = "Version 8";

%% accuracy
acc_filename = "Ev8_accuracy";
distribution_plot(acc_simulate_data, dataBhvr, monkey, "accuracy", version, acc_filename)

%% speed
speed_filename = "Ev8_speed";
distribution_plot(speed_simulate_data, dataBhvr, monkey, "speed", version, speed_filename)