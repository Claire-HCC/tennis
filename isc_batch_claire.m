% Tutorial for ISC and pattern similarity: isc_nifti_kit
% j chen 06/24/13
% j chen updated 08/09/2016
%
% This tutorial includes fmri data files from 4 subjects who listened to a
% 7-minute auditory story ("Pieman").
% It walks through the steps of loading nifti files into Matlab,
% calculating inter-subject correlation (ISC) in an ROI within the group (correlation of timecourses across subjects),
% plotting ISC in an ROI,
% calculating pattern similarity in an ROI within the group (correlation of spatial patterns across subjects),
% plotting pattern similarity in an ROI,
% calculating ISC at every voxel within-group to create a whole-brain map,
% calculating ISC at every voxel between groups to create a whole-brain map,
% regressing a vector on a 4d functional,
% cropping nifti files,
% calculating mean and stdev maps for a set of subjects.

% All Nifti files must be unzipped
% You will need to change the paths below to match your machine
% *** Always run this section before running any of the other sections ***
clear all
loc='cluster'; 
set_parameters;

addpath([scriptsdir '\isc_nifti_kit_080916\']);
addpath([scriptsdir '\isc_nifti_kit_080916\' '\NIFTI_tools']);


%% ISC by pair
for input_typei=1%:2;
    input_type=input_types{input_typei};
    for pi=1:length(iscpair);
        for condi=1:6;
            p=iscpair(pi);
            
            group1name=['Pair' num2str(p) '_nccu_' conditions{condi}];
            group2name=['Pair' num2str(p) '_nymu_' conditions{condi}];
            funcnames1{1} = fullfile(expdir,'intersubj','inputs',['Pair' num2str(p) '_nccu_' conditions{condi} '_' input_type '.nii']);
            funcnames2{1} = fullfile(expdir,'intersubj','inputs',['Pair' num2str(p) '_nymu_' conditions{condi} '_' input_type '.nii']);
            
            opts.outputPath = fullfile(expdir,'intersubj',input_type,['corrmap']);
            opts.outputName = group1name;
            opts.outputName2 = group2name;
            opts.crop_beginning = 0; % number of TRs to crop from beginning
            opts.crop_end = 0; % number of TRs to crop from end
            
            %     opts.crop_special = [10;  table2array(scanN(find(strcmp(scanN.subject,['Pair' num2str(p) '_nccu_'])),condi+1))]; % specify different crops for different subjects, otherwise defaults to crop_beginning and crop_end
            %    opts.crop_special2 = [10; table2array(scanN(find(strcmp(scanN.subject,['Pair' num2str(p) '_nymu_'])),condi+1))]; % note that these are the same as found in nkit_get_subj_info, rearranged to make 2 groups
            
            opts.mask = fullfile(expdir,'data','MNI152_T1_3mm_brain_mask.nii'); % mask image is optional
            opts.standard = fullfile(expdir,'data','MNI152_T1_3mm_brain.nii'); % all hdr info will come from this file except for datatype=16 and bitpix=32
            opts.mcutoff =0; % 6000 for Skyra data
            opts.load_nifti = 1; % load data from nifti (specified in funcnames), save as .mat
            opts.calc_avg = 0; % calculate the avg of others for each subject
            opts.calc_corr = 1; % calculate intersubject correlations and save output maps as nifti
            opts.save_avgothers_nii = 0; % save the avg others for each subject as nifti files (otherwise saves in .mat only)
            opts.save_mean_nii = 0; % save the mean of all subjectss as a nifti file (otherwise does not calculate the mean)
            nkit_nifti_corrmap_Claire(funcnames1, funcnames2, opts);
        end
    end
end
