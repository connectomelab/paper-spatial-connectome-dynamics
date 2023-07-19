function iterate(method, delays)
% method = 1 for track algorithm, 2 for louvain

epsilon = 1:5;
K = 4:4:64;
DistModel = 'torus';

if delays
    dText = 'delays_';
else
    dText = '';
end

if method == 1
    numcores = 4;
    poolobj = gcp('nocreate'); % If no pool, do not create new one.
    if isempty(poolobj)
        parpool(numcores);
    elseif poolobj.NumWorkers ~= numcores
        delete(poolobj)
        parpool(numcores);
    end

    parfor j = 1:16
        fprintf('Iteration: %d\n',j)
        find_temporal_modules(j, epsilon, K, DistModel, dText);
    end
elseif method == 2
    for j = 1:16
        fprintf('Iteration: %d\n',j)
        louvain_modules(j, epsilon, K, DistModel, dText);
    end
else
    fprintf('No method')
end