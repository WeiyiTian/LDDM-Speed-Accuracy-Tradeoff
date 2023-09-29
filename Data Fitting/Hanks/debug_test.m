%
empirical_data = load_data("Empirical Data/behavData_eli.mat");
simulate_data = load("simulate_MonkeyE_accuracy_v3");

condition = "accuracy";
%

%% data loading
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

%% data size adjustment
rate = [];
for ii = 1:6
    rate(ii) = length(simulate_rt(:, ii)) / length(empirical_rt(empirical_coh == coh_lst(ii)));
end

%% pre-calculation of simulated data
num_bins = 30;

sim_bank_correct = [];
sim_bank_wrong = [];
sim_bin_center = [];

for ii = 1:6
    % empirical data determines the gap size
    gap = (emp_max_rt - emp_min_rt) / num_bins;
    bin_edge = [sim_min_rt: gap: (sim_max_rt+gap)];
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
for ii = 1:6
    subplot(6, 1, ii); hold on;
    plot(sim_bin_center{ii}, sim_bank_correct{ii}, 'Color', "#0072BD", 'LineWidth', 2);
    plot(sim_bin_center{ii}, -sim_bank_wrong{ii}, 'Color', "#A2142F", 'LineWidth', 2);
    bar(emp_bin_center(ii, :), emp_bank_correct(ii, :));
    bar(emp_bin_center(ii, :), -emp_bank_wrong(ii, :));
end

x_max = prctile(empirical_rt, 98);
xlim([0 x_max]);

%% ditribution of RT and fitted line
% h = figure;
% for ii = 1:6
%     subplot(6,1,ii); hold on;
%     bar(dataBhvr.bincenter(ii,1:30),dataBhvr.histmat(ii,1:30)*1024,'FaceColor',colorpalette{3},'EdgeAlpha',0);
%     bar(dataBhvr.bincenter(ii,1:30),-dataBhvr.histmat(ii,31:60)*1024,'FaceColor',colorpalette{2},'EdgeAlpha',0,'EdgeColor','none');
%     plot(BinMiddle{ii},bank1{ii},'Color',colorpalette{4},'LineWidth',lwd);
%     plot(BinMiddle{ii},-bank2{ii},'Color',colorpalette{1},'LineWidth',lwd);
%     if ii == 7
%         legend({'','','Correct','Error'},'NumColumns',2,'Location','North');
%         legend('boxoff');
%     end
%     ylim([-60,100]);
%     yticks([-50:50:100]);
%     yticklabels({'50','0','50','100'});
%     xlim([100 1762]/1000);
%     xticks([.5,1.0,1.5]);
%     if ii == 6
%         xticklabels({'.5','1.0','1.5'});
%         xlabel('Reaction time (s)');
%     else
%         xticklabels({});
%     end
%     if ii == 1
%         ylabel(' ');
%     end
%     set(gca, 'box','off');
%     savefig(h, filename, outdir, fontsize, aspect8);
% end
