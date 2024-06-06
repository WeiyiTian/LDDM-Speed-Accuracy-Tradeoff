function combined_RT(acc_sim, speed_sim, empirical_data, monkey, version, filename)
%% data loading
out_dir = ".\" + "combined";
new_title = monkey + " " + version;

if ~exist(out_dir, 'dir')
    mkdir(out_dir);
end

acc_simulate_rt = acc_sim.simulate_rt;
speed_simulate_rt = speed_sim.simulate_rt;

acc_empirical_rt = empirical_data.accuracy.rt / 1000;
acc_empirical_coh = empirical_data.accuracy.coh;

speed_empirical_rt = empirical_data.speed.rt / 1000;
speed_empirical_coh = empirical_data.speed.coh;

coh_lst = sort(empirical_data.accuracy_coh);

%% pre-calculation of fitted data
acc_fit_RT = [];
speed_fit_RT = [];

for ii = 1:6
    acc_fit_RT(ii) = mean(acc_simulate_rt(:, ii));
    speed_fit_RT(ii) = mean(speed_simulate_rt(:, ii));
end

%% pre-calculation of empirical data
acc_emp_RT = [];
speed_emp_RT = [];

for ii = 1:6
    acc_tmp_RT = acc_empirical_rt(acc_empirical_coh == coh_lst(ii));
    acc_emp_RT(ii) = mean(acc_tmp_RT);
    
    speed_tmp_RT = speed_empirical_rt(speed_empirical_coh == coh_lst(ii));
    speed_emp_RT(ii) = mean(speed_tmp_RT);
end

%% visualization
coh_percentage = coh_lst * 100;
h = figure; hold on;

plot(coh_percentage, acc_emp_RT, '.', 'Color', 'k', 'DisplayName', 'Accuracy');
plot(coh_percentage, acc_fit_RT, 'Color', 'k', 'DisplayName', '');
plot(coh_percentage, speed_emp_RT, '.', 'Color', 'r', 'DisplayName', 'Speed');
plot(coh_percentage, speed_fit_RT, 'Color', 'r', 'DisplayName', '');

y_min = min([acc_emp_RT speed_emp_RT acc_fit_RT speed_fit_RT]) - .05;
y_max = max([acc_emp_RT speed_emp_RT acc_fit_RT speed_fit_RT]) + .05;
ylim([y_min, y_max]);
xlim([-5, 60]);
ylabel('Reaction Time (s)');
xlabel('Motion Strength (% coh)');
title(new_title);

legend('NumColumns', 2, 'Box', 'off');
savefigs(h, filename+"_comb_RT", out_dir, 14, [3 2.5]);