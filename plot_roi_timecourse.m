clear
loc='mypc';
set_parameters;

atlas='Juelich';
eval(['rois=rois_' atlas ';']);
input_types= {'trans_filtered_func' , 'trans_res4d'}; %

for input_typei=1:2;%1:2;
    input_type=input_types{input_typei};
    
    for rr =1:length(rois)
        roi = rois{rr};
        roiname = fullfile(expdir,'intersubj',input_type,'roicorr',strrep(roi,'.nii',''));
        
        for condi=1:4;
            cond=conditions2{condi};
            
            roicorr_file = [roiname '_' cond '_roicorr.mat'];
            r = load(roicorr_file);
            
            for n = 1:length(r.roicorr);
                if length(r.roicorr) > length(iscpair); p=iscpair(ceil(n/2)); run=-1*mod(n,2)+2; else p = iscpair(n); run=0;end
                figure(9090); clf; 
                set(gcf,'Units','centimeters','position',[0 0  10  9],'paperposition',[0 0 10 9],'PaperPositionMode','auto');
                set(gcf,'Color',[1 1 1]);
                plot(r.roitc1(:,n),'color','r','LineWidth',2);
                hold on;
                plot(r.roitc2(:,n),'color','b','LineWidth',2);
                ylim([-5 5])
                set(gca,'FontSize',10,'Xtick',[0:50:200],'XtickLabel',[0:50*tr:200*tr]); 
                grid on; xlabel('sec'); ylabel('Z')
                rtitle = sprintf('Pair%d timecourse\n%s%d\n%s\nr=%1.3f',p,cond,run,strrep(roi,'_3mm_thr20mask.nii',''),r.roicorr(n));
                rtitle(rtitle=='_')=' ';
                title(rtitle,'fontsize',10);
                legend(['nccu'; 'nymu']);
                print(gcf,[expdir slash 'graph' slash 'roi_timecourse' slash 'Pair' num2str(p) '_' cond num2str(run) '_' strrep(roi,'.nii','') '.png'],'-dpng');
                %  pause
                close gcf
            end
        end
    end
end