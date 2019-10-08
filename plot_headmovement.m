clearvars
loc='mypc';
set_parameters;
hs={'L','R'};
w=20; % in sec


% subploti=reshape([1:4],2,2)';

% for ci=1:6;
%     cond=conditions{ci};
%     lagccs=[];
%     
%     for pi=1:length(pairNames_old);
%         pname=pairNames_old{pi};
%         p=regexp(pairNames_old{pi},'_','Split');
%         p=p{2};
%         %   figure; set(gcf,'Units','centimeters','position',[0 0  13.5   11],'paperposition',[0 0 13.5   11],'PaperPositionMode','auto');
%         colormap([0.1 0.1 0.1; 0.55 0.55 0.55; 1 1 1]);
%         
%         for schi=1:2;
%             hseries=[];
%             for hsi=1:2;
%                 h=hs{hsi};
%                 sch=schools{schi};
%                 
%                 [onset,duration,weight] = textread([expdir 'subjects/'  p '_' sch '/design/' conditions{ci}  '_' h '.txt'],'%s\t%s\t%s\n');
%                 onset=cellfun(@(x) str2num(x),onset);
%                 duration=cell2mat(duration);
%                 
%                 hseries_temp=zeros(500000,1);
%                 for i=1:length(onset);
%                     si=(onset(i)*1000+1);
%                     ei=si+str2double(duration(i,:))*1000;
%                     hseries_temp(si:ei)=hseries_temp(si:ei)+1;
%                 end
%                 
%                 hseries_temp=mean(reshape(hseries_temp(1:400000),[1000,400]))';
%                 hseries(:,hsi)=hseries_temp;
%             end
%             parf=[expdir 'subjects\' p '_' sch '\analysis\preproc\preproc0' num2str(ci) '.feat\mc\prefiltered_func_data_mcf.par'];
%             [m1, m2, m3, m4, m5, m6] = textread(parf,'%f  %f  %f  %f  %f  %f  \n');
%             m= [m1, m2, m3, m4, m5, m6] ;
%             
%             subplot(2,2,subploti(schi,1));
%             plot(m);
%             set(gca,'FontSize',12,'XTick',[0:100/tr:400/tr],'XTickLabel',[0:100:400]);
%             ylabel(sprintf([sch '\nheadmovement (mm)']),'fontsize',12);
%             ylim([-3 3]);
%             grid on
%             if schi==1 ;   title(sprintf([p ' ' conditions{ci} ]),'fontsize',12); end
%             hold on
%             
%             hseries=sum(hseries')';
%             hseries=mean(reshape(hseries,[2,200]))';
%             lagcc=lagcorr(hseries,sum(m'),[-w/tr:w/tr]);
%             lagccs(end+1,:)=lagcc;
%             
%             subplot(2,2,subploti(schi,2));
%             plot(-w/tr:1:w/tr,lagcc,'color','k');
%             set(gca,'FontSize',12,'XTick',[-w/tr:w/2/tr:w/tr],'XTickLabel',[-w:w/2:w]);
%             xlabel('lag (sec)','fontsize',12);
%             ylim([-0.5 0.5]);
%             grid on
%             ylabel(sprintf(['r\nwith finger movements']),'fontsize',12);
%         end
%         print(gcf,[expdir '/graph/movements/' p '_' conditions{ci} '_headmovement.png'],'-dpng');
%         close gcf
%     end
%     save([expdir slash 'intersubj' slash 'movements' slash 'head_laggcc_' cond '.mat' ] ,'lagccs');
% end

%% group 
datadir=[expdir slash 'intersubj' slash 'movements' slash];
for ci=1%:6;
    cond=conditions{ci};
f=ls([expdir slash 'intersubj' slash 'movements' slash 'head_laggcc_' cond '.mat' ]);
load([datadir f]);
m=nanmean(lagccs);
se=std(lagccs)/sqrt(size(lagccs,1));
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
