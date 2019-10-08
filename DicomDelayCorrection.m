function [F1,F2] = DicomDelayCorrection(File1,File2,H)
%tic;
%20161028
%File1�F�j�BFile2�����A��DelatCorrection�AH�O�ۮt���
%SA�OFile1���W�r�BSB�OFile2���W�r
%�Y H>0�A��ܬF�j�񶧩���
%�Y H ���O��ơA�|������
%�Y H<0�A�N�ⵧ��ƹﴫ�t~easy~

%�ﴫ����o~(if needed)
if(H<0)
    File3 = File1;
    File1 = File2;
    File2 = File3;
    clear File3
end

%����
clear tempFile
for l=1:(length(File1(1,1,:))-1)
    tempFile(:,:,l) = mod(H,2)/2*File1(:,:,(l+1)) + (2-mod(H,2))/2*File1(:,:,l);
end
File1 = tempFile;
clear tempFile

%�R���i�ơB�Τ@����
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