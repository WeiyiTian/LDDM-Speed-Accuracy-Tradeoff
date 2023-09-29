function savefigs(h, filename, outdir, fontsize, aspect)
set_fig(h, fontsize, aspect)
saveas(h, fullfile(outdir,sprintf('%s.eps',filename)), 'epsc2');