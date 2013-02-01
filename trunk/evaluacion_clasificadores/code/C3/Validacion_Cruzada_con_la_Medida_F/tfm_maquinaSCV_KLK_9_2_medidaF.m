clc
clear all
close all

%Este archivo realiza el entrenamiento y test de la SVM con la base de datos
%tal cual la dividio Ricardo:
%Para entrenamiento: 9 muestras positivas (+1, si poseen la enfermedad)
%                   20 muestras negativas (-1, no posees la enfermedad)     
%Para el test:       2 muestras positivas (+1, si poseen la enfermedad)
%                   15 muestras negativas (-1, no posees la enfermedad)

%Cargamos los datos de entrenamiento y test

load datos_TFM_KLK

n = size(K,1);
K = [(1:n)' , K];

m = 29;
Ke = K(1:m,1:m+1);
Ye = Y_training;
bestc = 0;%Variable que va almacenar el mejor C obtenido
bestwn = 0;%Variable que va almacenar el mejor g obtenido
bestcv = 0;%Mejor porcentaje de precisión obtenido con cross-validation
numParticiones = 5;%Número de particiones para el cross validation
W = 1:10;
porcentajeAcierto = zeros(1,length(W));%Porcentaje de preciosión de la máquina con los mejores parámetros encontrados
parametros = zeros(length(W),2);%Matriz donde se almacenan los mejores parámetros para cada valor de los Ci [bestc bestg bestcv]
performance = 0;
n = 0;

for w = 1:10
    performance = 0;
    for logc = -5:10 

        opciones = ['-s 0',' -t 4',' -c ',num2str(2^logc),' -w1 ',num2str(w),' -w-1 1'];
        cv = validacion_cruzada_medidaF(Ke,Ye,numParticiones,opciones);

        if  ((cv)>performance)
            bestc  = 2^logc;
            performance = cv;
        end

    end
   
    n = n+1;
    
    parametros(n,1) = bestc;
    parametros(n,3) = performance;
    
end

save tfm_datosDesbalanceados_cSVC_KL_9_2_medidaF