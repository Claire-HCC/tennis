% mutual information of angle distribution
% angle a of each player to a reference point as time series for crp
clear all
close all

set_parameters;

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
        
        % coordinate relative to the centr of the tennis court
        r1=r1-repmat([video_width1/2 video_height1/2],length(r1),1);
        r2=r2-repmat([video_width2/2 video_height2/2],length(r1),1);
        b1=b1-repmat([video_width1/2 video_height1/2],length(r1),1);
        b2=b2-repmat([video_width2/2 video_height2/2],length(r1),1);
        
        % calculate angle to the center
        r1_ang = atan2d(r1(:,2),r1(:,1)) - atan2d(1,0); r1_ang(abs(r1_ang)>180)=mod(r1_ang(abs(r1_ang)>180),180);
        r2_ang = atan2d(r2(:,2),r2(:,1)) - atan2d(1,0); r2_ang(abs(r2_ang)>180)=mod(r2_ang(abs(r2_ang)>180),180);
        b1_ang = atan2d(b1(:,2),b1(:,1)) - atan2d(1,0); b1_ang(abs(b1_ang)>180)=mod(b1_ang(abs(b1_ang)>180),180);
        b2_ang = atan2d(b2(:,2),b2(:,1)) - atan2d(1,0); b2_ang(abs(b2_ang)>180)=mod(b2_ang(abs(b2_ang)>180),180);
        
        % calculate distance to the center
        r1_d=sqrt(nansum(r1.^2,2));
        r2_d=sqrt(nansum(r2.^2,2));
        b1_d=sqrt(nansum(b1.^2,2));
        b2_d=sqrt(nansum(b2.^2,2));
        
        % yticklabels of hist2 is reversed somehow...
        figure('units','centimeter','papersize',[30 15],'paperposition',[0 0 30 15],'position',[0 15 30 15]);
        subplot(1,3,1); hist2(r1_ang,b1_ang); zlim([0 0.3]); title(cond1);
        subplot(1,3,2); hist2(r2_ang,b2_ang); zlim([0 0.3]); title(cond2);
        subplot(1,3,3); hist2(r1_ang,b2_ang); zlim([0 0.3]); title(['Pseudo-Pair']);
        tightfig;
        
        % find the number of bin which maximize the difference between real and
        % fake pair.
        %         m_good=[];
        %         m_pseudo=[];
        %         for k = 10:10:round(length(r1)/5,-2);
        %             m_temp=mi(r1_ang,b1_ang,k,0);
        %             m_good(end+1)=m_temp(2,1);
        %             m_temp=mi(r1_ang,b2_ang,k,0);
        %             m_pseudo(end+1)=m_temp(2,1);
        %         end
        %         mr=(m_good./m_pseudo);
        %         bn=find(mr==max(mr))*10;
        %         figure
        %         plot(m_good); hold on; plot(m_pseudo); hold off;
        bn=10;
        
        r1_ang_bin = discretize(r1_ang,bn);
        r2_ang_bin = discretize(r2_ang,bn);
        b1_ang_bin = discretize(b1_ang,bn);
        b2_ang_bin = discretize(b2_ang,bn);
        
        r1_d_bin = discretize(r1_d,bn);
        r2_d_bin = discretize(r2_d,bn);
        b1_d_bin = discretize(b1_d,bn);
        b2_d_bin = discretize(b2_d,bn);
        
        i1=[];
        i2=[];
        for w = 10:10:3003;
            i1(end+1) = mean(migram(r1_ang_bin,b1_ang_bin,0,w,0,w));
            i2(end+1) = mean(migram(r1_ang_bin,b2_ang_bin,0,w,0,w));
        end
        i=i1./i2
        w=find(i==max(i))*10;
        
        % Using the following analyis, I find that mutual information is highest
        % wihtou delay. The beginning of the video should be croppd. Mi is low
        % there.
        
        % i = migram(a,b,maxlag,window,noverlap,nbins)
        delay=10;
        w=20;
        noverlap=0;
        nbins=10;
        m_thr=0.6;
        
        i1=migram(r1_ang_bin,b1_ang_bin,delay,w,noverlap,nbins);
        i2=migram(r2_ang_bin,b2_ang_bin,delay,w,noverlap,nbins);
        i3=migram(r1_ang_bin,b2_ang_bin,delay,w,noverlap,nbins);
        
        pnames={cond1,cond2,'Pseudo Pair'};
        s=max(size(i1))*3;
        
        figure('units','centimeter','papersize',[30 15],'paperposition',[0 0 30 15],'position',[0 10 30 15]);
        subplot(1,3,1);
        i=im2bw(i1,m_thr);
        imshow(imresize(i,[s s]));
        title(pnames{1});
        subplot(1,3,2);
        i=im2bw(i2,m_thr);
        imshow(imresize(i,[s s]));
        title(pnames{2});
        subplot(1,3,3);
        i=im2bw(i3,m_thr);
        imshow(imresize(i,[s s]));
        title(pnames{3});
        tightfig;
        
        delay=100;
        w=500;
        noverlap=0;
        nbins=10;
        i1=migram(r1_ang_bin,b1_ang_bin,delay,w,noverlap,nbins);
        i2=migram(r2_ang_bin,b2_ang_bin,delay,w,noverlap,nbins);
        i3=migram(r1_ang_bin,b2_ang_bin,delay,w,noverlap,nbins);
        
        figure('units','centimeter','papersize',[30 15],'paperposition',[0 0 30 15],'position',[0 10 30 15]);
        for mi_pair=1:3;
            eval(['i=i' num2str(mi_pair)]);
            subplot(1,3,mi_pair);
            col=[1 0 0]./size(i,2);
            for wi=1:size(i,2);
                x=-(delay):(delay);
                y=i(:,wi);
                plot(x,y,'color',col*wi);
                hold on
                mx=find(y==max(y));
                line(x(mx),y(mx),...
                    'marker','.',...
                    'markersize',20,...
                    'markeredgecolor',col*wi,...
                    'linestyle','none');
                ylim([0 1])
            end
            hold off
            xlabel('delay(s)');
            xticks([min(x) 0 max(x)]);
            xticklabels([min(x)*(1000/vid_FrameRate1)/1000 0 max(x)*(1000/vid_FrameRate1)/1000]);
            title(pnames{mi_pair});
            
        end
        tightfig;
        
        
        %    crp(r1_ang_bin(500:(end-500)),b1_ang_bin(500:(end-500)));
        %          crp(r2_ang_bin(500:(end-500)),b2_ang_bin(500:(end-500)));
        %   crp(r1_ang_bin(500:(end-500)),b2_ang_bin(500:(end-500)));
        
        ang1 = atan2d(r1(:,2),r1(:,1)) -atan2d(b1(:,2),b1(:,1));
        ang2= atan2d(r2(:,2),r2(:,1)) -atan2d(b2(:,2),b2(:,1));
        ang3 =  atan2d(r1(:,2),r1(:,1)) -atan2d(b2(:,2),b2(:,1)); % Pseudo Pair pair
        
        % calculate distance to the center
        d1=sqrt(nansum((r1-b1).^2,2));
        d2=sqrt(nansum((r2-b2).^2,2));
        d3=sqrt(nansum((r1-b2).^2,2)); % Pseudo Pair
        
        
        n=length(r1);
        pnames={cond1,cond2,'Pseudo Pair'};
        
        figure('units','centimeter','papersize',[30 15],'paperposition',[0 0 30 15],'position',[0 10 30 15]);
        bn=10;
        binCtrs=(180/bn/2):(180/bn):(180-180/bn/2);
        for i=1:3;
            subplot(1,3,i);
            eval(['ang=ang' num2str(i)]);
            h=histogram(abs(ang),bn);
            prob = h.Values /n;
            bar(binCtrs,prob,'hist');
            ylim([0 0.4]);
            title({pnames{i},['entropy=' num2str(round(entropy(prob'),2))]},'fontsize',14);
        end
        tightfig;
        
        figure('units','centimeter','papersize',[30 15],'paperposition',[0 0 30 15],'position',[0 10 30 15]);
        bn=10;
        binCtrs=(max(1500)/bn/2):(1500/bn):(1500-bn/2);
        for i=1:3;
            subplot(1,3,i);
            eval(['d=d' num2str(i)]);
            h=histogram(abs(d),bn);
            prob = h.Values /n;
            bar(binCtrs,prob,'hist');
            ylim([0 0.5]);
            title({pnames{i},['entropy=' num2str(round(entropy(prob'),2))]},'fontsize',14);
        end
        tightfig;
        
        %         bn=10;
        %         figure
        %         subplot(1,3,1);
        %         h=histogram((ang1),bn);
        %         prob = h.Values /n;
        %         bar(h.BinEdges(1:(end-1))+180/bn/2,prob,'hist');
        %         ylim([0 0.5]);
        %         title({'coop1_r vs. b',['entropy=' num2str(round(entropy(prob'),2))]},'fontsize',14);
        %
        %         subplot(1,3,2);
        %         h=histogram((r1_ang),bn);
        %         prob = h.Values /n;
        %          bar(h.BinEdges(1:(end-1))+180/bn/2,prob,'hist');
        %         ylim([0 0.5]);
        %         title({'coop1 r',['entropy=' num2str(round(entropy(prob'),2))]},'fontsize',14);
        %
        %           subplot(1,3,3);
        %          h=histogram((b1_ang),bn);
        %         prob = h.Values /n;
        %           bar(h.BinEdges(1:(end-1))+180/bn/2,prob,'hist');
        %         ylim([0 0.5]);
        %         title({'coop1 b',['entropy=' num2str(round(entropy(prob'),2))]},'fontsize',14);
        
        
        
        
    end
end
