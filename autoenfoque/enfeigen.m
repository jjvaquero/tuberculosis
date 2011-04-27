%Función para calcular el valor de autoenfoque para una imagen en niveles
%de intenisdad a partir de la sume de sus eigenvalores mayores.
%La entrada debe ser una imagen cuadrada

function resultado=enfeigen(X);

[m,n]=size(X);
I=double(X(:,1:m));
Inorm=I/(sqrt(sum(sum(I.^2))));

% mediaI=(sum(sum(Inorm)))/(m*n);
% G=Inorm-mediaI;

% C1=(G*G')/(m-1);
C1=cov(Inorm);

%Descomposición de valores singulares
[u,v,w]=svd(C1);

eigenvalores=v'*v;
e1=sum(eigenvalores,2);
e1=sum(e1(1:24,1));     %suma de los eigenvalores más grandes

resultado=e1;
 



