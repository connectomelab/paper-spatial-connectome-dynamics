%% Figure 2

% Part A
load('D:/Research/30s Runs/Simulations/raw_torus_1_1_28.mat')
t = 0:0.0001:25.0033;
E = exp(O(50000:end,:).*1i);
synchrony = abs(mean(E,2));
figure;
line(t, synchrony,'linewidth',2)
line(t([1 250034]),[mean(synchrony) mean(synchrony)],'linewidth',2,'color','k', 'linestyle','--')
line(t([1 250034]),[mean(synchrony)+std(synchrony) mean(synchrony)+std(synchrony)],'linewidth',2,'color','r', 'linestyle','--')
line(t([1 250034]),[mean(synchrony)-std(synchrony) mean(synchrony)-std(synchrony)],'linewidth',2,'color','r', 'linestyle','--')
set(gca, 'xlim',[0 25])
xlabel('Time (s)')
ylabel('Order (r)')

% Part B
load('D:/Research/Analysis/global_synchrony.mat')
K = 4:4:64;
figure;
ax1 = axes();
line(K,mean(sync(:,6,:),3),'linewidth',2,'color','b')
xlabel('Coupling Strength (k)')
ylabel('Global Synchrony')
l = legend('Synchrony','location','northwest');
l.EdgeColor = 'none';
ax2 = axes('color','none','yaxislocation','right','position',get(ax1,'position'));
line(K,mean(metastab(:,6,:),3),'linewidth',2,'color','r')
ylabel('Metastability')
l = legend('Metastability');
l.EdgeColor = 'none';
l.Color = 'none';

% Part C
for eta = 1:6
    for iteration = 1:16
        load(['D:/Research/Paper/networks/net_torus_noPA_' num2str(eta) '_' num2str(iteration)])
        assortativity(eta,iteration) = assortativity_bin(C,1);
        clustering_coef(eta,iteration) = mean(clustering_coef_bd(C));
        [lambda(eta,iteration),efficiency(eta,iteration)] = charpath(distance_bin(C));
    end
end

eta = 5:-1:0;
figure;
ax1 = axes();
line(eta, mean(lambda,2),'linewidth',2, 'color',[137, 0, 83]./255)
ylabel('Characteristic path length')
xlabel('\eta')
l = legend('Characteristic path length','location','northwest');
l.Box = 'off';

ax2 = axes('color','none','yaxislocation','right','position',get(ax1,'position'));
line(eta, mean(clustering_coef,2),'linewidth',2, 'color',[0, 137, 123]./255)
line(eta, mean(efficiency,2),'linewidth',2, 'color',[123, 0, 137]./255)
legend('Clustering coefficient','Global efficiency');

% Part D
load('D:/Research/Simulations/raw_torus_1_1_28.mat')
t = 1:0.0001:8.0033;
figure;
ax1 = subplot(1,4,1:3);
line(t,abs(O(10000:end,2)-O(10000:end,3)) - abs(O(10000,2)-O(10000,3)),'color',[0, 137, 123]./255, 'linewidth', 2)
line(t,abs(O(10000:end,1)-O(10000:end,6)) - abs(O(10000,1)-O(10000,6)),'color',[123, 0, 137]./255, 'linewidth', 2)
line(t,abs(O(10000:end,311)-O(10000:end,1269)) - abs(O(10000,311)-O(10000,1269)),'color',[0, 82, 137]./255, 'linewidth', 2)
line(t([1 70034]),[0 1000],'color',[137, 0, 83]./255, 'linewidth', 2)
set(gca,'xlim',[1 1.5])
l = legend('Phase Locked','Strong Interaction','Weak Interaction','No Interaction','location','northwest');
l.EdgeColor = 'none';
xlabel('Time (s)')
ylabel('Phase Divergence (radians)')

subplot(1,4,4)
plot(exp(-(0:80)./10), 0:80, 'linewidth', 2, 'color', 'k')
set(gca,'ylim',get(ax1,'ylim'), 'yticklabel',{}, 'box','off')
xlabel('Interaction Strength')

%% Figure 3
 
