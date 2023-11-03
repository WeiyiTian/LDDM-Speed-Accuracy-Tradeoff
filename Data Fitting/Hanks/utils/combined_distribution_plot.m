function combined_distribution_plot(acc_sim, speed_sim, empirical_data, monkey, version, filename)
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

acc_rate = [];
speed_rate = [];

acc_emp_max_rt = [];
acc_emp_min_rt = [];
speed_emp_max_rt = [];
speed_emp_min_rt = [];

acc_sim_max_rt = [];
acc_sim_min_rt = [];
speed_sim_max_rt = [];
speed_sim_min_rt = [];

for ii = 1:6
    acc_emp_max_rt(ii) = max(acc_empirical_rt(acc_empirical_coh == coh_lst(ii)));
    acc_emp_min_rt(ii) = min(acc_empirical_rt(acc_empirical_coh == coh_lst(ii)));
    speed_emp_max_rt(ii) = max(speed_empirical_rt(speed_empirical_coh == coh_lst(ii)));
    speed_emp_min_rt(ii) = min(speed_empirical_rt(speed_empirical_coh == coh_lst(ii)));

    acc_rate(ii) = length(acc_simulate_rt(:, ii)) / length(acc_empirical_rt(acc_empirical_coh == coh_lst(ii)));
    speed_rate(ii) = length(speed_simulate_rt(:, ii)) / length(speed_empirical_rt(speed_empirical_coh == coh_lst(ii)));

    acc_sim_max_rt(ii) = max(acc_simulate_rt(:, ii));
    acc_sim_min_rt(ii) = min(acc_simulate_rt(:, ii));
    speed_sim_max_rt(ii) = max(speed_simulate_rt(:, ii));
    speed_sim_min_rt(ii) = min(speed_simulate_rt(:, ii));

end

perc = 70;
num_bins = 6;

%% pre-calculation of simulated data
acc_sim_bank = [];
acc_sim_bin_center = [];
speed_sim_bank = [];
speed_sim_bin_center = [];
for ii = 1:6
    % empirical data determines the gap size    
    acc_sim_rt = acc_simulate_rt(:, ii);
    speed_sim_rt = speed_simulate_rt(:, ii);
    sim_rt = [speed_sim_rt; acc_sim_rt];
    
    acc_emp_rt = acc_empirical_rt(acc_empirical_coh == coh_lst(ii));
    speed_emp_rt = speed_empirical_rt(speed_empirical_coh == coh_lst(ii));
    emp_rt = [speed_emp_rt; acc_emp_rt];
    
    gap = (prctile(speed_emp_rt, perc) - prctile(speed_emp_rt, 100-perc)) / num_bins;
    bin_edge = [min(sim_rt): gap: (max(sim_rt)+gap)];

    acc_hg = histogram(acc_simulate_rt(:, ii), 'BinEdges', bin_edge, 'Visible', 0);
    acc_sim_bank{ii} = acc_hg.Values / acc_rate(ii);
    acc_sim_bin_center{ii} = bin_edge(1: end-1) + gap/2;
    close;

    speed_hg = histogram(speed_simulate_rt(:, ii), 'BinEdges', bin_edge, 'Visible', 0);
    speed_sim_bank{ii} = speed_hg.Values / speed_rate(ii);
    speed_sim_bin_center{ii} = bin_edge(1: end-1) + gap/2;
    close;
end

%% pre-calculation of empirical data
acc_emp_bin_center = [];
acc_emp_bank = [];
speed_emp_bin_center = [];
speed_emp_bank = [];

for ii = 1:6
    acc_emp_rt = acc_empirical_rt(acc_empirical_coh == coh_lst(ii));
    speed_emp_rt = speed_empirical_rt(speed_empirical_coh == coh_lst(ii));
    emp_rt = [speed_emp_rt; acc_emp_rt];
    gap = (prctile(speed_emp_rt, perc) - prctile(speed_emp_rt, 100-perc)) / num_bins;
    bin_edge = [min(emp_rt): gap: (max(emp_rt)+gap)];

    acc_tmp_hg = histogram(acc_emp_rt, 'BinEdges', bin_edge, 'Visible', 0);
    acc_emp_bin_center{ii} =  bin_edge(1:end-1) + gap/2;
    acc_emp_bank{ii} = acc_tmp_hg.Values;
    close;

    speed_tmp_hg = histogram(speed_emp_rt, 'BinEdges', bin_edge, 'Visible', 0);
    speed_emp_bin_center{ii} = bin_edge(1:end-1) + gap/2;
    speed_emp_bank{ii} = speed_tmp_hg.Values;
    close;
end

%% RT distribution and fitted line visualization
h = figure;
lwd = 1;
font_size = 8;

y_max = ceil(max([max(cell2mat(acc_emp_bank)), max(cell2mat(speed_emp_bank)), ...
    max(cell2mat(acc_sim_bank)), max(cell2mat(speed_sim_bank))]) / 10) * 10;
x_max = max([prctile([acc_empirical_rt; speed_empirical_rt], 98)]);

for ii = 1:6
    subplot(6, 1, ii); hold on;

    lg1 = plot(acc_sim_bin_center{ii}, acc_sim_bank{ii}, 'LineWidth', lwd, 'Color', '#86A3B8', 'DisplayName', '');
    lg2 = bar(acc_emp_bin_center{ii}, acc_emp_bank{ii}, 'FaceColor', '#8D8DAA', ...
        'BarWidth', 1, 'FaceAlpha', .7, 'EdgeAlpha', 0, 'DisplayName', 'Accuracy');

    lg3 = plot(speed_sim_bin_center{ii}, speed_sim_bank{ii}, 'LineWidth', lwd, 'Color', '#BD574E', 'DisplayName', '');
    lg4 = bar(speed_emp_bin_center{ii}, speed_emp_bank{ii}, 'FaceColor', '#EA5455', ...
        'BarWidth', 1, 'FaceAlpha', .7, 'EdgeAlpha', 0, 'DisplayName', 'Speed');

    xlim([.15, x_max]);
    ylim([0, y_max]);
    yticks([0: 20: y_max]);

    if ii == 6
        xlabel('Reaction time (s)');
    else
        xticklabels({});
    end

    if ii == 1
%         legend('NumColumns', 2, 'Location', 'northoutside');
%         legend('boxoff');
        title(new_title);
    end

    set_fig(h, font_size, [2 10]);
end

legend([lg1, lg3, lg2, lg4], {'', '', 'Accuracy', 'Speed'}, 'Box', 'Off', 'NumColumns', 2);
savefigs(h, filename+"_comb_dist", out_dir, font_size, [3 8]);