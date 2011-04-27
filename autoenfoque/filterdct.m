%Funcion para calcular la funcion de enfoque para una imagen basado en un
%kernel que determina las coeficientes dct de una imagen, referencia Sang
%Young Lee et al 2008.

function filtered=filterdct(I);

mfdct=[1 1 -1 -1; 1 1 -1 -1; -1 -1 1 1; -1 -1 1 1];
G=imfilter(I,mfdct);

filtered=sum(sum(G.^2));

