function interact = module_interaction(rep, epsilon, K, DistModel, delays)

windowStep = 500;
time = 1:windowStep:80000-(2*windowStep);
interact = zeros(5,15,length(time));
for i = 1:length(epsilon)
    load(['F:/Research/Analysis/temporal_modules_' delays DistModel '_' num2str(epsilon(i)) '_' num2str(rep) '.mat'],'Ci')
    load(['F:/Research/networks/net_' DistModel '_noPA_' num2str(epsilon(i)) '_' num2str(rep) '.mat'],'C')
    
    for j = 1:length(K)
        tic
        fprintf('Connection Strength: %d, ',K(j))
        A = trackModules(Ci{j}, C, 0);
        M = mode(A,2);
        
        load(['Simulations/raw_' delays DistModel '_' num2str(epsilon(i)) '_' num2str(rep) '_' num2str(K(j)) '.mat'])
        E = exp(O(20001:end,:).*1i);
        phi = zeros(size(E,1),max(M));
        for m = 1:max(M)
            phi(:,m) = unwrap(angle(mean(E(:,M==m),2)));
        end

        for t = 1:length(time)
            temp_interact = zeros(max(M));
            for p = 1:max(M)
                temp_interact(p,:) = ((phi(time(t)+(2*windowStep),:) - phi(time(t),:)) - (phi(time(t)+(2*windowStep),p) - phi(time(t),p)));
            end
            temp_interact(1:max(M)+1:end) = [];
            interact(i,j,t) = mean(abs(temp_interact));
        end
        toc
    end
end
save(['Analysis/module_interaction_' delays 'torus_' num2str(rep) '.mat'],'interact')