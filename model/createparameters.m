function parameters = createparameters(n,C,DistModel,T,k,v)

% default parameters for mean and std of node intrinsic frequency 
% and noise amplitude and variance
w_mean = 60;
w_std = 3;
n_std = 2;
n_scale = 2;

parameters.n = n;
parameters.dt = 0.1;
parameters.N = (T * 1000) / parameters.dt;
parameters.k = k;

L = distmatrix(n,DistModel);
parameters.D = delaysteps(L,v,parameters.dt);

parameters.C = C;

parameters.omega = ((w_mean*2*pi) + (randn(1,n^2) * (w_std*2*pi))) / 1000;
parameters.noise = n_scale * (randn(parameters.N,n^2) * n_std) / 100;