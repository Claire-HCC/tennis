function [F1,F2] = DicomDelayCorrection(File1,File2,H)
%tic;
%20161028
%File1政大、File2陽明，做DelatCorrection，H是相差秒數
%SA是File1的名字、SB是File2的名字
%若 H>0，表示政大比陽明快
%若 H 不是整數，會做內插
%若 H<0，就兩筆資料對換ㄅ~easy~

%對換資料囉~(if needed)
if(H<0)
    File3 = File1;
    File1 = File2;
    File2 = File3;
    clear File3
end

%內插
clear tempFile
for l=1:(length(File1(1,1,:))-1)
    tempFile(:,:,l) = mod(H,2)/2*File1(:,:,(l+1)) + (2-mod(H,2))/2*File1(:,:,l);
end
File1 = tempFile;
clear tempFile

%刪除張數、統一長度
for l=1:(length(File1(1,1,1,:))-floor(H/2))
    File1(:,:,l) = File1(:,:,l+floor(H/2));
end
for l=1:floor(H/2)
    File1(:,:,end) = [];
end
for l=1:(floor(H/2)+1)
    File2(:,:,end) = [];
end

F1 = File1;
clear File1
F2 = File2;
clear File2
%toc;


end