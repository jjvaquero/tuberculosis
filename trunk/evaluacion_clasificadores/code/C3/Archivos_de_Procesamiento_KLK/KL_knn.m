function out = KL_knn(xi,xj)

%La funci�n KL_knn(xi,xj) estima la distancia de Kullback-Leibler entre xi
%y xj usando vecinos pr�ximos.

m = length(xj);%determinamos el n�mero de muestras de xj
n = length(xi);%determinamos el n�mero de muestras de xi

rk_xi = distancia_vecino_knn(xi);%calculamos las distancias de cada muestra de xi a su vecino m�s pr�ximo en el vector xi.
sk_xi = distancia_vecino_knn(xi,xj);%calculamos las distancias de cada muestra de xi a su vecino m�s pr�ximo en el vector xj.

%Estimamos la divergencia KL usando una aproximaci�n que combina
%monte-carlo y vecinos pr�ximos.
out=(1/n)*sum(log((sk_xi+eps)./(rk_xi+eps))) + log(m/(n-1));




