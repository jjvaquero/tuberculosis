clc
clear all
close all 

%El archivo matrizKLK.m calcula la matriz de Gramm del kernel de
%kullback-Leibler. La implementación del kernel KL se realiza usando
%la aproximación de vecinos próximos

%Cargamos los datos de entrenamiento y de test
load datosTraining 
load datosTest

X = [X_training X_test];%Base de datos con todas las muestras

n  = length(X);%determinamos el número de muestras de la base de datos

K = zeros(n,n);%Reservamos espacio para la matriz de kernel para hacer el
%código más eficiente

for i=1:n
    for j=i:n
        
        if (i==j)
            K(i,j) = 1;%Los valores de la diagonal valen 1 porque la
            %divergencia de Kullback-Leibler es cero cuando las densidades
            %son iguales.
            %J = KL_knn(xi,xi) + KL_knn(xi,xi) => J = 0 para i = j
            %K(i,i) = exp(-J)=exp(0) => K(i,i) = 1;
        else
           
            xi = X{i};%extraemos la muestra xi de la base de datos
            xj = X{j};%extraemos la muestra xj de la base de datos
            
            K(i,j) = kernel_KL_knn(xi,xj);%Evaluamos el kernel de Kullback-Leibler
            K(j,i) = K(i,j);%La matriz de Gramm es simétrica debido a la simétria del
            %producto interno
            
            
        end
        
    end
end

%Guardamos la matriz de kernel en un archivo llamado
%matrizKernel_KL_1v
save matrizKernel_KL_1v K