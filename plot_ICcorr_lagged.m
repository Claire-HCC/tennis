clear
set_parameters;

for condi=1:6 ;
    cond=conditions{condi};
    
    load([expdir slash 'intersubj' slash 'IC' slash cond '_visual_lagICcorr.mat']);
    
    for p = 7 %1:size(lagccs,2);
        
        figure(9090); clf; set(gcf,'Units','centimeters','position',[0 0 9 10],'paperposition',[0 0 9 10],'PaperPositionMode','auto');
            
        rN=181;
        w=(rN-1)/2;
        x=-w:1:w;
        y=lagccs(:,p);
        peak_x_tr=x(find(y==max(y(rN/4:rN*3/4))));
        peak_x_sec=peak_x_tr*tr;
        
        plot(x,y,'color','k',...
            'LineWidth',1.5);
        ylim([-1 1]);
        
        set(gca,'XTick',-w:45:w,'XTickLabel',[-w:45:w]*tr,'FontSize',10); grid on
        
        line([peak_x_tr peak_x_tr],[-1 1])
        
        title(sprintf([ cond ' pair' num2str(p) '\nvisual IC\n peak at ' num2str(peak_x_sec) ' sec' ]),'fontsize',10);
        xlabel('lag sec'); ylabel('Lagged Correlation');
        
        print(gcf,[expdir slash '/graph/' slash 'visualIC_laggedcorr_' cond  '_pair' num2str(p) '.png'],'-r500','-dpng');
    end
end

