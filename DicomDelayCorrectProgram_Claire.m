addpath Z:/claire/tennis/scripts_claire;
dirScanPair = dir('Z:/claire/tennis_raw/ScanTimeLog');
cd('Z:/claire/tennis_raw/dcm_notInterpolated');
load Z:/claire/tennis/scripts_claire/DelayList.mat;

for l=3%:length(dirScanPair)
    cd(dirScanPair(l).name)
    p=regexp(dirScanPair(l).name,'.*_Pair([0-9]*)','tokens');
    p=p{1}{1};
    
    dirSession = dir(pwd);
    %     newPath = sprintf(...
    %     '/autofs/space/maki6_001/users/r04945014/HyperScanning/Tennis/MRI_Interpolated_Dicom/%s'...
    %         ,dirScanPair(l).name);
    
    for m=5:2:(length(dirSession))  %dir排序上T1在run前面...
        cd(dirSession(m).name)
        FileList = dir(pwd);
        clear NCCU
        for f=3:222
            info = dicominfo(FileList(f).name);
            NCCU(:,:,f-2) = dicomread(info);
        end
        
        cd ..
        cd(dirSession(m+1).name)
        FileList = dir(pwd);
        clear NYMU
        for f=3:222
            info = dicominfo(FileList(f).name);
            NYMU(:,:,f-2) = dicomread(info);
        end
        % NCCU = double(NCCU);
        % NYMU = double(NYMU);
        [C_NCCU,C_NYMU] = DicomDelayCorrection(NCCU,NYMU,DelayList((l-2),(m-3)/2));
        
        names=regexp(dirSession(m).name,'_','split');
        cond=names{2};
        sch=names{3};
        
        mkdir(sprintf('%s/%s','Z:/claire/tennis_raw/dcm',['Pair' p '_' sch]));
        cd(sprintf('%s/%s','Z:/claire/tennis_raw/dcm',['Pair' p '_' sch]));
        for d=1:length(C_NCCU(1,1,:))
            info.AcquisitionNumber=d;
            dicomwrite(C_NCCU(:,:,d),sprintf('Pair%s_%s_epi_%s_%04d.IMA',p,sch,cond,d),'CreateMode','copy', 'WritePrivate', 1,info);
        end
        
        names=regexp(dirSession(m+1).name,'_','split');
        cond=names{2};
        sch=names{3};
        mkdir(sprintf('%s/%s','Z:/claire/tennis_raw/dcm',['Pair' p '_' sch]));
        cd(sprintf('%s/%s','Z:/claire/tennis_raw/dcm',['Pair' p '_' sch]));
        for d=1:length(C_NYMU(1,1,:))
            info.AcquisitionNumber=d;
            dicomwrite(C_NYMU(:,:,d),sprintf('Pair%s_%s_epi_%s_%04d.IMA',p,sch,cond,d),'CreateMode','copy', 'WritePrivate', 1,info);
        end
        cd('Z:/claire/tennis_raw/dcm_notInterpolated')
        cd(dirScanPair(l).name)
    end
    cd ..
end


