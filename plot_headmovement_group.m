clearvars
loc='mypc';
set_parameters;
hs={'L','R'};
w=20; % in sec

%% group
datadir=[expdir slash 'intersubj' slash 'movements' slash];
for ci=1:6;
    cond=conditions{ci};
    f=ls([expdir slash 'intersubj' slash 'movements' slash 'head_laggcc_' cond '.mat' ]);
    load([datadir f]);
    m=nanmean(lagccs);
    se=nanstd(lagccs)/sqrt(size(lagccs,1));
    figure
    plot(-w/tr:1:w/tr,m,'color','k');
    errorbar(-w/tr:1:w/tr,m,se,'color','k');
    set(gca,'FontSize',12,'XTick',[-w/tr:w/2/tr:w/tr],'XTickLabel',[-w:w/2:w]);
    xlim([-w/tr w/tr]);
    ylim([-0.5 0.5]);
    xlabel('lag (sec)');
    grid on
    title(sprintf([cond '\nhead-finger movements r']));
    print(gcf,[expdir slash 'graph' slash 'movements' slash 'group_head_finger_lagcc_' cond '.png'],'-dpng');
    close gcf;
end


