addpath('../../../utils')
addpath('../../../Empirical Data')

dataBhvr = load_data("behavData_dam.mat");
acc_simulate_data = load("accuracy/simulate_MonkeyD_accuracy_v6");
speed_simulate_data = load("speed/simulate_MonkeyD_speed_v6");

monkey = 'Monkey D';
version = "Version 6";

%% acuuracy
acc_filename = "MonkeyD_accuracy_v6";
RT_ACC_plot(acc_simulate_data, dataBhvr, monkey, "accuracy", version, acc_filename)

%% speed
speed_filename = "MonkeyD_speed_v6";
RT_ACC_plot(speed_simulate_data, dataBhvr, monkey, "speed", version, speed_filename)