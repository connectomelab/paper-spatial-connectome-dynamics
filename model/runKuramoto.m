function O = runKuramoto2(InitCond,parameters)

%this is an euler solver with a noise term as subcortical input

n = parameters.n;
nsub = n^2;
h = parameters.dt;
k = 0.0001*parameters.k;
N = parameters.N;
ds = max(max(parameters.D));

inc = 0:(ds+1):(ds+1)*nsub - (ds+1);
index = parameters.C==1;

O = zeros(N+ds,nsub);

O(1:ds+1,:) = repmat(InitCond(1:nsub),ds+1,1);
for t = ds+1:N+ds-1
    theta = O(t-ds:t,:);
    
    conninput = zeros(1,nsub);
    for i = 1:nsub
        conninput(i) = sum(sin(theta((ds+1-parameters.D(i,index(i,:)))+inc(index(i,:))) - theta(end,i)));
    end
    dO = parameters.omega + k*conninput + parameters.noise(t-ds,:);
    
    O(t+1,:) = O(t,:) + (h*dO);
end
