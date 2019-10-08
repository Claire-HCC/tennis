clear

set_parameters;

atlas='Juelich';
eval(['rois=rois_' atlas ';']);

%% plot ROI timecourses
for inputi=1;%%1:2;
    input_type=input_types{inputi};
    
    for rr = 1:length(rois)
        roi = rois{rr};
        roiname = fullfile(expdir,'intersubj',input_type,'roicorr',strrep(roi,'.nii',''));
        
        for condi=1:4;
            cond=conditions2{condi};
            
            roicorr_file = [roiname '_' cond '_roicorr.mat'];
            r = load(roicorr_file);
            
            % plot lagged corrs for every subject for this ROI
            figure(9090); clf; set(gcf,'Color',[1 1 1],'unit','centimeter','position',[0 0 15 9], 'paperposition',[0 0 15 9]); w = 100;
            for n = 1:length(r.roicorr);
                if length(r.roicorr) > length(iscpair); p=iscpair(ceil(n/2));run=-1*mod(n,2)+2; else p = iscpair(n); run=0; end
                % i1 = n*w-w; i2 = n*w+w;
                lagcc1 = lagcorr(r.roitc1(:,n),r.roitc2(:,n),[-1*w:w]);
                subplot(ceil(length(r.roicorr)/2),2,n);
                plot(-w:1:w,lagcc1,'color','k');
                ylim([-0.5 0.5]);
                set(gca,'XTick',[-w:w/2:2*w],'XTickLabel',[]); grid on
                text(-w,-0.35,['Pair' num2str(p) ' run' num2str(run) ],'FontSize',12) ;
                if n==1;
                    title([cond  ' ' strrep(strrep(roi,'_3mm_thr20mask.nii',''),'_',' ')],'FontSize',14) ;
                end
                lagccs(:,n)=lagcc1;
            end
            set(gca,'FontSize',12,'XTick',[-w:w/2:2*w],'XTickLabel',[-1*w*tr:w*tr/2:w*tr]); grid on
            xlabel('lag sec'); ylabel('Lagged Correlation');
            print(gcf,[expdir slash 'graph' slash 'roi_laggedcorr' slash  cond '_' strrep(roi,'.nii','') '_individuals.png'],'-r500','-dpng');
            
            figure(9091); clf; set(gcf,'Color',[1 1 1],'unit','centimeter','position',[0 0 18 9], 'paperposition',[0 0 18 9]); w = 100;
            lagccs_m=mean(lagccs');
            lagccs_std=std(lagccs');
            errorbar(-w:1:w,lagccs_m,lagccs_std,'color','k','LineWidth',2); hold on
            set(gca,'FontSize',18,'XTick',[-w:w:2*w],'XTickLabel',[-1*w*tr:w*tr:w*tr]); grid on
            xlabel('lag sec'); ylabel('Lagged Correlation');
            xlim([-w w]);
            ylim([-0.3 0.3]);
            rtitle = sprintf('lagged corr\n%s\n%s',cond,strrep(roi,'_3mm_thr20mask.nii',''));
            rtitle(rtitle=='_')=' ';
            text(-1.3*w,0,rtitle,'FontSize',18);
            save([roiname '_' cond '_lagroicorr.mat'],'lagccs');
            print(gcf,[expdir slash 'graph' slash 'roi_laggedcorr' slash  cond '_' strrep(roi,'.nii','') '.png'],'-dpng');
           
        end
    end
end
