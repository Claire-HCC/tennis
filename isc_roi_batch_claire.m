clear

set_parameters;

atlas='Juelich';
eval(['rois=rois_' atlas ';']);

%% ROI Timecourses
% input: 4d functional nifti files for subj01, subj02, subj03
% output: a summary file roi_condname_roicorr.mat that contains ISC info for the ROI

for input_typei=1;%1:2;
    input_type=input_types{input_typei};
    for rr = 1: length(rois);%1:length(rois);
        roi = rois{rr};
        % set roidata load/save flag:
        % 'savedata': run this the first time, after which a .mat will be saved
        % 'loaddata': uses the .mat (faster)
        % if you change the ROI, you need to run with the savedata flag again.
        
        for condi=1:4;
            cond=conditions2{condi};
            clear funcnames;
            for schi=1:2;
                sch=schools{schi};
                funcnames_temp=(dir([expdir slash 'intersubj' slash 'inputs' slash 'Pair*_' sch '_' cond '*' input_type '.nii']));
                funcnames_temp={funcnames_temp.name};
                funcnames_temp=sort_nat( funcnames_temp);
                funcnames(:,schi)=funcnames_temp;
            end
            funcnames=cellfun(@(x) fullfile(expdir,'intersubj', 'inputs',x),funcnames,'Uniformoutput',0);
            roinames = fullfile(expdir,'data',atlas,roi);
            fprintf(['cond = ' cond ', output will be saved as ' rois{rr}(1:end-4)  '_' cond  '_roicorr.mat\n']);
            
            if strcmp(input_type,'trans_res4d'); opts.mcutoff=-200000; elseif strcmp(input_type,'trans_filtered_func'); opts.mcutoff=6000; end% mcutoff is not necessary for residual files, so I set a really low value.
            
            opts.outputPath = fullfile(expdir,'intersubj',input_type,'roicorr');
            opts.outputName = cond;
            
            opts.crop_beginning = 0; % number of TRs to crop from beginning
            opts.crop_end = 0; % number of TRs to crop from end
            opts.roidata ='savedata'; % just to save data in mat format
            nkit_nifti_roi_timecourse_claire(funcnames, roinames, opts);
            opts.roidata ='loaddata'; % calculate corr
            nkit_nifti_roi_timecourse_claire(funcnames, roinames, opts);
            
        end
    end
    
%     fileID = fopen([expdir 'intersubj' slash input_type slash 'roicorr' slash input_type '_meancorrs.txt'],'w');
%     f=cellstr(ls([expdir 'intersubj' slash input_type slash 'roicorr' slash '*mat']));
%     for i = 1:length(f);
%         load([expdir 'intersubj' slash input_type slash 'roicorr' slash f{i}]);
%         fprintf( fileID ,'%s_meancorr_%1.3f\n',f{i}, meancorr);
%     end
%     fclose(fileID);
end


%
% %% ROI Pattern Similarity
% % input: mat files created (by nkit_nifti_roi_timecourse) from 4d functional nifti files for subj01, subj02, subj03
% % output: a summary file roi_cond_patternsim.mat that contains pattern similarity info for the ROI
% % pattern similarity is calculated 1-vs-avg-others at every timepoint
% % then averaged across subjects
%
% for condi=1:4;
%         cond=conditions2{condi};
%         clear names
%         for pi=1:8%length(iscpair);
%             p=iscpair(pi);
%             (dir([expdir slash 'intersubj' slash input_type slash 'Pair*_' sch '_' cond '*' input_type '.nii']));
%             funcnames(:,schi)={funcnames_temp.name};
%             names{n}=['Pair' num2str(p) '_' sch];
%             n=n+1;
%         end
%     end

% nkit_nifti_patternsim_claire(expdir,input_type,names,roiname,cond);
%
%
%
%
% %% plot ROI pattern similarity
% roicorrpath = fullfile(expdir,'intersubj','patternsim');
% roicorr_file = [roiname '_PiemanIntact_patternsim.mat'];
% r = load(fullfile(roicorrpath,roicorr_file));
% figure(9096); clf; set(gcf,'Color',[1 1 1]);
% rcolors = 'rgbm';
%
% % average pattern correlation matrix
% subplot(1,2,1)
% imagesc(r.mcorrmat,[-0.2 0.2]); colorbar
% set(gca,'FontSize',14);
% rtitle = ['Pattern correlation matrix ' roiname]; rtitle(rtitle=='_')='-';
% title(rtitle);
%
% % get diagonal and non-diagonal values
% for n = 1:length(names)
%     subjmat = squeeze(r.allsubs_corrmat(:,:,n));
%     idiag = triu(ones(size(subjmat))) - triu(ones(size(subjmat)),1); % diagonal index
%     ioffdiag = triu(ones(size(subjmat)),1) - triu(ones(size(subjmat))) + 1; % off-diagonal index
%     sdiag{n} = subjmat(logical(idiag));
%     offdiag{n} = subjmat(logical(ioffdiag));
%     subj_sdiag(n) = nanmean(sdiag{n});
%     subj_offdiag(n) = nanmean(offdiag{n});
% end
%
% % summary of diag vs nondiag for each subject
% subplot(1,2,2)
% plot([0 18],[0 0],'k-','LineWidth',2); hold on
% for n = 1:length(names)
%     h1 = plot(n,subj_sdiag(n),'o','Color',rcolors(n),'LineWidth',3,'MarkerSize',10); hold on
%     h2 = plot(n,subj_offdiag(n),'s','Color',rcolors(n),'LineWidth',3,'MarkerSize',10);
%     plot(n,subj_sdiag(n),'.','Color',rcolors(n),'LineWidth',3,'MarkerSize',10); hold on
%     plot(n,subj_offdiag(n),'.','Color',rcolors(n),'LineWidth',3,'MarkerSize',10);
%     plot([n n],[subj_offdiag(n) subj_sdiag(n)],'--','Color',rcolors(n),'LineWidth',2);
% end
% grid on
% xlim([0 n+1]); ylim([-0.1 0.2]);
% set(gca,'FontSize',14);
% xlabel('Subject'); ylabel('R');
% rtitle = ['Diagonal and non-diagonal values ' roiname]; rtitle(rtitle=='_')='-';
% title(rtitle);
% legend([h1 h2],'Diagonal','Non-Diagonal');
% end
% end
%
%
