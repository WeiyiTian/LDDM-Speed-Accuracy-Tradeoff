function set_fig(h, fontsize, aspect)
set(gca,'FontSize',fontsize);
set(gca,'TickDir','out');
set(gca,'LineWidth', 1); 
xl = get(gca,'XLabel');
xAX = get(gca,'XAxis');
set(xAX,'FontSize', fontsize-2, 'Color', 'k')
set(xl, 'FontSize', fontsize, 'Color', 'k');
yl = get(gca,'YLabel');
yAX = get(gca,'YAxis');
set(yAX,'FontSize', fontsize-2, 'Color', 'k')
set(yl, 'FontSize', fontsize, 'Color', 'k');
h.PaperUnits = 'inches';
h.PaperPosition = [0 0 aspect];