% Part A
load('D:/Research/Analysis/global_synchrony.mat')
K = 4:4:64;
figure;
subplot(1,3,1);
plot(K(1:15),mean(sync(1:15,1:5,:),3),'linewidth',2, 'marker','o')
l = legend('\eta = 5','\eta = 4','\eta = 3','\eta = 2','\eta = 1','location','northwest');
l.EdgeColor = 'none';
xlabel('Coupling Strength')
ylabel('Global Synchrony')

subplot(1,3,2);
plot(K(1:15),mean(metastab(1:15,1:5,:),3),'linewidth',2, 'marker','o')
l = legend('\eta = 5','\eta = 4','\eta = 3','\eta = 2','\eta = 1','location','northwest');
l.EdgeColor = 'none';
xlabel('Coupling Strength')
ylabel('Metastability')

load('D:/Research/Analysis/first_neighbour_synchrony.mat')
subplot(1,3,3);
h = plot(K(1:15),mean(sync(1:15,1:5,:),3),'linewidth',2, 'marker','o');
% hold on
% for i = 1:5
%     errorbar(K(1:15),mean(sync(1:15,i,:),3),std(sync(1:15,i,:),[],3),'color',get(h(i),'color'))
% end
l = legend('\eta = 5','\eta = 4','\eta = 3','\eta = 2','\eta = 1','location','northwest');
l.EdgeColor = 'none';
xlabel('Coupling Strength')
ylabel('First Neighbour Synchrony')

