% check whether video height and width will change the transformation 

close all
clear all

set_parameters;
load('court_trans.mat');

for p = 4;
    for ci=1:4%1:4;
        
        cond=conditions{ci};
        load([videodir   slash 'Pair' num2str(p) '_' cond '.mat']);
        
        player_r.Centroid(~isnan(player_r.Centroid(:,1)),:)=tformfwd(player_r.Centroid(~isnan(player_r.Centroid(:,1)),:), court_trans);
        player_b.Centroid(~isnan(player_b.Centroid(:,1)),:)=tformfwd(player_b.Centroid(~isnan(player_b.Centroid(:,1)),:), court_trans);
        player_p1.Centroid(~isnan(player_p1.Centroid(:,1)),:)=tformfwd(player_p1.Centroid(~isnan(player_p1.Centroid(:,1)),:), court_trans);
        player_p2.Centroid(~isnan(player_p2.Centroid(:,1)),:)=tformfwd(player_p2.Centroid(~isnan(player_p2.Centroid(:,1)),:), court_trans);
        save([videodir 'Pair' num2str(p) '_' cond '_trans.mat'],'player_r','player_b','player_p1','player_p2','video_width','video_height','vid_FrameRate');
        
    end
end


