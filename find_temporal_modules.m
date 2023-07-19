function [Ci, Q] = find_temporal_modules(rep, epsilon, K, DistModel, delays)

windowStep = 500;
time = 20001:windowStep:100000-(2*windowStep);
for i = 1:length(epsilon)
    if exist(['Analysis/temporal_modules_' delays 'torus_' num2str(epsilon(i)) '_' num2str(rep) '.mat'],'file') == 0
        Ci = cell(1,length(K));
        Q = cell(1,length(K));
    else
        L = load(['Analysis/temporal_modules_' delays 'torus_' num2str(epsilon(i)) '_' num2str(rep) '.mat'],'Ci','Q');
        Ci = L.Ci;
        Q = L.Q;
        clear L
    end

    for j = 1:length(K)
        if isempty(Ci{j})
            if exist(['Simulations/raw_' delays DistModel '_' num2str(epsilon(i)) '_' num2str(rep) '_' num2str(K(j)) '.mat'],'file') == 2
                Ci{j} = zeros(1600,length(time));
                Q{j} = zeros(1,length(time));
                fprintf('Connection Strength: %d, ',K(j))
                tic
                load(['Simulations/raw_' delays 'torus_' num2str(epsilon(i)) '_' num2str(rep) '_' num2str(K(j)) '.mat'])
                for t = 1:length(time)
                    phi = zeros(1600);
                    for p = 1:1600
                        phi(p,:) = ((O(time(t)+(2*windowStep),:) - O(time(t),:)) - (O(time(t)+(2*windowStep),p) - O(time(t),p)));
                    end
                    fC = exp(-abs(phi));
                    [Ci{j}(:,t),Q{j}(t)] = modularity_dir(fC);
                end
                save(['Analysis/temporal_modules_' delays 'torus_' num2str(epsilon(i)) '_' num2str(rep) '.mat'],'Ci','Q')
                toc
            end
        end
    end
end