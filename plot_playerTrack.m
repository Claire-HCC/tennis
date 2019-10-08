set_parameters;

colorVec = linspace(0.3,1, 10000)';
colorVex=flipud(colorVec);
colorVec_r = [colorVec zeros(10000,1) zeros(10000,1) ];
colorVec_b = [zeros(10000,1) zeros(10000,1)  colorVec ];
colorVec_p1 = [zeros(10000,1)  colorVec/2 zeros(10000,1)  ];
colorVec_p2 = [zeros(10000,1)  colorVec/3  zeros(10000,1) ];

for p = 4;
    for ci=1:4;
        
        cond=conditions{ci};
        trackmat=[videodir   slash 'Pair' num2str(p) '_' cond '_trans.mat'];
        
        figure

        [r b p1 p2]=clean_vid_cord(trackmat,2.5);
        scatter(p1(:,1),p1(:,2),[],colorVec_p1(1:length(p1),:));
        hold on
        
        scatter(p2(:,1),p2(:,2),[],colorVec_p2(1:length(p2),:));
        scatter(r(:,1),r(:,2),[],colorVec_r(1:length(r),:));
        scatter(b(:,1),b(:,2),[],colorVec_b(1:length(b),:));
        
        xlim([1 video_width]);
        ylim([1 video_height]);
        
        %colorbar
        hold off
        print(gcf,[expdir slash 'graph' slash 'track_Pair' num2str(p) '_' cond '_trans.png' ],'-dpng');
        close gcf
    end
end

