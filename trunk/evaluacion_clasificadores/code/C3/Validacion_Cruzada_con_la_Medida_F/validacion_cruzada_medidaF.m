function out = validacion_cruzada_medidaF(Ke,Ye,numParticiones,opciones)

filas = size(Ke,1);%determino el numero de datos de entrenamiento 
%(número de filas de la matriz de kernel precomputada de entrenamiento)

numDatos_porParticion = round(filas / numParticiones);%determino el número de
%datos que habrá en cada partición

%numDatos_ultimoGrupo = filas - ((numParticiones - 1)*numDatos_porParticion);

contador = 1;
perfomanceAcumulado = 0;

while (contador<=numParticiones)
    
    Ke1 = Ke(numDatos_porParticion + 1:end,:);%saco la partición de entrenamiento
    Ye1 = Ye(numDatos_porParticion + 1:end);%saco las etiquetas de la particion de entrenamiento
    modelo = svmtrain(Ye1,Ke1,opciones);%entreno la svm con la particion respectiva
    [etiqueta_predicha, precision, dec_values] = svmpredict(Ye,Ke,modelo);%evaluamos con todos los datos
    [matrizConfusion sensibilidad especificidad] = matrizDeConfusion(etiqueta_predicha(1:numDatos_porParticion),Ye(1:numDatos_porParticion),0);
    
    if(isnan(sensibilidad))
        sensibilidad = 0;
    end
    
    if(isnan(especificidad))
        especificidad = 0;
    end
    
    %%%%%%%%%%%%%%%%%%MEDIDA F%%%%%%%%%%%%%%%%%%%%%%%%
    vp = matrizConfusion(1,1);
    fp = matrizConfusion(1,2);
    
    pr = vp / (vp+fp);
    
    if (isnan(pr)||(sensibilidad==0 && pr==0))
        F = 0;
    else
        F = 2*sensibilidad*pr / (sensibilidad + pr);
    end
    
   perfomanceAcumulado = perfomanceAcumulado + F;
   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    
    Ke = [Ke(numDatos_porParticion + 1:end,:);Ke(1:numDatos_porParticion,:)];
    Ye = [Ye(numDatos_porParticion + 1:end); Ye(1:numDatos_porParticion)];
    
    contador = contador + 1;
    
end

out = perfomanceAcumulado / numParticiones;
