function distribution_plot(simulate_data, empirical_data, monkey, condition, version, filename)
%% data loading
out_dir = ".\" + condition;
new_title = monkey + " " + condition + " " + version;

simulate_rt = simulate_data.simulate_rt;
simulate_choice = simulate_data.simulate_choice;

if condition == "accuracy"
    empirical_rt = empirical_data.accuracy.rt / 1000;
    empirical_coh = empirical_data.accuracy.coh;
    empirical_choice = empirical_data.accuracy.cor;
    coh_lst = sort(empirical_data.accuracy_coh);
elseif condition == "speed"
    empirical_rt = empirical_data.speed.rt / 1000;
    empirical_coh = empirical_data.speed.coh;
    empirical_choice = empirical_data.speed.cor;
    coh_lst = sort(empirical_data.speed_coh);
end

rate = [];
emp_max_rt = [];
emp_min_rt = [];
sim_max_rt = [];
sim_min_rt = [];
for ii = 1:6
    emp_max_rt(ii) = max(empirical_rt(empirical_coh == coh_lst(ii)));
    emp_min_rt(ii) = min(empirical_rt(empirical_coh == coh_lst(ii)));
    rate(ii) = length(simulate_rt(:, ii)) / length(empirical_rt(empirical_coh == coh_lst(ii)));
    sim_max_rt(ii) = max(simulate_rt(:, ii));
    sim_min_rt(ii) = min(simulate_rt(:, ii));
end

%% pre-calculation of simulated data
num_bins = 30;

sim_bank_correct = [];
sim_bank_wrong = [];
sim_bin_center = [];

for ii = 1:6
    % empirical data determines the gap size
    gap = (emp_max_rt(ii) - emp_min_rt(ii)) / num_bins;
    bin_edge = [sim_min_rt(ii): gap: (sim_max_rt(ii)+gap)];
    correct_hg = histogram(simulate_rt(simulate_choice(:, ii)==1, ii), 'BinEdges', bin_edge, 'Visible', 0);
    sim_bank_correct{ii} = correct_hg.Values / rate(ii);
    close;
    wrong_hg =  histogram(simulate_rt(simulate_choice(:, ii)==2, ii), 'BinEdges', bin_edge, 'Visible', 0);
    sim_bank_wrong{ii} = wrong_hg.Values / rate(ii);
    close;
    sim_bin_center{ii} = bin_edge(1: end-1) + gap/2;
end

%% pre-calculation of empirical data
emp_bin_center = [];
emp_bank_correct = [];
emp_bank_wrong = [];

for ii = 1:6
    tmp_rt = empirical_rt(empirical_coh == coh_lst(ii));
    tmp_rt_correct = empirical_rt(empirical_choice == 1 & empirical_coh == coh_lst(ii));
    tmp_rt_wrong = empirical_rt(empirical_choice == 0 & empirical_coh == coh_lst(ii));

    tmp_min_rt = min(tmp_rt);
    tmp_max_rt = max(tmp_rt);
    tmp_bins = linspace(tmp_min_rt, tmp_max_rt, num_bins+1);

    tmp_hg = histogram(tmp_rt, 'BinEdges', tmp_bins, 'Visible', 0);
    tmp_bin_center = tmp_hg.BinEdges(1: end-1) + tmp_hg.BinWidth/2;
    emp_bin_center = [emp_bin_center; tmp_bin_center];
    close;

    tmp_bank_correct = histogram(tmp_rt_correct, 'BinEdges', tmp_bins, 'Visible', 0);
    emp_bank_correct = [emp_bank_correct; tmp_bank_correct.Values];
    close;

    tmp_bank_wrong = histogram(tmp_rt_wrong, 'BinEdges', tmp_bins, 'Visible', 0);
    emp_bank_wrong = [emp_bank_wrong; tmp_bank_wrong.Values];
    close;

end

%% RT distribution and fitted line visualization
h = figure;
lwd = 1;
font_size = 8;

y_min = floor(min([-max(emp_bank_wrong(:)), -max(cell2mat(sim_bank_wrong))]) / 50) * 50;
y_max = ceil(max([max(emp_bank_correct(:)), max(cell2mat(sim_bank_correct))]) / 50) * 50;

for ii = 1:6
    subplot(6, 1, ii); hold on;
    plot(sim_bin_center{ii}, sim_bank_correct{ii}, 'LineWidth', lwd, 'Color', '#655DBB', 'DisplayName', '');
    plot(sim_bin_center{ii}, -sim_bank_wrong{ii}, 'LineWidth', lwd, 'Color', '#E96479', 'DisplayName', '');
    bar(emp_bin_center(ii, :), emp_bank_correct(ii, :), 'FaceColor', '#BFACE2', ...
        'BarWidth', 1, 'FaceAlpha', .7, 'EdgeAlpha', 0, 'DisplayName', 'Correct');
    bar(emp_bin_center(ii, :), -emp_bank_wrong(ii, :), 'FaceColor', '#FFACAC', ...
        'BarWidth', 1, 'FaceAlpha', .7, 'EdgeAlpha', 0, 'DisplayName', 'Error');

    x_max = prctile(empirical_rt, 99);
    xlim([.1 x_max]);

    ylim([y_min, y_max]);
    yticks([y_min: 50: y_max]);

    if ii == 6
        xlabel('Reaction time (s)');
    else
        xticklabels({});
    end

    if ii == 1
        legend('NumColumns', 2, 'Location', 'North');
        legend('boxoff');
        title(new_title);
    end

    set_fig(h, font_size, [2 10]);
end

savefigs(h, filename+"_dist", out_dir, font_size, [2 10]);