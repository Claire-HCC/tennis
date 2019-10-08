function new_cord=clean_vid_cord(cord,kstd);

set_parameters;

% clean points out of screen
cord(cord(:,1)<0 | cord(:,1)>video_width | cord(:,2)<0 | cord(:,2)>video_height,:)=NaN;

% clean points out of k std from the mean.
mx=nanmean(cord(:,1));
kstdx=nanstd(cord(:,1))*kstd;
cord(abs(cord(:,1)-mx)>kstdx,:)=NaN;

my=nanmean(cord(:,2));
kstdy=nanstd(cord(:,2))*kstd;
cord(abs(cord(:,2)-my)>kstdy,:)=NaN;

new_cord=cord;

end