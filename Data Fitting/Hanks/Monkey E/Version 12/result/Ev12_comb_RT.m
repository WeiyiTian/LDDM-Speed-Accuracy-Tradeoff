addpath('../../../utils')
addpath('../../../Empirical Data')

dataBhvr = load_data("behavData_eli.mat");
acc_simulate_data = load("accuracy/simulate_MonkeyE_accuracy_v12");
speed_simulate_data = load("speed/simulate_MonkeyE_speed_v12");

monkey = 'Monkey E';
version = "Version 12";
filename = "Ev12";

combined_RT(acc_simulate_data, speed_simulate_data, ...
    dataBhvr, monkey, version, filename)