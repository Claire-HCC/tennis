clear

set_parameters;
atlas='Juelich';
eval(['rois=rois_' atlas ';']);

%% plot ROI timecourses
for inputi=1%:2;%%1:2;
    input_type=input_types{inputi};
    for rr = 1:length(rois)
        roi = rois{rr};
        roiname = fullfile(expdir,'intersubj',input_type,'roicorr',strrep(roi,'.nii',''));
        
        for condi=1:4;
            cond=conditions2{condi};
            load([roiname '_' cond '_lagroicorr.mat']);
            w=100;
            % plot lagged corrs for every subject for this ROI
            for n = 1:size(lagccs,2);
                figure(9090); clf; set(gcf,'Units','centimeters','position',[0 0 9 10],'paperposition',[0 0 9 10],'PaperPositionMode','auto'); 
                if size(lagccs,2) > length(iscpair); p=iscpair(ceil(n/2));run=-1*mod(n,2)+2; else p = iscpair(n); run=0; end
                i1 = n*w-w; i2 = n*w+w;
                plot(-w:1:w,lagccs(:,n),'color','k',...
                     'LineWidth',1.5);
                ylim([-1 1]);
                set(gca,'XTick',[-w:w/2:2*w],'XTickLabel',[]); grid on
                
                title(sprintf([ cond ' run' num2str(run) '\n' strrep(strrep(roi,'_3mm_thr20mask.nii',''),'_',' ')  '\nPair' num2str(p) ]),'fontsize',12);
                set(gca,'FontSize',12,'XTick',[-w:w/2:2*w],'XTickLabel',[-1*w*tr:w*tr/2:w*tr]); grid on
                xlabel('lag sec'); ylabel('Lagged Correlation');
                print(gcf,[expdir slash 'graph' slash 'roi_laggedcorr'  slash  cond '_run' num2str(run) '_'   strrep(roi,'_3mm_thr20mask.nii','') '_Pair' num2str(p) '.png'],'-r500','-dpng');
            end
            
            %% gorup averaged lagged corr graphe
            %             figure(9091); clf; set(gcf,'Color',[1 1 1]); w = 10;
            %             lagccs_m=mean(lagccs');
            %             lagccs_std=std(lagccs');
            %             errorbar(-w:1:w,lagccs_m,lagccs_std,'color','k','LineWidth',2); hold on
            %             set(gca,'FontSize',9,'XTick',[-w:w:2*w],'XTickLabel',[-1*w*tr:w*tr:w*tr]); grid on
            %             xlabel('lag sec'); ylabel('Lagged Correlation');
            %             xlim([-w w]);
            %             ylim([-0.3 0.3]);
            %             rtitle = sprintf('lagged corr\n%s\n%s',cond,strrep(roi,'_3mm_thr20mask.nii',''));
            %             rtitle(rtitle=='_')=' ';
            %             text(-1.3*w,0,rtitle);
            %             print(gcf,[expdir slash 'graph' slash 'roi_laggedcorr' slash input_type slash  cond '_' strrep(roi,'.nii','') '.png'],'-dpng');
            
        end
    end
end
