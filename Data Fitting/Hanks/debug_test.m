%
empirical_data = load_data("Empirical Data/behavData_dam.mat");
simulate_data = load("simulate_MonkeyD_accuracy_v4");

condition = "accuracy";
%

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

emp_max_rt = max(empirical_rt);
emp_min_rt = min(empirical_rt);
sim_max_rt = max(simulate_rt);
sim_min_rt = min(simulate_rt);

rate = length(simulate_rt) / length(empirical_rt);
num_bins = 30;

sim_bank_correct = [];
sim_bank_wrong = [];
sim_bin_center = [];

ii=6;
%for ii = 1:6
    % empirical data determines the gap size
    gap = (emp_max_rt - emp_min_rt) / num_bins;
    bin_edge = [sim_min_rt: gap: (sim_max_rt+gap)];
    correct_hg = histogram(simulate_rt(simulate_choice(:, ii)==1, ii), 'BinEdges', bin_edge, 'Visible', 0);
    sim_bank_correct{ii} = correct_hg.Values / rate;
    close;
    wrong_hg =  histogram(simulate_rt(simulate_choice(:, ii)==2, ii), 'BinEdges', bin_edge, 'Visible', 0);
    sim_bank_wrong{ii} = wrong_hg.Values / rate;
    close;
    sim_bin_center{ii} = bin_edge(1: end-1) + gap/2;
%end

hold on;
plot(sim_bin_center{ii}, sim_bank_correct{ii}, 'o', 'Color', "#0072BD", 'LineWidth', 2);
%plot(sim_bin_center{ii}, -sim_bank_wrong{ii}, 'Color', "#A2142F", 'LineWidth', 2);