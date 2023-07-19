function L = distmatrix(n,DistModel)

switch DistModel
    case 'sheet'
        distfunc = @distSheet;
    case 'torus'
        distfunc = @distTorus;
end

nsub = n^2;
[coordx,coordy] = meshgrid(1:n,1:n);
for A = 2:2:n
    coordx(A,:) = coordx(A,:) - 0.5;
end
for A = 1:n
    coordy(A,:) = sqrt(0.75) * A * ones(1,n);
end
coorx=reshape(coordx,nsub,1);
coory=reshape(coordy,nsub,1);

L = zeros(nsub,nsub);
for i=1:nsub
    L(:,i) = distfunc([coorx(i) coory(i)],[coorx coory],n,n*sqrt(0.75));
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
