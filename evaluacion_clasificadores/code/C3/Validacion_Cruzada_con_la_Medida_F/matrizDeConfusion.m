function [matrizConfusion sensibilidad especificidad] = matrizDeConfusion(etiqueta_predicha,Y_test,flag)

vp=0;%contador para los verdaderos positivos
fp=0;%contador para los falsos positivos
vn=0;%contador para los verdaderos negativos
fn=0;%contador para los falsos negativos

%                    Etiqueta Real +1       Etiqueta Real -1
%Valor Predicho +1          VP                    FP
%Valor Predicho -1          FN                    VN

for i=1:length(etiqueta_predicha)
    
   if ((etiqueta_predicha(i)==1) && (Y_test(i)==1))
       vp = vp + 1;
   elseif ((etiqueta_predicha(i)==1) && (Y_test(i)==-1))
       fp = fp + 1;
   elseif ((etiqueta_predicha(i)==-1) && (Y_test(i)==1))
       fn = fn + 1;
   elseif ((etiqueta_predicha(i)==-1) && (Y_test(i)==-1))
       vn = vn + 1;
   end
   
end

muestrasPos_tst = length(find(Y_test==1));
muestrasNeg_tst = length(find(Y_test==-1));


matrizConfusion = [vp fp;fn vn];
sensibilidad  = vp / (vp+fn);
especificidad = vn / (vn+fp);

if (flag==1)

fprintf('\nNúmero de muestras: %d\n',length(Y_test))
fprintf('Número de muestras de la clase +1: %d\n',muestrasPos_tst)
fprintf('Número de muestras de la clase -1: %d\n\n',muestrasNeg_tst)

fprintf('Matriz de Confusión')

fprintf('\n\n                         Etiqueta Real +1               Etiqueta Real -1\n')
fprintf('Valor Predicho +1         vp: %d / %d (%f)                 fp: %d / %d (%f)     \n',vp,muestrasPos_tst,vp/muestrasPos_tst,fp,muestrasNeg_tst,fp/muestrasNeg_tst)
fprintf('Valor Predicho -1         fn: %d / %d (%f)                 vn: %d / %d (%f)     \n',fn,muestrasPos_tst,fn/muestrasPos_tst,vn,muestrasNeg_tst,vn/muestrasNeg_tst)

fprintf('\nSensibilidad del clasificador: %f\n',sensibilidad);
fprintf('Especificidad del clasificador:  %f\n\n',especificidad);

end

