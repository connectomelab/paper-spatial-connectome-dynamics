function participation = calc_participation

numcores = 2;
poolobj = gcp('nocreate'); % If no pool, do not create new one.
if isempty(poolobj)
    parpool(numcores);
elseif poolobj.NumWorkers ~= numcores
    delete(poolobj)
    parpool(numcores);
end

eta = 1:5;
participation = zeros(15,5,16);
for e = 1:length(eta)
    fprintf('%d: ',e)
    for r = 1:16
        tic
        fprintf('%d, ',r)
        load(['F:/Research/Analysis/temporal_modules_delays_torus_' num2str(eta(e)) '_' num2str(r) '.mat'],'Ci')
        load(['F:/Research/networks/net_torus_noPA_' num2str(eta(e)) '_' num2str(r) '.mat'],'C')
        parfor k = 1:15
            A = trackModules(Ci{k}, C, 0);
            p = zeros(1,size(A,2));
            for j = 1:size(A,2)
                internal = 0;
                external = 0;
                u = unique(A(:,j));
                for x = 1:length(u)
                    internal = internal + sum(sum(C(A(:,j)==u(x),A(:,j)==u(x))));
                    external = external + sum(sum(C(A(:,j)==u(x),A(:,j)~=u(x))));
                end
                p(j) = external ./ (internal + external);
            end
            participation(k,e,r) = mean(p);
        end
        toc
    end
end