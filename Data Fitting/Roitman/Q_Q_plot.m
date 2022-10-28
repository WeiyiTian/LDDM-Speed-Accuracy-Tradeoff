% Q-Q plot for reaction time and choice
lwd = 1.0;
mksz = 3;
fontsize = 11;
x = dataBhvr.proportionmat;
y = dataBhvr.q;
qntls = dataBhvr.qntls;
h = figure; hold on;
% filename = sprintf('Q-QPlot_%s',name);
for vi = 1:length(x)
  xc = x(vi)*ones(size(y(:,1,vi)));
  xw = 1 - x(vi)*ones(size(y(:,2,vi)));
  plot(xc,y(:,1,vi),'gx','MarkerSize',mksz+1,'LineWidth',lwd);
  plot(xw,y(:,2,vi),'rx','MarkerSize',mksz+1,'LineWidth',lwd);
  % fitted value
%   En(vi) = numel(rtmat(:,vi));
%   RT_corr = rtmat(choicemat(:,vi) == 1,vi);
%   RT_wro = rtmat(choicemat(:,vi) == 2,vi);
%   xr = numel(RT_corr)/(numel(RT_corr) + numel(RT_wro));
%   q(:,1,vi) = quantile(RT_corr,qntls); % RT value on quantiles, correct trial
%   q(:,2,vi) = quantile(RT_wro,qntls); % RT value on quantiles, error trial
end
% for qi = 1:size(q,1)
%   xq = [flip(1-x), x]';
%   plot(xq,[squeeze(flip(q(qi,2,:)));squeeze(q(qi,1,:))],'k-o','MarkerSize',mksz,'LineWidth',lwd/2);
% end
xlim([-.05 1.05]);
ylim([0.2, 1.4]);
yticks([.2:.4:1.4]);
xlabel('Proportion');
ylabel('RT (s)');
% savefigs(h, filename, plot_dir, fontsize, [2.5 2.5]);