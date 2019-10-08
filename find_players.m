% one video clip taks around 15-20 min
clear all
set_parameters;
figure

p=4;

for ci=1;%1:4;
    tic;
    cond=conditions{ci};
    
    vidObj = VideoReader([videodir 'Pair' num2str(p) '_' cond '.mp4']);
    framen=double(int32(vidObj.Duration*vidObj.FrameRate));
    
    fi=1;
    
    while hasFrame(vidObj)
        
        A=readFrame(vidObj);
        
        [bw_b,~]=maskRGB(A,'b');
        [bw_r,~]=maskRGB(A,'r');
        [bw_p,~]=maskRGB(A,'p');
        [bw_y,~]=maskRGB(A,'y');
        
        bl_b = bwlabel(bw_b, 4);
        bl_r = bwlabel(bw_r, 4);
        bl_p = bwlabel(bw_p, 4);
        bl_y = bwlabel(bw_y, 4);
        
        
        if max(bl_b(:)) >=1 & max(bl_r(:)) >=1 & max(bl_p(:))>=2 & max(bl_y(:)) >=1;
            stats_b = regionprops(bl_b, 'BoundingBox', 'Centroid','Area');
            stats_r = regionprops(bl_r, 'BoundingBox', 'Centroid','Area');
            stats_p = regionprops(bl_p, 'BoundingBox', 'Centroid','Area');
            stats_y = regionprops(bly, 'BoundingBox', 'Centroid','Area');
            
            di_b = 1;
            di_r = 1;
            di_y=1;
            
            % 符合以下條件極有可能是按鍵精靈
            if ~(stats_r(di_r).Area > 60 &  stats_r(di_r).Centroid(1) > 1000 & stats_r(di_r).Centroid(2) < 200) ;
                player_r.BoundingBox(fi,:)=stats_r(di_r).BoundingBox;
                player_r.Centroid(fi,:)=stats_r(di_r).Centroid;
                player_r.Area(fi,:)=stats_r(di_r).Area;
            end
            
            player_b.BoundingBox(fi,:)=stats_b(di_b).BoundingBox;
            player_b.Centroid(fi,:)=stats_b(di_b).Centroid;
            player_b.Area(fi,:)=stats_b(di_b).Area;
            
                 ball_y.BoundingBox(fi,:)=stats_y(di_y).BoundingBox;
            ball_y.Centroid(fi,:)=stats_y(di_y).Centroid;
            ball_y.Area(fi,:)=stats_y(di_y).Area;
            
            % find the pink characters controled by pc.
            % find the two largest pink blob
            pa=sort([stats_p.Area],'descend');
            pai=find([stats_p.Area]>=pa(2));
            
            cs=reshape([stats_p.Centroid],length(stats_p),2);
            
            for c = 1:2;
                
                % choose the the largest two pink blobs
                pi=pai(c);
                
                % if this is not the fist non-empty frame
                if exist('player_p1');
                    eval(['player_p=player_p' num2str(c) ';']);
                    
                    % find the index of the last pink blob
                    k=find(~isnan(player_p.Centroid(:,1)));
                    k=k(end);
                    
                    % compute the ditance between the current blobs and the last
                    % chosen blob
                    pd=pdist2(player_p.Centroid(k,:),cs,'euclidean');
                    
                    % find pink blobs whic is among the two largest ones and
                    % with 50 pixel of the last one
                    p_ad_i=intersect(pai,find(pd<100));
                    
                    % if there are no blobs satisfying the above criterion. Put
                    % NaN
                    % if one blob satisfy the criterions, choose the one
                    % if there are multiple candidates, choose the one with
                    % moving direction most similar to previous direction
                    if length(p_ad_i) == 1;
                        pi=p_ad_i;
                    elseif length(k) >1;
                        old_temp=player_p.Centroid(k,:)- player_p.Centroid(k-1,:);
                        old_dir=atan2(old_temp(:,2),old_temp(:,1));
                        
                        current_temp=cs-repmat(player_p.Centroid(k,:),length(stats_p),1);
                        current_dirs=atan2(current_temp(:,2),current_temp(:,1));
                        
                        pi=intersect(p_ad_i,find(current_dirs==min(current_dirs)));
                    end
                end
                eval(['p' num2str(c) '_i=pi;']);
            end
            
            if ~isempty(p1_i);
                player_p1.BoundingBox(fi,:)=stats_p(p1_i).BoundingBox;
                player_p1.Centroid(fi,:)=stats_p(p1_i).Centroid;
                player_p1.Area(fi,:)=stats_p(p1_i).Area;
            end
            if ~isempty(p2_i);
                player_p2.BoundingBox(fi,:)=stats_p(p2_i).BoundingBox;
                player_p2.Centroid(fi,:)=stats_p(p2_i).Centroid;
                player_p2.Area(fi,:)=stats_p(p2_i).Area;
            end
            
            % show the Centroid
            %             if sum([di_b di_r p1_i p2_i]>0) == 4;
            %                 fprintf('frame %d\n',fi);
            %                 imshow(A);
            %                 hold on;
            %                 plot(player_r.Centroid(fi,1),player_r.Centroid(fi,2),'k+','MarkerSize',30,'linewidth',3) ;
            %                 plot(player_b.Centroid(fi,1),player_b.Centroid(fi,2),'k+','MarkerSize',30,'linewidth',3) ;
            %                 plot(player_p1.Centroid(fi,1),player_p1.Centroid(fi,2),'k+','MarkerSize',30,'linewidth',3) ;
            %                 plot(player_p2.Centroid(fi,1),player_p2.Centroid(fi,2),'k+','MarkerSize',30,'linewidth',3) ;
            %                 hold off
            %                 pause
            %             end
            
            fi=fi+1;
            clear stats bl d p1_i p2_i di_b di_r;
            
        end
    end
    
    toc;
    player_r.Centroid(player_r.Centroid==0)=NaN;
    % 0 of y-axis is on top of the image for the Centroid coordinate. the cordinate catch from the image
    player_r.Centroid(:,2)=vidObj.Height- player_r.Centroid(:,2);
    
    player_b.Centroid(player_b.Centroid==0)=NaN;
    player_b.Centroid(:,2)=vidObj.Height- player_b.Centroid(:,2);
    
    player_p1.Centroid(player_p1.Centroid==0)=NaN;
    % 0 of y-axis is on top of the image for the Centroid coordinate. the cordinate catch from the image
    player_p1.Centroid(:,2)=vidObj.Height- player_p1.Centroid(:,2);
    
    player_p2.Centroid(player_p2.Centroid==0)=NaN;
    % 0 of y-axis is on top of the image for the Centroid coordinate. the cordinate catch from the image
    player_p2.Centroid(:,2)=vidObj.Height- player_p2.Centroid(:,2);
    
    video_width=vidObj.Width;
    video_height=vidObj.Height;
    vid_FrameRate=vidObj.FrameRate;

    save([videodir 'Pair' num2str(p) '_' cond '_test.mat'],'player_r','player_b', 'player_p1' ,'player_p2','ball_y','video_width','video_height','vid_FrameRate');
    clear player_r player_b player_p1 playre_p2
end

close all;
clear all;



