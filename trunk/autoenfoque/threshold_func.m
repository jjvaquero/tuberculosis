function [ valores, seleccion ] = ...
    threshold_func( imagen )
%THRESHOLD_FUNC Suma de los píxeles con niveles de gris superiores al 10%

maximo = max(max(cell2mat(imagen)));

valores = zeros(20, 1);

for i=1:length(imagen),
    
    data = cell2mat(imagen(i));    
    valores(i) = sum(sum(data > maximo*0.8));
    
end

[maximo, seleccion] = max(valores);

valores = {valores};

end
