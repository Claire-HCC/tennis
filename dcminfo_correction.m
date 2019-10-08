% extract dicom from not-interpolated dicoms (dcm_notInterpolated) and correct the interpolated
% dicoms (dcm_wrongInfo) with it, and write new dicoms which are
% interpolated and with the correct dicominfo.
clear all
set_parameters;

for subj=6:7;%
    
    % list run directories
    fdirs=dir([dcmdir_wI pairNames_old{subj} '//run*' ]);
    fdirs={fdirs.name};
    
    p=regexp(pairNames_old{subj},'_','Split');
    p=p{2};
    % creat subject directories in dcmdir
    mkdir([dcmdir p '_nccu'  ]);
    mkdir([dcmdir p '_nymu'  ]);
    
    for fi = 1:length(fdirs);
        fdir=fdirs{fi};
        
        % read dicom info from not-interpolated file
        f_nI=dir([dcmdir_nI pairNames_old{subj} '//' fdirs{fi} '//*IMA']);
        f_nI=f_nI(1).name;
        info=dicominfo([dcmdir_nI pairNames_old{subj} '//' fdirs{fi} '//' f_nI]);
        
        % list of interpolayed dicom file with wrong info
        fs=dir([dcmdir_wI pairNames_old{subj} '//' fdirs{fi} '//*ima']);
        fs={fs.name};
        % sort files by AcquisitionNumber in the file names
        fs_i=regexp(fs,'N..U_([0-9])*.ima','Tokens');
        fs_i=cellfun(@(x) str2num(x{1}{1}),fs_i);
        [voli,idx] = sort(fs_i);
        fs=fs(idx);
        
        
        f=regexp(fdirs{fi},'_','Split');
        runi=f{1};
        cond=f{2};
        school=f{3};
        
        % read each interpolated dicom and re-write with the correct info
        for vi =1:length(voli);
            info.AcquisitionNumber=vi;
            Y=dicomread([dcmdir_wI '//' pairNames_old{subj}  '//' fdirs{fi} '//' fs{vi} ]);
            
            outfileName=sprintf('%s//%s//%s_%s_epi_%s_%04d.IMA',dcmdir,[p '_' school],p,school,cond,vi);
            
            dicomwrite(Y,outfileName,...
                'CreateMode','Copy','WritePrivate',1,info);
            %    info2=dicominfo([dcmdir pairNames_old{subj}  '//' fdirs{fi} '//' fdirs{fi} '_' num2str(vi)]);
            
        end
        
    end
end

