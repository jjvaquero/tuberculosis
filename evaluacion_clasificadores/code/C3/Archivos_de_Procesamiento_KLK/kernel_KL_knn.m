function out = kernel_KL_knn(xi,xj)

%La función kernel_KL_knn(xi,xj) calcula el valor de la función del
%kernel de Kullback-Leibler de las muestras xi y xj. Dicho kernel
%está definido de la siguiente manera:
%J = KL_knn(xi,xj) + KL_knn(xj,xi);
%kernel_KL_knn(xi,xj) = exp(-aJ+b)
%En nuestro caso hemos fijado a y b en 1 y 0 respectivamente

KL_xi_xj = KL_knn(xi,xj);%estimamos la divergencia de Kullback-Leibler entre xi y xj usando vecinos próximos.

KL_xj_xi = KL_knn(xj,xi);%estimamos la divergencia de Kullback-Leibler entre xj y xi usando vecinos próximos.

J = KL_xi_xj + KL_xj_xi;%estimamos la divergenia simétrica de Kullback-Leibler.

out = exp(-J);%calculamos el valor del kernel KL.

