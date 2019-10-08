set_parameters;


for p = 4;
    for ci=1:4;
        
        cond=conditions{ci};
        load([videodir   slash 'Pair' num2str(p) '_' cond '_trans.mat']);
        r=player_r.Centroid;
        b=player_b.Centroid;
        
        
        i=find(~isnan(r(:,1)) & r(:,1)>0 & ~isnan(b(:,1)) &  b(:,1)>0);
         r_ind=sub2ind([video_height+500 video_width+500 ], r(i,2), r(i,1));
          b_ind=sub2ind([video_height+500 video_width+500 ], b(i,2), b(i,1));
    end
end