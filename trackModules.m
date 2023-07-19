function C = trackModules(Ci, Ai, verbose)

C = zeros(size(Ci));
C(:,1) = Ci(:,1);
for i = 2:size(Ci,2)
    if max(Ci(:,i)) >= max(C(:,i-1))
        shared = zeros(max(Ci(:,i)),max(C(:,i-1)));
        for j = 1:max(Ci(:,i))
            for k = 1:max(C(:,i-1))
                shared(j,k) = sum(sum(C(:,i-1)==k & Ci(:,i)==j));
            end
        end
        existingModules = zeros(1,max(C(:,i-1)));
        assignedModules = zeros(1,max(C(:,i-1)));
        rowIndex = 1:max(Ci(:,i));
        colIndex = 1:max(C(:,i-1));
        for j = 1:max(C(:,i-1))
            [row,col] = iMax(shared);
            C(Ci(:,i)==rowIndex(row),i) = colIndex(col);
            existingModules(j) = colIndex(col);
            assignedModules(j) = rowIndex(row);
            shared(row,:) = [];
            rowIndex(row) = [];
            shared(:,col) = [];
            colIndex(col) = [];
        end
        if max(Ci(:,i)) > max(C(:,i-1))
            toBeAssigned = setdiff(1:max(Ci(:,i)),assignedModules);
            availableModules = setdiff(1:max(Ci(:,i)),existingModules);
            for j = 1:length(toBeAssigned)
                C(Ci(:,i)==toBeAssigned(j),i) = availableModules(j);
            end
        end
    else
        shared = zeros(max(Ci(:,i)),max(C(:,i-1)));
        for j = 1:max(Ci(:,i))
            for k = 1:max(C(:,i-1))
                shared(j,k) = sum(sum(C(:,i-1)==k & Ci(:,i)==j));
            end
        end
        rowIndex = 1:max(Ci(:,i));
        colIndex = 1:max(C(:,i-1));
        for j = 1:max(Ci(:,i))
            [row,col] = iMax(shared);
            C(Ci(:,i)==rowIndex(row),i) = colIndex(col);
            shared(row,:) = [];
            rowIndex(row) = [];
            shared(:,col) = [];
            colIndex(col) = [];
        end
    end
end

% M = mode(C,2);
% mTime = mean(C==repmat(M,1,size(C,2)),2);
% stability = mean(mTime).*max(C(:));
% 
% shared = zeros(size(C));
% 
% for j = 1:size(C,2)
%     for i = 1:1600
%         index = Ai(i,:) == 1 | Ai(:,i)' == 1;
%         shared(i,j) = sum(C(index,j) == C(i,j)) ./ (C(i,j).*sum(index));
%     end
% end
% mStab = std(shared,[],2);
% moduleSynchrony = mean(shared(:));
% moduleStability = mean(mStab);
% moduleStabilityVar = std(mStab);

if verbose > 0
    n = 40;
    nsub = n^2;
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
    scatter(coorx,coory,100,mean(shared,2),'filled');
    colorbar;
    title('Mean Common Modules')
    
    figure;
    scatter(coorx,coory,100,std(shared,[],2),'filled');
    colorbar;
    title('STD Common Modules')
    
    figure;
    line(1:size(C,2),mean(shared,1),'linewidth',2,'color','b')
    line(1:size(C,2),std(shared,[],1),'linewidth',2,'color','r')
    set(gca,'Ylim',[0 1])
    
    if verbose == 2
        writerObj = VideoWriter('test.avi','Motion JPEG AVI');
        writerObj.FrameRate = 4;
        open(writerObj);
        f = figure;

        colors = jet(max(C(:)));
        cmap = zeros(1600,3);
        for j = 1:max(C(:,1))
            cmap(C(:,1) == j,:) = repmat(colors(j,:),sum(C(:,1) == j),1);
        end
        scatter(coorx,coory,100,cmap,'filled');
        axis tight
        set(gca,'nextplot','replacechildren');
        set(gcf,'Renderer','zbuffer');
        for i = 1:size(C,2)
            cmap = zeros(1600,3);
            for j = 1:max(C(:,i))
                cmap(C(:,i) == j,:) = repmat(colors(j,:),sum(C(:,i) == j),1);
            end
            scatter(coorx,coory,100,cmap,'filled');
            frame = getframe(f);
            writeVideo(writerObj,frame);
        end
        close(writerObj);
        close(f);
    end
end


function [row,col] = iMax(A)
    [p,q] = max(A,[],2);
    [~,s] = max(p);
    row = s;
    col = q(s);