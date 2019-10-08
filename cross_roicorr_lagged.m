clear
set_parameters;
input_types =  {'trans_filtered_func' ,'trans_res4d'}; %
atlas='Juelich';
eval(['rois=rois_' atlas ';']);

%% plot ROI timecourses

for inputi=1;%%1:2;
    input_type=input_types{inputi};
    
    for r1i = 1:6;%1:length(rois)
        roi1 = rois{r1i};
        roi_fname1 = fullfile(expdir,'intersubj',input_type,'roicorr',strrep(roi1,'.nii',''));
        roiname1= strrep(strrep(roi1,'_3mm_thr20mask.nii',''),'_',' ');
        
        for r2i=7:16;
            roi2 = rois{r2i};
            roi_fname2 = fullfile(expdir,'intersubj',input_type,'roicorr',strrep(roi2,'.nii',''));
            roiname2= strrep(strrep(roi2,'_3mm_thr20mask.nii',''),'_',' ');
            
            for condi=1:4;
                cond=conditions2{condi};
                
                roicorr_file1 = [roi_fname1 '_' cond '_roicorr.mat'];
                r1 = load(roicorr_file1);
                
                roicorr_file2 = [roi_fname2 '_' cond '_roicorr.mat'];
                r2 = load(roicorr_file2);
                
                % plot lagged corrs for every subject for this ROI
                figure(1); clf; set(gcf,'Color',[1 1 1], 'unit','centimeter','position',[0 0 8 16],'paperposition',[0 0 8 16]);
                figure(2); clf; set(gcf,'Color',[1 1 1],'unit','centimeter','position',[0 0 8 16],'paperposition',[0 0 8 16]);
                w = 100;
                lagccs=[];
                for n = 1:length(r1.roicorr);
                    if length(r1.roicorr) > length(iscpair); p=iscpair(ceil(n/2));run=-1*mod(n,2)+2; else p = iscpair(n); run=1; end
                    
                    set(0, 'currentfigure', run);
                    
                    % i1 = n*w-w; i2 = n*w+w;
                    lagcc1 = lagcorr(r1.roitc1(:,n),r2.roitc2(:,n),[-1*w:w]);
                    px1=find(lagcc1==max(lagcc1));
                    
                    lagcc2 = lagcorr(r1.roitc2(:,n),r2.roitc1(:,n),[-1*w:w]);
                    px2=find(lagcc2==max(lagcc2));
                    
                    subplot(8,2,find(iscpair==p)*2-1);
                    x=-w:1:w;
                    plot(x,lagcc1,'color','k');
                    line([x(px1) x(px1)],[-1 1]);
                    ylim([-0.5 0.5]);
                    set(gca,'XTick',[-w:w/2:2*w],'XTickLabel',[]); grid on
                    grid on
                    text(-w,-0.4,['Pair' num2str(p)  ]);
                    if p==4;
                        title([roiname1 '-' roiname2 ' ' cond   num2str(run)  ]);
                    end
                    
                    subplot(8,2,find(iscpair==p)*2);
                    x=-w:1:w;
                    plot(x,lagcc2,'color','k');
                    line([x(px2) x(px2)],[-1 1]);
                    ylim([-0.5 0.5]);
                    
                    lagccs(:,(end+1):(end+2))=[lagcc1 lagcc2];
    
                    if p==iscpair(end);
                        xlabel('lag sec'); ylabel('Lagged Correlation');
                        set(gca,'XTick',[-w:w/2:2*w],'XTickLabel',[]); grid on
                        set(gca,'FontSize',12,'XTick',[-w:w/2:2*w],'XTickLabel',[-1*w*tr:w*tr/2:w*tr]); grid on
                        print(gcf,[expdir slash 'graph' slash 'crossroi_laggedcorr' slash  cond num2str(run) '_'  roiname1 '-' roiname2 '.png'],'-r500','-dpng');
                        
                        fname=fullfile(expdir,'intersubj',input_type,'crossroicorr',[cond num2str(run) '_'  roiname1 '-' roiname2 '.mat']);
                        save(fname,'lagccs');
                    end
                end
            end
        end
    end
end

