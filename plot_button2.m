clearvars
loc='mypc';
set_parameters
hs={'L','R'};
w=20;
subploti=reshape([1:6],2,3)';

for ci=1:6;
    lagccL=[];
    lagccR=[];
    cond=conditions{ci};
    
    for pi=1:length(pairNames_old);
        pname=pairNames_old{pi};
        p=regexp(pairNames_old{pi},'_','Split');
        p=p{2};
        
        figure; set(gcf,'Units','centimeters','position',[0 0 12 20],'paperposition',[0 0 12 20],'PaperPositionMode','auto');
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
%                 subplot(3,2,subploti(schi,hsi));
%                 plot(hseries_temp,'color','k');
%                 set(gca,'FontSize',9,'XTick',[0:100:400],'XTickLabel',[]);
%                 ylim([0 3])
%                 grid on
%                 
%                 if schi==1 ; title([h]);end
%                 if schi==1 & hsi ==1;   title(sprintf([p ' ' conditions{ci} '\n%s'],h));
%                     set(gca,'FontSize',9,'XTick',[0:100:400],'XTickLabel',[0:100:400]);
%                     xlabel('sec');
%                     hold on
%                 end
%                 if hsi==1; ylabel(sprintf([sch '\nButtonN'  ]),'fontsize',12); end
                
            end
        end
        
        lagccL(end+1,:)=lagcorr(hseries(:,1),hseries(:,3),[-w:w]);
        lagccR(end+1,:)=lagcorr(hseries(:,2),hseries(:,4),[-w:w]);
        
%         subplot(3,2,5); plot(-w:1:w, lagccL(end,:),'color','k');
%         ylim([-0.5 0.5]); grid on
%         set(gca,'FontSize',12,'XTick',[-w:w/2:w],'XTickLabel',[-w:w/2:w]);
%         xlabel('lag (sec)','fontsize',12);
%         ylabel('r','fontsize',14);
%         
%         subplot(3,2,6); plot(-w:1:w, lagccL(end,:),'color','k');
%         ylim([-0.5 0.5]); grid on
%         set(gca,'FontSize',12,'XTick',[-w:w/2:w],'XTickLabel',[-w:w/2:w]);
%         print(gcf,[expdir '/graph/movements/' p '_' conditions{ci} '.png'],'-dpng');
close gcf
    end
    save([expdir slash 'intersubj' slash 'movements' slash 'hand_laggcc_' cond '_L.mat' ] ,'lagccL');
    save([expdir slash 'intersubj' slash 'movements' slash 'hand_laggcc_' cond '_R.mat'] ,'lagccR');
    
end
