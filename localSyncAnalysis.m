function [sync, metastab] = localSyncAnalysis(delays)

numcores = 2;
poolobj = gcp('nocreate'); % If no pool, do not create new one.
if isempty(poolobj)
    parpool(numcores);
elseif poolobj.NumWorkers ~= numcores
    delete(poolobj)
    parpool(numcores);
end

DistModel = 'torus';
eta = 1:5;
K = 4:4:60;
iterations = 1:16;

sync = zeros(length(K),length(eta),length(iterations));
metastab = zeros(length(K),length(eta),length(iterations));

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
                    m = load(['F:/Research/networks/net_' DistModel '_noPA_' num2str(eta(j)) '_' num2str(k) '.mat'],'C');
                    E = exp(l.O(20000:end,:).*1i);
                    temp = zeros(1,1600);
                    for x = 1:1600
                        index = m.C(x,:)' == 1 | m.C(:,x) == 1;
                        temp(x) = mean(abs(mean(E(:,index),2)));
                    end
                    sync(i,j,k) = mean(temp);
                catch
                    continue
                end
            end
        end
        toc
    end
end