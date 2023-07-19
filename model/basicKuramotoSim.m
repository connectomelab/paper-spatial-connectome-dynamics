function basicKuramotoSim(epsilon, iteration, n, DistModel, T, K, v)
% epsilon = exponent of distance term for network generation
% iteration = iteration number of previously generated network
% n = size of n x n network
% DistModel = 'torus' or 'sheet' describes topology of space in which nodes are embedded
% T = run time of simulation in seconds
% K = vector of connection strengths
% v = conduction velocity

load(['../networks/net_' DistModel '_noPA_' num2str(epsilon) '_' num2str(iteration) '.mat'],'C')

for j = 1:length(K)
    tic
    k = K(j);
    parameters = createparameters(n,C,DistModel,T,k,v);
    InitCond = rand(1,n^2) * 2 * pi;
    O = runKuramoto(InitCond,parameters);
    save(['../simulations/raw_' DistModel '_' num2str(epsilon) '_' num2str(iteration) '_' num2str(k)],'O','T','k','v','-v7.3')
    toc
end