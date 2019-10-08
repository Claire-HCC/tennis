clearvars
loc='mypc';
set_parameters;
hs={'L','R'};
w=20; % in sec
datadir=[expdir slash 'intersubj' slash 'movements' slash];

for ci=1:6;
    cond=conditions{ci};
    load([datadir 'hand_laggcc_' cond '_L.mat' ]);
    load([datadir 'hand_laggcc_' cond '_R.mat' ]);
    figure
    
    m=nanmean(lagccL);
    se=nanstd(lagccL)/sqrt(size(lagccL,1));
    subplot(1,2,1);
    plot(-w:1:w,m,'color','k');
    errorbar(-w:1:w,m,se,'color','k');
    set(gca,'FontSize',12,'XTick',[-w:w/2:w],'XTickLabel',[-w:w/2:w]);
    xlim([-w/tr w/tr]);
    ylim([-0.5 0.5]);
    xlabel('lag (sec)');
    grid on
    title(sprintf([cond '\nfinger movements r\nL' ]));
    
    m=nanmean(lagccR);
    se=nanstd(lagccR)/sqrt(size(lagccR,1));
    subplot(1,2,2);
    plot(-w:1:w,m,'color','k');
    errorbar(-w:1:w,m,se,'color','k');
    set(gca,'FontSize',12,'XTick',[-w:w/2:w],'XTickLabel',[-w:w/2:w]);
    xlim([-w/tr w/tr]);
    ylim([-0.5 0.5]);
    grid on
    title(sprintf(['R' ]));
    
    print(gcf,[expdir slash 'graph' slash 'movements' slash 'group_fingerfinger_lagcc_' cond '.png'],'-dpng');
    close gcf;
    
end
