function out = KL_knn(xi,xj)

%La función KL_knn(xi,xj) estima la distancia de Kullback-Leibler entre xi
%y xj usando vecinos próximos.

m = length(xj);%determinamos el número de muestras de xj
n = length(xi);%determinamos el número de muestras de xi

rk_xi = distancia_vecino_knn(xi);%calculamos las distancias de cada muestra de xi a su vecino más próximo en el vector xi.
sk_xi = distancia_vecino_knn(xi,xj);%calculamos las distancias de cada muestra de xi a su vecino más próximo en el vector xj.

%Estimamos la divergencia KL usando una aproximación que combina
%monte-carlo y vecinos próximos.
out=(1/n)*sum(log((sk_xi+eps)./(rk_xi+eps))) + log(m/(n-1));




