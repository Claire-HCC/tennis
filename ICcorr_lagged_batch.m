clear
set_parameters;

% each row of IC corresponds to one pair. Each column of IC corresponds to
% one session. IC(pair,session)
% In each cell, one row for one pair of IC. Column 1
% in dicates the IC number of nccu, Column 2 of nymu.
IC=cell(8,6);
IC{4,1}(1,1:2)=[35 27];
IC{4,2}(1,1:2)=[31 27];
IC{4,3}(1,1:2)=[38 33];
IC{4,4}(1,1:2)=[30 22]; % not sure about 22
IC{4,5}(1,1:2)=[22 30];
IC{4,6}(1,1:2)=[22 13];
IC{5,1}(1,1:2)=[30 39];
IC{5,2}(1,1:2)=[40 46];
IC{5,3}(1,1:2)=[14 8];
IC{5,4}(1,1:2)=[21 47];
IC{5,5}(1,1:2)=[26 40];
IC{5,6}(1,1:2)=[47 48];
IC{7,1}(1,1:2)=[52 10];
IC{7,2}(1,1:2)=[50 28];
IC{7,3}(1,1:2)=[59 15];
IC{7,4}(1,1:2)=[49 20];
IC{7,5}(1,1:2)=[51 28];
IC{7,6}(1,1:2)=[64 14];



for condi= 1:6;
    cond=conditions{condi};
    for p = [4:5 7]; % iscpair;
        for ici = 1:size(IC{p,condi},1);
            
            subject_nccu=['Pair' num2str(p)  '_nccu'];
            subject_nymu=['Pair' num2str(p)  '_nymu'];
            tc1=textread([expdir slash 'subjects' slash subject_nccu slash 'analysis' slash 'preproc' slash 'preproc0' num2str(condi) '.feat' slash  'filtered_func_data.ica' slash 'report' slash 'f' num2str(IC{p,condi}(ici,1)) '.txt' ]);
            tc2=textread([expdir slash 'subjects' slash subject_nymu slash 'analysis' slash 'preproc' slash 'preproc0' num2str(condi) '.feat' slash  'filtered_func_data.ica' slash 'report' slash 'f' num2str(IC{p,condi}(ici,2)) '.txt' ]);
            
            scanN=min(length(tc1(:,1)),length(tc2(:,1)));
            w = scanN-10;
            lagcc1 = lagcorr(tc1(1:scanN,1),tc2(1:scanN,1),[-1*w:w]);
            %       lagcc1 = lagcorr(r.roitc1((length(r.roitc1)-scanN+1):length(r.roitc1),n),r.roitc2((length(r.roitc2)-scanN+1):length(r.roitc2),n),[-1*w:w]);
            lagccs(:,p)=lagcc1;
            
        end
    end
    save([expdir slash 'intersubj' slash 'IC' slash cond '_visual_lagICcorr.mat'],'lagccs');
    clear lagccs;
end


