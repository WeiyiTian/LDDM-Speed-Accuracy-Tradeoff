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

%% pre-calculation of simulated data
num_bins = 30;
acc_sim_bank = [];
acc_sim_bin_center = [];
speed_sim_bank = [];
speed_sim_bin_center = [];

for ii = 1:6
    % empirical data determines the gap size
    acc_gap = (acc_emp_max_rt(ii) - acc_emp_min_rt(ii)) / num_bins;
    acc_bin_edge = [acc_sim_min_rt(ii): acc_gap: (acc_sim_max_rt(ii)+acc_gap)];
    acc_hg = histogram(acc_simulate_rt(:, ii), 'BinEdges', acc_bin_edge, 'Visible', 0);
    acc_sim_bank{ii} = acc_hg.Values / acc_rate(ii);
    acc_sim_bin_center{ii} = acc_bin_edge(1: end-1) + acc_gap/2;
    close;

    speed_gap = (speed_emp_max_rt(ii) - speed_emp_min_rt(ii)) / num_bins;
    speed_bin_edge = [speed_sim_min_rt(ii): speed_gap: (speed_sim_max_rt(ii)+speed_gap)];
    speed_hg = histogram(speed_simulate_rt(:, ii), 'BinEdges', speed_bin_edge, 'Visible', 0);
    speed_sim_bank{ii} = speed_hg.Values / speed_rate(ii);
    speed_sim_bin_center{ii} = speed_bin_edge(1: end-1) + speed_gap/2;
    close;
end

%% pre-calculation of empirical data
acc_emp_bin_center = [];
acc_emp_bank = [];
speed_emp_bin_center = [];
speed_emp_bank = [];

for ii = 1:6
    acc_tmp_rt = acc_empirical_rt(acc_empirical_coh == coh_lst(ii));
    acc_tmp_min_rt = min(acc_tmp_rt);
    acc_tmp_max_rt = max(acc_tmp_rt);
    acc_tmp_bins = linspace(acc_tmp_min_rt, acc_tmp_max_rt, num_bins+1);

    acc_tmp_hg = histogram(acc_tmp_rt, 'BinEdges', acc_tmp_bins, 'Visible', 0);
    acc_tmp_bin_center = acc_tmp_hg.BinEdges(1: end-1) + acc_tmp_hg.BinWidth/2;
    acc_emp_bin_center = [acc_emp_bin_center; acc_tmp_bin_center];
    acc_emp_bank = [acc_emp_bank; acc_tmp_hg.Values];
    close;

    speed_tmp_rt = speed_empirical_rt(speed_empirical_coh == coh_lst(ii));
    speed_tmp_min_rt = min(speed_tmp_rt);
    speed_tmp_max_rt = max(speed_tmp_rt);
    speed_tmp_bins = linspace(speed_tmp_min_rt, speed_tmp_max_rt, num_bins+1);

    speed_tmp_hg = histogram(speed_tmp_rt, 'BinEdges', speed_tmp_bins, 'Visible', 0);
    speed_tmp_bin_center = speed_tmp_hg.BinEdges(1: end-1) + speed_tmp_hg.BinWidth/2;
    speed_emp_bin_center = [speed_emp_bin_center; speed_tmp_bin_center];
    speed_emp_bank = [speed_emp_bank; speed_tmp_hg.Values];
    close;
end

%% RT distribution and fitted line visualization
h = figure;
lwd = 1;
font_size = 8;

y_max = ceil(max([max(acc_emp_bank(:)), max(speed_emp_bank(:)), ...
    max(cell2mat(acc_sim_bank)), max(cell2mat(speed_sim_bank))]) / 50) * 50;

for ii = 1:6
    subplot(6, 1, ii); hold on;

    plot(acc_sim_bin_center{ii}, acc_sim_bank{ii}, 'LineWidth', lwd, 'Color', '#86A3B8', 'DisplayName', '');
    bar(acc_emp_bin_center(ii, :), acc_emp_bank(ii, :), 'FaceColor', '#8D8DAA', ...
        'BarWidth', 1, 'FaceAlpha', .7, 'EdgeAlpha', 0, 'DisplayName', 'Accuracy');

    plot(speed_sim_bin_center{ii}, speed_sim_bank{ii}, 'LineWidth', lwd, 'Color', '#BD574E', 'DisplayName', '');
    bar(speed_emp_bin_center(ii, :), speed_emp_bank(ii, :), 'FaceColor', '#EA5455', ...
        'BarWidth', 1, 'FaceAlpha', .7, 'EdgeAlpha', 0, 'DisplayName', 'Speed');

    x_max = max([prctile(acc_empirical_rt, 95), prctile(speed_empirical_rt, 95)]);
    xlim([.15 x_max]);

    ylim([0, y_max]);
    yticks([0: 50: y_max]);

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

savefigs(h, filename+"_comb_dist", out_dir, font_size, [2 10]);