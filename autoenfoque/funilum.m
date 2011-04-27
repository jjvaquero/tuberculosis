%Funcion para modelar la iluminacion no homogenea de una escena

function resultado=funilum(gl);
% gl debe ser <= 1.0

%[m,n]=size(I);
m = 1200;
n = 1600;

x=0:1:n-1;

B1=20+1*x.^2;
u=max(B1);
B=B1/u;
L=repmat(B,m,1);
L=L*gl;
resultado=double(L);
