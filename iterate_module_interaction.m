function iterate_module_interaction(delays)
% method = 1 for track algorithm, 2 for louvain

epsilon = 1:5;
K = 4:4:60;
DistModel = 'torus';

if delays
    dText = 'delays_';
else
    dText = '';
end

numcores = 2;
poolobj = gcp('nocreate'); % If no pool, do not create new one.
if isempty(poolobj)
    parpool(numcores);
elseif poolobj.NumWorkers ~= numcores
    delete(poolobj)
    parpool(numcores);
end

parfor j = 1:16
    fprintf('Iteration: %d\n',j)
    module_interaction(j, epsilon, K, DistModel, dText);
end