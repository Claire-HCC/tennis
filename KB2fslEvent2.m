clearvars
loc='mypc';
set_parameters;

summaryfile = fopen([expdir '/design/emptyEV.txt'],'w');
fclose(summaryfile);
movetypes={'down','left','up','right','NormalStrike', 'PowerStrike', 'SpinStrike'};

for pi=1:length(pairNames_old);
    pname=pairNames_old{pi};
    p=regexp(pairNames_old{pi},'_','Split');
    p=p{2};
    for schi=1:2;
        for sesi=1:6;
            sch=schools{schi};
            load([expdir 'KeyboardRecord_Modified\' pname '\KeyboardDetail_run' num2str(sesi) '_' sch ]);
            for i = 1:size(KeyboardDetail,2);
                varname=strrep(KeyboardDetail{1,i},'(YM1stTrigger)','');
                eval([varname '=KeyboardDetail(2:size(KeyboardDetail,1),' num2str(i) ')'] );
                % eval([varname '=' varname '(~cellfun(@isempty,' varname '))'])
            end
            ri=find(strcmp(Status,'Release'));
            for mi=1:length(movetypes);
                m=movetypes{mi};
                pressi=find(strcmp(Status,'Press') & strcmp(KbName,m));
                ri=find(strcmp(Status,'Release') & strcmp(KbName,m));
                if ~isempty(pressi); ri(ri<pressi(1))=[]; pressi(pressi>ri(end))=[]; end
                
                onsets=cell2mat(RelativeTimeToGameStart(pressi));
                durations=cell2mat(Duration(ri));
                
                A=[onsets durations];
                
                if  sesi==1 & mi==1;
                    fileID = fopen([expdir 'subjects/'  p '_' sch '/design/emptyEV.txt'],'w');
                else
                    fileID = fopen([expdir 'subjects/'  p '_' sch '/design/emptyEV.txt'],'a');
                end
                
                if isempty(A);
                    ci=find(strcmp(conditions,condition_orders{pi,sesi}));
                    fprintf(fileID,'feat%02d\t%d\n',ci,mi);
                    fclose(fileID);
                    
                    fileID = fopen([expdir 'subjects/'  p '_' sch '/design/' condition_orders{pi,sesi}  '_' m '.txt'],'w');
                    fprintf(fileID ,'%d\t%d\t%d\n',[0 0 0]);
                    fclose(fileID);
                    
                    summaryfile=fopen([expdir '/design/emptyEV.txt'],'a');
                    fprintf(summaryfile,'%s_%s\tfeat%02d\t%d\n', p,sch ,ci,mi);
                    fclose(summaryfile);
                    
                else
                    A(:,1)=A(:,1)-(start_scan-1)*tr;
                    A=A(A(:,1)>0,:);
                    A=A(A(:,1)<end_scan*tr,:);
                    formatSpec = '%8.3f\t%5.3f\t1\n';
                    fileID = fopen([expdir 'subjects/'  p '_' sch '/design/' condition_orders{pi,sesi}  '_' m '.txt'],'w');
                    fprintf(fileID ,formatSpec,A');
                    fclose(fileID);
                end
            end
            clear(KeyboardDetail{1,:});
            fclose all
        end
        
    end
end
