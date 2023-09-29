addpath('../../../utils')
addpath('../../../Empirical Data')

dataBhvr = load_data("behavData_eli.mat");
acc_simulate_data = load("accuracy/simulate_MonkeyE_accuracy_v3");
speed_simulate_data = load("speed/simulate_MonkeyE_speed_v3");

monkey = 'Monkey E';
version = "Version 3";

%% acuuracy
acc_filename = "MonkeyE_accuracy_v3";
RT_ACC_plot(acc_simulate_data, dataBhvr, monkey, "accuracy", version, acc_filename)

%% speed
speed_filename = "MonkeyE_speed_v3";
RT_ACC_plot(acc_simulate_data, dataBhvr, monkey, "speed", version, speed_filename)