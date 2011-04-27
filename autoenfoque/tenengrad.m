%Funcion que permite calcular el metodo basado en la magnitud del gradiente
%para medir el desenfoque en una imagen (Algoritmo Tenenbaum).
%Parametros de entrada: 

function ftenen=tenengrad(I)

[m n]=size(I);
f=fspecial('sobel');
gx=imfilter(I,f);
gy=imfilter(I,f');
mag_grad=(gx.^2+gy.^2);
mag_grad(1,:)=0; mag_grad(m,:)=0;
mag_grad(:,1)=0; mag_grad(:,n)=0;

ftenen=sum(sum((mag_grad)));



