function [r b p1 p2]=clean_vid_cord(track_mat,kstd);

set_parameters;
load(track_mat);
for pi =1:4;
    switch pi
        case 1
            p='r';
        case 2
            p='b';
        case 3
            p='p1';
        case 4
            p='p2';
    end
    eval(['cord=player_' p '.Centroid']);
    
    % clean points out of screen
    cord(cord(:,1)<0 | cord(:,1)>video_width | cord(:,2)<0 | cord(:,2)>video_height,:)=NaN;
    
    % clean points out of k std from the mean.
    mx=nanmean(cord(:,1));
    kstdx=nanstd(cord(:,1))*kstd;
    cord(abs(cord(:,1)-mx)>kstdx,:)=NaN;
    
    my=nanmean(cord(:,2));
    kstdy=nanstd(cord(:,2))*kstd;
    
    % make sure this character is on the upper or lower part of the court and
    % clean points which are on the wrong part of the court.
    if my > video_height/2; cord(cord(:,2)<video_height/2,:)=NaN; else cord(cord(:,2)>video_height/2,:)=NaN; end
    
    cord(abs(cord(:,2)-my)>kstdy,:)=NaN;
    
    eval([p '=cord']);
end
% i=intersect(r(:,1),b(:,1));
% r=r(i,:);
% b=b(i,:);
end