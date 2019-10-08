clear
set_parameters;
input_type = 'trans_res4d'; %  'trans_filtered_func' ;
atlas='Juelich';
eval(['rois=rois_' atlas ';']);

addpath([scriptsdir '\isc_nifti_kit_080916\']);
addpath([scriptsdir '\isc_nifti_kit_080916\' '\NIFTI_tools']);

%% ROI Timecourses
% input: 4d functional nifti files for subj01, subj02, subj03
% output: a summary file roi_condname_roicorr.mat that contains ISC info for the ROI

for rr = 1%:length(rois)
    roi = rois{rr};
    roidataflag = 'savedata';
    % set roidata load/save flag:
    % 'savedata': run this the first time, after which a .mat will be saved
    % 'loaddata': uses the .mat (faster)
    % if you change the ROI, you need to run with the savedata flag again.
    
    for condi=1:6;
        for schi=1:2;
            sch=schools{schi};
            cond=conditions{condi};
            
            n=1;
            for pi=1:8%length(iscpair);
                p=iscpair(pi);
                funcnames{n} = fullfile(expdir,'intersubj','inputs',['Pair' num2str(p) '_' sch '_' cond '_' input_type '.nii']);
                n=n+1;
            end
            
            roinames = fullfile(expdir,'data',atlas,roi);
            fprintf(['cond = ' cond ', output will be saved as ' rois{rr}(1:end-4) '_' sch '_' cond  '_roicorr.mat\n']);
            opts.outputPath = fullfile(expdir,'intersubj',input_type,'roicorr');
            opts.outputName = cond;
            
            opts.crop_beginning = 0; % number of TRs to crop from beginning
            opts.crop_end = 0; % number of TRs to crop from end
            %   opts.crop_special = nkit_get_subj_info('crop_special',cond); % specify different crops for different subjects, otherwise defaults to crop_beginning and crop_end
            opts.roidata = roidataflag;
            nkit_nifti_roi_timecourse(funcnames, roinames, opts);
            
            if strcmp(roidataflag,'savedata'); % if using savedata flag, auto-run loaddata afterward
                opts.roidata = 'loaddata';
                nkit_nifti_roi_timecourse(funcnames, roinames, opts);
            end
        end
    end
end