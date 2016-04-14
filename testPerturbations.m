clear all
format long
dt = 0.1;
steps = 1000;

fileID = fopen('uniformDataUnperturbed.txt','r');
formatSpec = '%f %f';
sizeA = [2 Inf];
A = fscanf(fileID,formatSpec,sizeA);
A = A';
xs = A(:,1);
ys = A(:,2);
N = length(xs);

den = ones(N,1);
x2 = zeros(N,1);
y2 = zeros(N,1);
Vx = zeros(N,1);
Vy = zeros(N,1);
Vx2 = zeros(N,1);
Vy2 = zeros(N,1);
xDiff = zeros(steps,1);
yDiff = zeros(steps,1);

nPerts = 10;
maxDiff = zeros(nPerts,1);
pert = zeros(nPerts,1);
for p = nPerts:-1:1
    pert(p) = 10^-p;
    x = xs;
    y = ys;
    for i = 1:N
        %Here i did perturbations based of a % of the original
        %because we don't know how big the original is(could be a million)
        x2(i) = x(i) + x(i)*((2*pert(p))*rand()-pert(p));
        y2(i) = y(i) + y(i)*((2*pert(p))*rand()-pert(p));
    end
    for i = 1:steps
        [dxx,dyy] = laplaceSLPfmm(den,x,y);

        Vx = Vx - dxx*dt;
        Vy = Vy - dyy*dt;

        x = x + dt*Vx;
        y = y + dt*Vy;

        %Do same thing for perturbed data
        [dxx2,dyy2] = laplaceSLPfmm(den,x2,y2);

        Vx2 = Vx2 - dxx2*dt;
        Vy2 = Vy2 - dyy2*dt;

        x2 = x2 + dt*Vx2;
        y2 = y2 + dt*Vy2;


        xDiff(i) = norm(abs(x-x2),inf);
        yDiff(i) = norm(abs(y-y2),inf);

        %figure;
        %scatter(x,y,x2,y2);
        %scatter(x,y)
        %xlim([-10,10]);
        %ylim([-10,10]);
        %pause
    end
    maxDiff(p) = max(xDiff);
end
%maxDiff
figure;
loglog(pert,maxDiff);