% Part B
load('D:/Research/Analysis/global_synchrony.mat')
k = 4:4:60;
K = repmat(k',16,1);
figure;
c = 5;
ax1 = subplot(1,3,1);
scatter(reshape(sync(1:15,c,:),1,240), reshape(metastab(1:15,c,:),1,240), 100, K, 'filled')
xlabel('Global Synchrony')
ylabel('Metastability')
c = colorbar;
c.Label.String = 'Coupling Strength (k)';
c.FontSize = 12;
c = 3;
ax2 = subplot(1,3,2);
scatter(reshape(sync(1:15,c,:),1,240), reshape(metastab(1:15,c,:),1,240), 100, K, 'filled')
xlabel('Global Synchrony')
c = colorbar;
c.Label.String = 'Coupling Strength (k)';
c.FontSize = 12;
c = 1;
ax3 = subplot(1,3,3);
scatter(reshape(sync(1:15,c,:),1,240), reshape(metastab(1:15,c,:),1,240), 100, K, 'filled')
xlabel('Global Synchrony')
c = colorbar;
c.Label.String = 'Coupling Strength (k)';
c.FontSize = 12;

ylim(1,:) = get(ax1,'ylim');
ylim(2,:) = get(ax2,'ylim');
ylim(3,:) = get(ax3,'ylim');
ylim = [0 max(ylim(:))];

set(ax1,'ylim',ylim)
set(ax2,'ylim',ylim)
set(ax3,'ylim',ylim)


%% Figure 4

nsub = 1600;
n = round(sqrt(nsub));
[coordx,coordy] = meshgrid(1:n,1:n);
for A = 2:2:n
    coordx(A,:) = coordx(A,:) - 0.5;
end
for A = 1:n
    coordy(A,:) = sqrt(0.75) * A * ones(1,n);
end
coorx=reshape(coordx,nsub,1);
coory=reshape(coordy,nsub,1);

figure;
load('D:/Research/Analysis/temporal_modules_torus_1_1.mat')
load('D:/Research/networks/net_torus_noPA_1_1.mat')
Ai = C;

subplot(2,3,1)
C = trackModules(Ci{2}, Ai, 0);
M = mode(C,2);
mTime = mean(C==repmat(M,1,size(C,2)),2);

scatter(coorx,coory,100,mTime,'filled');
set(gca,'color','none','box','off','xtick',[],'ytick',[],'xcolor','none','ycolor','none','clim',[0.5 1])
c = colorbar('Ticks',0.5:0.1:1);
c.Label.String = 'Module stability';
c.Label.FontSize = 16;
c.FontSize = 14;

subplot(2,3,2)
C = trackModules(Ci{7}, Ai, 0);
M = mode(C,2);
mTime = mean(C==repmat(M,1,size(C,2)),2);

scatter(coorx,coory,100,mTime,'filled');
set(gca,'color','none','box','off','xtick',[],'ytick',[],'xcolor','none','ycolor','none','clim',[0.5 1])
c = colorbar('Ticks',0.5:0.1:1);
c.Label.String = 'Module stability';
c.Label.FontSize = 16;
c.FontSize = 14;

subplot(2,3,3)
C = trackModules(Ci{15}, Ai, 0);
M = mode(C,2);
mTime = mean(C==repmat(M,1,size(C,2)),2);

scatter(coorx,coory,100,mTime,'filled');
set(gca,'color','none','box','off','xtick',[],'ytick',[],'xcolor','none','ycolor','none','clim',[0.5 1])
c = colorbar('Ticks',0.5:0.1:1);
c.Label.String = 'Module stability';
c.Label.FontSize = 16;
c.FontSize = 14;

load('D:/Research/Analysis/temporal_modules_torus_1_10.mat')
load('D:/Research/networks/net_torus_noPA_1_10.mat')

subplot(2,3,4)
C = trackModules(Ci{7}, C, 0);
M = mode(C,2);
mTime = mean(C==repmat(M,1,size(C,2)),2);

scatter(coorx,coory,100,mTime,'filled');
set(gca,'color','none','box','off','xtick',[],'ytick',[],'xcolor','none','ycolor','none','clim',[0.5 1])
c = colorbar('Ticks',0.5:0.1:1);
c.Label.String = 'Module stability';
c.Label.FontSize = 16;
c.FontSize = 14;

load('D:/Research/Analysis/temporal_modules_torus_3_10.mat')
load('D:/Research/networks/net_torus_noPA_3_10.mat')

subplot(2,3,5)
C = trackModules(Ci{7}, C, 0);
M = mode(C,2);
mTime = mean(C==repmat(M,1,size(C,2)),2);

scatter(coorx,coory,100,mTime,'filled');
set(gca,'color','none','box','off','xtick',[],'ytick',[],'xcolor','none','ycolor','none','clim',[0.5 1])
c = colorbar('Ticks',0.5:0.1:1);
c.Label.String = 'Module stability';
c.Label.FontSize = 16;
c.FontSize = 14;

load('D:/Research/Analysis/temporal_modules_torus_5_10.mat')
load('D:/Research/networks/net_torus_noPA_5_10.mat')

subplot(2,3,6)
C = trackModules(Ci{7}, C, 0);
M = mode(C,2);
mTime = mean(C==repmat(M,1,size(C,2)),2);

scatter(coorx,coory,100,mTime,'filled');
set(gca,'color','none','box','off','xtick',[],'ytick',[],'xcolor','none','ycolor','none','clim',[0.5 1])
c = colorbar('Ticks',0.5:0.1:1);
c.Label.String = 'Module stability';
c.Label.FontSize = 16;
c.FontSize = 14;


%% Figure 5

nsub = 1600;
n = round(sqrt(nsub));
[coordx,coordy] = meshgrid(1:n,1:n);
for A = 2:2:n
    coordx(A,:) = coordx(A,:) - 0.5;
end
for A = 1:n
    coordy(A,:) = sqrt(0.75) * A * ones(1,n);
end
coorx=reshape(coordx,nsub,1);
coory=reshape(coordy,nsub,1);

figure;
load('D:/Research/Analysis/temporal_modules_torus_1_1.mat')
load('D:/Research/networks/net_torus_noPA_1_1.mat')

subplot(5,4,[1 5]);
[~, shared] = trackModules(Ci{2}, C, 0);
scatter(coorx,coory,100,mean(shared,2),'filled');
set(gca,'color','none','box','off','xtick',[],'ytick',[],'xcolor','none','ycolor','none','clim',[0 1])
c = colorbar;
c.Label.String = 'Participation Coefficient';
c.FontSize = 12;

subplot(5,4,[2 6]);
[~, shared] = trackModules(Ci{7}, C, 0);
scatter(coorx,coory,100,mean(shared,2),'filled');
set(gca,'color','none','box','off','xtick',[],'ytick',[],'xcolor','none','ycolor','none','clim',[0 1])
c = colorbar;
c.Label.String = 'Participation Coefficient';
c.FontSize = 12;

subplot(5,4,[3 7]);
[~, shared] = trackModules(Ci{15}, C, 0);
scatter(coorx,coory,100,mean(shared,2),'filled');
set(gca,'color','none','box','off','xtick',[],'ytick',[],'xcolor','none','ycolor','none','clim',[0 1])
c = colorbar;
c.Label.String = 'Participation Coefficient';
c.FontSize = 12;

subplot(5,4,[4 8]);
load('D:/Research/Analysis/temporal_modules_torus_4_1.mat')
load('D:/Research/networks/net_torus_noPA_4_1.mat')
[~, shared] = trackModules(Ci{7}, C, 0);
scatter(coorx,coory,100,mean(shared,2),'filled');
set(gca,'color','none','box','off','xtick',[],'ytick',[],'xcolor','none','ycolor','none','clim',[0 1])
c = colorbar;
c.Label.String = 'Participation Coefficient';
c.FontSize = 12;
colormap(flipud(colormap))

load('D:/Research/Analysis/sharedModules.mat')
subplot(5,4,[9 10 13 14 17 18]);
plot(K,mean(moduleSynchrony,3),'linewidth',2,'marker','o')
xlabel('Coupling Strength (k)')
ylabel('Participation Coefficient')
l = legend('\eta = 5','\eta = 4','\eta = 3','\eta = 2','\eta = 1','location','northeast');
l.EdgeColor = 'none';

load('D:/Research/Analysis/sharedModules.mat')
subplot(5,4,[11 12 15 16 19 20]);
plot(K,mean(moduleStability,3),'linewidth',2,'marker','o')
xlabel('Coupling Strength (k)')
ylabel('Variation in Participation Coefficient')
l = legend('\eta = 5','\eta = 4','\eta = 3','\eta = 2','\eta = 1','location','northeast');
l.EdgeColor = 'none';


%% Figure 6

% Part A
load('D:/Research/Analysis/temporal_modules_torus_1_10.mat')
load('D:/Research/networks/net_torus_noPA_1_10.mat')
C = trackModules(Ci{7}, C, 0);
M = mode(C,2);
mTime = mean(C==repmat(M,1,size(C,2)),2);
nsub = 1600;
n = round(sqrt(nsub));
[coordx,coordy] = meshgrid(1:n,1:n);
for A = 2:2:n
coordx(A,:) = coordx(A,:) - 0.5;
end
for A = 1:n
coordy(A,:) = sqrt(0.75) * A * ones(1,n);
end
coorx=reshape(coordx,nsub,1);
coory=reshape(coordy,nsub,1);
load('redbluecmap.mat')
figure;
scatter(coorx,coory,100,mTime,'filled');
set(gca,'color','none','box','off','xtick',[],'ytick',[],'xcolor','none','ycolor','none')
colormap(cmap);

% Part B
load('D:/Research/Analysis/temporal_modules_torus_1_10.mat')
load('D:/Research/networks/net_torus_noPA_1_10.mat')
load('D:/Research/Simulations/raw_torus_1_10_28.mat')
C = trackModules(Ci{7}, C, 0);
M = mode(C,2);

t = 0:0.0001:7.0033;
E = exp(O(10000:end,:).*1i);
n = 100;
cmap = [0, 82, 137 ; 137, 0, 83 ; 0, 137, 123 ; 123, 0, 137] ./ 255;
figure;
ax1 = axes();
smoothSync = zeros(1,size(E,1)-n);
for j = 1:max(M)
    sync = abs(mean(E(:,M==j),2));
    for x = 1:length(sync)-n
        smoothSync(x) = mean(sync(x:x+n));
    end
    line(t(1:end-n),smoothSync,'linewidth',2,'color',cmap(j,:))
end
xlabel('Time (s)')
ylabel('Module Synchrony (r)')

ax2 = axes('color','none','yaxislocation','right','position',get(ax1,'position'));
pv = abs(unwrap(angle(mean(E(:,M==1),2))) - unwrap(angle(mean(E(:,M==2),2))));
smoothPV = zeros(1,length(pv)-n);
for x = 1:length(sync)-n
    smoothPV(x) = mean(pv(x:x+n));
end
line(t(1:end-n),smoothPV,'linewidth',2,'color',cmap(3,:))
ylabel('Phase Difference (radians)')
set(gca,'YColor',cmap(3,:))

% Part C
load('D:/Research/Analysis/interaction_strength.mat')
K = 4:4:60;
for e = 1:5
    mi = zeros(1,15);
    for k = 1:15
        temp = [];
        for i = 1:16
            temp = [temp interact{e,i,k}];
            mi(k) = mean(abs(temp(~isnan(temp))));
        end
    end
    interaction(:,e) = -log(mi);
end
figure;
plot(K,interaction,'linewidth',2, 'marker', 'o')
xlabel('Coupling strength (k)')
ylabel('Module interaction strength')
l = legend('\eta = 5','\eta = 4','\eta = 3','\eta = 2','\eta = 1','location','northwest');
l.EdgeColor = 'none';

% Part D
Ci = [ones(1,50) 2.*ones(1,50)];
cmap = [255 159 159; 159 159 255] ./ 255;
nsub = 100;
n = 10;

[coordx,coordy] = meshgrid(1:n,1:n);
for A = 2:2:n
    coordx(A,:) = coordx(A,:) - 0.5;
end
for A = 1:n
    coordy(A,:) = sqrt(0.75) * A * ones(1,n);
end
coorx=reshape(coordx,nsub,1);
coory=reshape(coordy,nsub,1);

figure;
subplot(1,2,1);
C = quick_create_network_noPA(10, 8, -5, 'sheet');

for A = 1:max(Ci)
    line(coorx(Ci==A),coory(Ci==A),'linestyle','none','marker','o','markerfacecolor',cmap(A,:),'markeredgecolor',cmap(A,:),'markersize',8)
end

for i = 1:nsub
    for j = 1:nsub
        if C(i,j) > 0
            if Ci(i) == Ci(j), line([coorx(i) coorx(j)],[coory(i) coory(j)],'color',cmap(Ci(i),:)); else line([coorx(i) coorx(j)],[coory(i) coory(j)],'color','k', 'linewidth', 2); end
        end
    end
end
set(gca,'box','off','color','none','xcolor','none','ycolor','none','xtick',[],'ytick',[])

subplot(1,2,2);
C = quick_create_network_noPA(10, 8, -2, 'sheet');

for A = 1:max(Ci)
    line(coorx(Ci==A),coory(Ci==A),'linestyle','none','marker','o','markerfacecolor',cmap(A,:),'markeredgecolor',cmap(A,:),'markersize',8)
end

for i = 1:nsub
    for j = 1:nsub
        if C(i,j) > 0
            if Ci(i) == Ci(j), line([coorx(i) coorx(j)],[coory(i) coory(j)],'color',cmap(Ci(i),:)); else line([coorx(i) coorx(j)],[coory(i) coory(j)],'color','k', 'linewidth', 2); end
        end
    end
end
set(gca,'box','off','color','none','xcolor','none','ycolor','none','xtick',[],'ytick',[])

% Part E
load('D:/Research/Analysis/participation.mat')
figure;
plot(K(1:15), mean(participation(1:15,:,:),3), 'linewidth', 2, 'marker', 'o')
l = legend('\eta = 5','\eta = 4','\eta = 3','\eta = 2','\eta = 1','location','northeast');
l.EdgeColor = 'none';
xlabel('Coupling Strength (k)')
ylabel('Participation Coefficient')

%% Data analysis

%% Figure 6

% Part E

eta = 1:6;
participation = zeros(16,6,16);
for e = 1:length(eta)
    tic
    fprintf('%d: ',e)
    for iteration = 1:16
        fprintf('%d, ',iteration)
        load(['D:/Research/Analysis/temporal_modules_torus_' num2str(eta(e)) '_' num2str(iteration) '.mat'])
        load(['D:/Research/networks/net_torus_noPA_' num2str(eta(e)) '_' num2str(iteration) '.mat'])
        parfor i = 1:16
            A = trackModules(Ci{i}, C, 0);
            M = mode(A,2);
            internal = 0;
            external = 0;
            for j = 1:1600
                internal = internal + sum(C(j,M==M(j)));
                external = external + sum(C(j,M~=M(j)));
            end
            if max(M) > 1
                participation(i,e,iteration) = external ./ (internal + external);
            else
                participation(i,e,iteration) = NaN;
            end
        end
    end
    toc
end
participation(:,6,:) = [];
K = 4:4:64;
save participation
