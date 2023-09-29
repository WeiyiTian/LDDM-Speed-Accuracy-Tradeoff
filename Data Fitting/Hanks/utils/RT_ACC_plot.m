function RT_ACC_plot(simulate_data, empirical_data, monkey, condition, version, filename)
%% data loading
simulate_rt = simulate_data.simulate_rt;
simulate_choice = simulate_data.simulate_choice;

if condition == "accuracy"
    empirical_rt = empirical_data.accuracy.rt / 1000;
    empirical_coh = empirical_data.accuracy.coh;
    empirical_choice = empirical_data.accuracy.cor;
    coh_lst = sort(empirical_data.accuracy_coh);
    plot_color = 'k';
elseif condition == "speed"
    empirical_rt = empirical_data.speed.rt / 1000;
    empirical_coh = empirical_data.speed.coh;
    empirical_choice = empirical_data.speed.cor;
    coh_lst = sort(empirical_data.speed_coh);
    plot_color = 'r';
end

%% pre-calculation of fitted data
fit_ACC = [];
fit_RT_correct = [];
fit_RT_wrong = [];

for ii = 1:6
    fit_ACC(ii) = sum(simulate_choice(:, ii)==1) / (length(simulate_choice(:, ii)));
    fit_RT_correct(ii) = mean(simulate_rt(simulate_choice(:, ii)==1, ii));
    fit_RT_wrong(ii) = mean(simulate_rt(simulate_choice(:, ii)==2, ii));
end

%% pre-calculation of empirical data
emp_ACC = [];
emp_RT_correct = [];
emp_RT_wrong = [];

for ii = 1:6
    tmp_rt = empirical_rt(empirical_coh == coh_lst(ii));
    tmp_rt_correct = empirical_rt(empirical_choice == 1 & empirical_coh == coh_lst(ii));
    tmp_rt_wrong = empirical_rt(empirical_choice == 0 & empirical_coh == coh_lst(ii));

    emp_ACC(ii) = length(tmp_rt_correct) / length(tmp_rt);
    emp_RT_correct(ii) = mean(tmp_rt_correct);
    emp_RT_wrong(ii) = mean(tmp_rt_wrong);
end

%% visualization
out_dir = '.\' + condition;
new_title = monkey + " " + condition + " " + version;

coh_percentage = coh_lst * 100;
coh_percentage(1) = 1;
h = figure;

subplot(2, 1, 1); hold on;
plot(coh_percentage, fit_ACC*100, '-', 'Color', plot_color, 'DisplayName', 'Model');
plot(coh_percentage, emp_ACC*100, 'x', 'Color', plot_color, 'DisplayName', 'Data');
ylim([.5, 1] * 100);
xlim([0, 100]);
ylabel('Accuracy (%)');
xticklabels({})
set(gca, 'XScale', 'log');
legend('boxoff');
title(new_title);
set_fig(h, 15, [3 5]);

subplot(2, 1, 2); hold on;
plot(coh_percentage, emp_RT_correct, '.', 'Color', plot_color, 'DisplayName', '');
plot(coh_percentage, emp_RT_wrong, 'o', 'Color', plot_color, 'DisplayName', '');
plot(coh_percentage, fit_RT_correct, 'Color', plot_color, 'DisplayName', 'Correct');
plot(coh_percentage, fit_RT_wrong, 'LineStyle', '--', 'Color', plot_color, 'DisplayName', 'Error');

y_min = min([emp_RT_wrong emp_RT_correct fit_RT_wrong fit_RT_correct]) - .1;
y_max = max([emp_RT_wrong emp_RT_correct fit_RT_wrong fit_RT_correct]) + .1;
ylim([y_min, y_max]);
xlim([0, 100]);
ylabel('Reaction Time (s)');
xlabel('Input Coherence (%)');
set(gca, 'XScale', 'log');
legend('NumColumns', 2, 'Box', 'off');
savefigs(h, filename+"_RT_ACC", out_dir, 14, [3 5]);