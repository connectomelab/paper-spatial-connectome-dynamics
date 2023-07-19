function C = quick_create_network_noPA(n, d, epsilon, DistModel, filename)
% n = size of sheet (nxn nodes)
% d = average out-degree
% epsilon = distance exponend
% DistModel = create nodes on torus or on flat sheet

switch DistModel
    case 'sheet'
        distfunc = @distSheet;
    case 'torus'
        distfunc = @distTorus;
end

nsub = n^2;
C = zeros(nsub);

% create distance matrix
[coordx,coordy] = meshgrid(1:n,1:n);
for A = 2:2:n
    coordx(A,:) = coordx(A,:) - 0.5;
end
for A = 1:n
    coordy(A,:) = sqrt(0.75) * A * ones(1,n);
end
coorx=reshape(coordx,nsub,1);
coory=reshape(coordy,nsub,1);

N = 0;
M = d*nsub;
while N < M
    for i=1:nsub
        distM = distfunc([coorx(i) coory(i)],[coorx coory],n,n*sqrt(0.75));
        p=distM.^epsilon;%generate distribution
        p(distM==0 | C(:,i)==1)=0;%no self connection or existing connection
        p = (p*((M-N)/nsub)) ./ sum(sum(p)); % this normalisation determines the density of the network, the multiplicative factor determines the average number of connections per node
        if max(p(:)) > 1, p = p ./ max(p(:)); end
        pV=rand(nsub,1);
        pConn=p>pV;
        C(pConn,i) = 1;
    end
    N = sum(C(:));
end

if nargin == 5
    save(filename,'C','epsilon')
end

end

function distT = distSheet(a,b,varargin)
    %calculates the euclidian distance from the b vector to the a point
    distT=sqrt((abs(b(:,1)-a(1)).^2)+(abs(b(:,2)-a(2)).^2));
end

function distT = distTorus(a,b,varargin)
    if nargin>2
        n=varargin{1};
        m=varargin{2};
    else
    m=sqrt(length(b));
    n=m;
    end

    distx=min(abs(a(1)-b(:,1)),n-abs(a(1)-b(:,1)));
    disty=min(abs(a(2)-b(:,2)),m-abs(a(2)-b(:,2)));
    distT=sqrt(distx.^2+disty.^2);
end