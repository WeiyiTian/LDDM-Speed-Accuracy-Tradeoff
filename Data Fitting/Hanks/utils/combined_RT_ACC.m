function combined_RT_ACC(acc_sim, speed_sim, empirical_data, monkey, version, filename)
%% data loading
out_dir = ".\" + "combined";
new_title = monkey + " " + version;

if ~exist(out_dir, 'dir')
    mkdir(out_dir);
end

acc_simulate_rt = acc_sim.simulate_rt;
acc_simulate_choice = acc_sim.simulate_choice;

speed_simulate_rt = speed_sim.simulate_rt;
speed_simulate_choice = speed_sim.simulate_choice;

acc_empirical_rt = empirical_data.accuracy.rt / 1000;
acc_empirical_choice = empirical_data.accuracy.cor;
acc_empirical_coh = empirical_data.accuracy.coh;

speed_empirical_rt = empirical_data.speed.rt / 1000;
speed_empirical_choice = empirical_data.speed.cor;
speed_empirical_coh = empirical_data.speed.coh;

coh_lst = sort(empirical_data.accuracy_coh);

%% pre-calculation of fitted data
acc_fit_ACC = [];
acc_fit_RT = [];
speed_fit_ACC = [];
speed_fit_RT = [];

for ii = 1:6
    acc_fit_ACC(ii) = sum(acc_simulate_choice(:, ii)==1) / length(acc_simulate_choice(:, ii));
    acc_fit_RT(ii) = mean(acc_simulate_rt(:, ii));

    speed_fit_ACC(ii) = sum(speed_simulate_choice(:, ii)==1) / length(speed_simulate_choice(:, ii));
    speed_fit_RT(ii) = mean(speed_simulate_rt(:, ii));
end

%% pre-calculation of empirical data
acc_emp_ACC = [];
acc_emp_RT = [];
speed_emp_ACC = [];
speed_emp_RT = [];

for ii = 1:6
    acc_tmp_RT = acc_empirical_rt(acc_empirical_coh == coh_lst(ii));
    acc_temp_RT_correct = acc_empirical_rt(acc_empirical_choice == 1 & acc_empirical_coh == coh_lst(ii));
    acc_emp_ACC(ii) = length(acc_temp_RT_correct) / length(acc_tmp_RT);
    acc_emp_RT(ii) = mean(acc_tmp_RT);
    
    speed_tmp_RT = speed_empirical_rt(speed_empirical_coh == coh_lst(ii));
    speed_tmp_RT_correct = speed_empirical_rt(speed_empirical_choice == 1 & speed_empirical_coh == coh_lst(ii));
    speed_emp_ACC(ii) = length(speed_tmp_RT_correct) / length(speed_tmp_RT);
    speed_emp_RT(ii) = mean(speed_tmp_RT);
end

%% visualization
coh_percentage = coh_lst * 100;
h = figure;

subplot(2, 1, 1); hold on;
plot(coh_percentage, acc_fit_ACC*100, 'Color', 'k', 'DisplayName', 'Accuracy');
plot(coh_percentage, acc_emp_ACC*100, '.', 'Color', 'k', 'DisplayName', '');
plot(coh_percentage, speed_fit_ACC*100, 'Color', 'r', 'DisplayName', 'Speed');
plot(coh_percentage, speed_emp_ACC*100, '.', 'Color', 'r', 'DisplayName', '');
ylim([.5, 1] * 100);
xlim([0, 60]);
ylabel('Accuracy (%)');
xticklabels({})
legend('boxoff');
title(new_title);
set_fig(h, 14, [3 5]);

subplot(2, 1, 2); hold on;
plot(coh_percentage, acc_emp_RT, '.', 'Color', 'k', 'DisplayName', '');
plot(coh_percentage, acc_fit_RT, 'Color', 'k', 'DisplayName', '');
plot(coh_percentage, speed_emp_RT, '.', 'Color', 'r', 'DisplayName', '');
plot(coh_percentage, speed_fit_RT, 'Color', 'r', 'DisplayName', '');

y_min = min([acc_emp_RT speed_emp_RT acc_fit_RT speed_fit_RT]) - .1;
y_max = max([acc_emp_RT speed_emp_RT acc_fit_RT speed_fit_RT]) + .1;
ylim([y_min, y_max]);
xlim([0, 60]);
ylabel('Reaction Time (s)');
xlabel('Input Coherence (%)');

legend('NumColumns', 2, 'Box', 'off');
savefigs(h, filename+"_comb_RT_ACC", out_dir, 14, [3 5]);