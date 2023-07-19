function create_networks(DistModel, n, d, reps, epsilon, numcores)
% DistModel = 'torus' or 'sheet' describes topology of space in which nodes are embedded
% n = size of network  (nxn nodes)
% d = average out-degree
% reps = number of different random networks to create at each set of parameters
% epsilon = exponent of distance term for network generation
% numcores (optional) - if set generates a parallel pool with given number of threads

if nargin > 5
    poolobj = gcp('nocreate'); % If no pool, do not create new one.
    if isempty(poolobj)
        parpool(numcores);
    elseif poolobj.NumWorkers ~= numcores
        delete(poolobj)
        parpool(numcores);
    end
end

for g = 1:length(epsilon)
    fprintf('Exponent %d: ',g)
    tic
    if nargin > 5
        parfor rep = 1:reps
            filename = ['net_' DistModel '_noPA_' num2str(g) '_' num2str(rep) '.mat'];
            quick_create_network_noPA(n, d, epsilon(g), DistModel, filename);
        end
    else
        for rep = 1:reps
            filename = ['net_' DistModel '_noPA_' num2str(g) '_' num2str(rep) '.mat'];
            quick_create_network_noPA(n, d, epsilon(g), DistModel, filename);
        end
    end
    toc
end