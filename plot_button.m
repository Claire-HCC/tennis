clearvars
set_parameters
hs={'L','R'};
w=20;
for pi=1:length(pairNames_old);
    pname=pairNames_old{pi};
    p=regexp(pairNames_old{pi},'_','Split');
    p=p{2};
    for ci=1:6;
        
        figure; set(gcf,'Units','centimeters','position',[0 0 15 8],'paperposition',[0 0 15 8],'PaperPositionMode','auto');
        colormap([0.1 0.1 0.1; 0.55 0.55 0.55; 1 1 1]);
        
        for hsi=1:2;
            h=hs{hsi};
            
            for schi=1:2;
                sch=schools{schi};
                
                [onset,duration,weight] = textread([expdir 'subjects/'  p '_' sch '/design/' conditions{ci}  '_' h '.txt'],'%s\t%s\t%s\n');
                onset=cellfun(@(x) str2num(x),onset);
                duration=cell2mat(duration);
                
                hseries_temp=zeros(500000,1);
                for i=1:length(onset);
                    si=(onset(i)*1000+1);
                    ei=si+str2double(duration(i,:))*1000;
                    hseries_temp(si:ei)=hseries_temp(si:ei)+1;
                end
                hseries_temp=mean(reshape(hseries_temp(1:400000),[1000,400]))';
                hseries(:,(schi-1)*2+hsi)= hseries_temp;
                subplot(2,2,(hsi-1)*2+1);
                plot(hseries_temp);
                hold on
                if schi==1 & hsi ==1;   title([p ' ' conditions{ci}]);  end
                
            end
            set(gca,'XTick',[]);
            ylabel(sprintf([h '\nPressedButtonN'  ]));
            ylim([0 3]);
            hold off;
            
        end
        
        legend({'nccu','nymu'});
        set(gca,'FontSize',10,'XTick',[0:50:400],'XTickLabel',[0:50:400]);
        xlabel('sec');
        
        lagcc(:,1)=lagcorr(hseries(:,1),hseries(:,3),[-w:w]);
        lagcc(:,2)=lagcorr(hseries(:,2),hseries(:,4),[-w:w]);
        subplot(2,2,2); plot(-w:1:w,lagcc(:,1),'color','k');
         ylim([-0.5 0.5]); grid on
        subplot(2,2,4); plot(-w:1:w,lagcc(:,2),'color','k');
        ylim([-0.5 0.5]); grid on
        set(gca,'FontSize',12,'XTick',[-w:w/2:w],'XTickLabel',[-w:w/2:w]);
        xlabel('lag (sec)');
        ylabel('r');
      print(gcf,[expdir '/graph/button_behavioral/' p '_' conditions{ci} '.png'],'-dpng');
    end
end
