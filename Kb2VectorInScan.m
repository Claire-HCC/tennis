clearvars
loc='mypc';
set_parameters;

% get hrf
xBF.dt=tr; % TR
xBF.name='hrf'% (with time and dispersion derivatives)';
bf = spm_get_bf(xBF)

for pi=1:length(pairNames_old);
    pname=pairNames_old{pi};
    p=regexp(pairNames_old{pi},'_','Split');
    p=p{2};
    
    for schi=1:2;
        for sesi=1:6;
            
            % load and clean table
            sch=schools{schi};
            
            load([expdir 'KeyboardRecord_Modified\' pname '\KeyboardDetail_run' num2str(sesi) '_' sch ]);
            k=cell2table(KeyboardDetail(2:end,:),'VariableNames',strrep(KeyboardDetail(1,:),'(YM1stTrigger)',''));
            idx=all(cellfun(@isempty,k.Status),2);
            k(idx,:)=[];
            
            % left hand
            lpi=find(contains(k.Status,'Press') & contains(k.KbName,{'down','left','up','right'}));
            lri=find(contains(k.Status,'Release') & contains(k.KbName,{'down','left','up','right'}));
            
            % right hand
            rpi=find(contains(k.Status,'Press') & contains(k.KbName,{'NormalStrike', 'PowerStrike', 'SpinStrike'}));
            rri=find(contains(k.Status,'Release') & contains(k.KbName,{'NormalStrike', 'PowerStrike', 'SpinStrike'}));
            
            kp_temp=zeros(300,1);
            % generate scan vector;
            % convert time unit from sec to scan
            for ki=1:length(lpi);
                onset=round(k.RelativeTimeToGameStart{lpi(ki)}/tr);
                if onset>0 & onset<voln;
                    dur=ceil(k.Duration{lri(ki)}/tr); if dur > 2 ; dur = 0; end
                    ii=onset:(onset+dur);
                    kp_temp(ii,1)=kp_temp(ii,1)+1;
                end
            end
            %             unique(kp_temp)
            %             % convole with hrf
                        kp_temp=kp_temp-mean(kp_temp);
                        kp_temp=conv(kp_temp,bf.bf);
            kp(:,1)=kp_temp;
            
            kp_temp=zeros(300,1);
            for ki=1:length(rpi);
                onset=round(k.RelativeTimeToGameStart{rpi(ki)}/tr)-(start_scan-1);
                if onset>0 & onset<voln;
                    dur=ceil(k.Duration{rri(ki)}/tr);  if dur > 2 ; dur = 0;end
                    ii=onset:(onset+dur);
                    kp_temp(ii,1)=kp_temp(ii,1)+1;
                end
            end
            %             unique(kp_temp)
                        kp_temp=kp_temp-mean(kp_temp);
                        kp_temp=conv(kp_temp,bf.bf);
            kp(:,2)=kp_temp;
            kp=kp(start_scan:end_scan,:);%% !!!
            
            % figure; plot(kp); title([p '_' sch '_' condition_orders{pi,sesi}]);
            save([expdir '/KeyboardRecord_Modified/'  p '_' sch '_' condition_orders{pi,sesi}  '.mat'],'kp');
            clear kp
        end
    end
end
