clearvars
close all

loc='mypc';
set_parameters;

roi_selected={'BA6_L','BA6_R','V5_L','V5_R'};

for pi=[5 9]%iscpair;
    for ci=[1 2 4];%1:6;
        cond=conditions{ci};
        
        for ri=[1:2 ]%[1 2 ]%1:2%:length(roi_selected);
            roi=roi_selected{ri};
            
            
            % use left hand keypress record for right roi
            if contains(roi,'L');
                h=2; hand='Right';
            else
                h=1; hand='Left';
            end
            
            for schi=1:2;
                sch=schools{schi};
                load(sprintf('%s/KeyboardRecord_Modified/Pair%d_%s_%s.mat',expdir,pi,sch,cond));
                kps(:,schi)=kp(:,h);
                kps=zscore(kps);
                
                load(sprintf('%s/intersubj/inputs/%s_3mm_thr20mask_Pair%d_%s_%s_trans_filtered_func', expdir,roi,pi,sch,cond));
                rdatas(:,schi)=mean(rdata)';
            end
            rdatas=zscore(rdatas);
              
            figure;
            subplot(2,1,1);plot(kps);
            r=corr(kps);
            title({['Pair' num2str(pi)],cond,[hand ' hand press'],['r=' num2str(r(1,2))]});
            legend(schools,'Location','southeast');legend('boxoff')
            ylabel('button press');
            ylim([-4 4]);
            grid on;
            xlim([1 200])
            subplot(2,1,2);
            r=corr(rdatas);
            plot(rdatas); title({roi,['r=' num2str(r(1,2))]});
            ylabel('brain activity');
            ylim([-4 4]);
            xlim([1 200])
            grid on;
        end
    end
end







