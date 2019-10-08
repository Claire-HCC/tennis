% mutual information of angle distribution
% angle a of each player to a reference point as time series for crp
clear all
close all

set_parameters;

xbn=2;
ybn=4;
for p = 4;
    for c=1;%[1 3 ];
        cond1=conditions{c};
        cond2=conditions{c+1};
        
        [r1 b1]=clean_vid_cord(['Pair' num2str(p) '_' cond1 '_trans.mat'],2.5);
        [r2 b2]=clean_vid_cord(['Pair' num2str(p) '_' cond2 '_trans.mat'],2.5);
        load(['Pair' num2str(p) '_' cond1 '_trans.mat']);
        video_width1=video_width;
        video_height1=video_height;
        vid_FrameRate1=vid_FrameRate;
        load(['Pair' num2str(p) '_' cond2 '_trans.mat']);
        video_width2=video_width;
        video_height2=video_height;
        vid_FrameRate2=vid_FrameRate;
        
        
        % crp the longer data and keep only nonnan data points
        ri=intersect(find(~isnan(r1(:,1))) , find(~isnan(r2(:,1))));
        bi=intersect(find(~isnan(b1(:,1))) , find(~isnan(b2(:,1))));
        i=intersect(ri,bi);
        r1=r1(i,:); r2=r2(i,:); b1=b1(i,:); b2=b2(i,:);
        
        r1_bin(:,1)=discretize(r1(:,1),[0:video_width1/xbn:video_width1]);
        r1_bin(:,2)=discretize(r1(:,2),[0:video_height1/ybn:video_height1]);
        %   r1_bin=r1_bin(:,1)+r1_bin(:,2)*bn;
        
        b1_bin(:,1)=discretize(b1(:,1),[0:video_width1/xbn:video_width1]);
        b1_bin(:,2)=discretize(b1(:,2),[0:video_height1/ybn:video_height1]);
        %  b1_bin=b1_bin(:,1)+b1_bin(:,2)*bn;
        
        
        r2_bin(:,1)=discretize(r2(:,1),[0:video_width2/xbn:video_width2]);
        r2_bin(:,2)=discretize(r2(:,2),[0:video_height2/ybn:video_height2]);
        %      r2_bin=r2_bin(:,1)+r2_bin(:,2)*bn;
        
        b2_bin(:,1)=discretize(b2(:,1),[0:video_width2/xbn:video_width2]);
        b2_bin(:,2)=discretize(b2(:,2),[0:video_height2/ybn:video_height2]);
        %      b2_bin=b2_bin(:,1)+b2_bin(:,2)*bn;
        
        ses1=sub2ind([xbn ybn], r1_bin(:,1), r1_bin(:,2))+sub2ind([xbn*2 ybn*2], b1_bin(:,1)+xbn, b1_bin(:,2)+ybn);
        ses2=sub2ind([xbn ybn], r2_bin(:,1), r2_bin(:,2))+sub2ind([xbn*2 ybn*2], b2_bin(:,1)+xbn, b2_bin(:,2)+ybn);
        ses3=sub2ind([xbn ybn], r1_bin(:,1), r1_bin(:,2))+sub2ind([xbn*2 ybn*2], b2_bin(:,1)+xbn, b2_bin(:,2)+ybn);
        ses2=sub2ind([xbn ybn], r2_bin(:,1), r2_bin(:,2))+sub2ind([xbn ybn], b2_bin(:,1), b2_bin(:,2));
        ses3=sub2ind([xbn ybn], r1_bin(:,1), r1_bin(:,2))+sub2ind([xbn ybn], b2_bin(:,1), b2_bin(:,2));
    end
end
    