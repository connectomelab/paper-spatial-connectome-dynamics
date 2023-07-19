function [sync, metastab] = basicSyncAnalysis(sync, metastab)

numcores = 2;
poolobj = gcp('nocreate'); % If no pool, do not create new one.
if isempty(poolobj)
    parpool(numcores);
elseif poolobj.NumWorkers ~= numcores
    delete(poolobj)
    parpool(numcores);
end

DistModel = 'torus';
delays = true;
eta = 1:5;
K = 4:4:60;
iterations = 1:16;

if nargin == 0
    sync = zeros(length(K),length(eta),length(iterations));
    metastab = zeros(length(K),length(eta),length(iterations));
end

dText = '_';
if delays
    dText = '_delays_';
end

for i = 1:length(K)
    fprintf('Connection Strength: %d, ',K(i))
    for j = 1:length(eta)
        fprintf('Eta: %d, ',eta(j))
        tic
        parfor k = 1:length(iterations)
            if sync(i,j,k) == 0
                try
                    l = load(['F:/Research/Simulations/raw' dText DistModel '_' num2str(eta(j)) '_' num2str(k) '_' num2str(K(i)) '.mat'],'O');
                    r = abs(mean(exp(l.O(20000:end,:).*1i),2));
                    sync(i,j,k) = mean(r);
                    metastab(i,j,k) = std(r);
                catch
                    continue
                end
            end
        end
        toc
    end
end
