addpath('../../../utils')
addpath('../../../Empirical Data')

dataBhvr = load_data("behavData_dam.mat");
acc_simulate_data = load("accuracy/simulate_MonkeyD_accuracy_v13");
speed_simulate_data = load("speed/simulate_MonkeyD_speed_v13");

monkey = 'Monkey D';
version = "Version 13";
filename = "Dv13";

combined_RT_ACC(acc_simulate_data, speed_simulate_data, ...
    dataBhvr, monkey, version, filename)