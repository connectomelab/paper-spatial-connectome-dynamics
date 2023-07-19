function D = delaysteps(L,v,dt)
% converts length matrix into matrix of index steps for euler solver
% depending on dt

columnsize = 0.5; %mm

D = round(((L .* columnsize) ./ v) ./ dt);