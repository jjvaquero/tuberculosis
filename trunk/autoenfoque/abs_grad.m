%Funcion que permite calcular el metodo basado en el absoluto de la magnitud del gradiente
%para medir el desenfoque en una imagen (Algoritmo Tenenbaum).
%Parametros de entrada: 

function ftenen=abs_grad(I)

I=uint8(I);
[m n]=size(I);
f=fspecial('sobel');
% [g t gx gy]=edge(I,'sobel','horizontal','vertical');
gx=imfilter(I,f);
gy=imfilter(I,f');
mag_grad=(abs(gx)+abs(gy));
mag_grad(1,:)=0; mag_grad(m,:)=0;
mag_grad(:,1)=0; mag_grad(:,n)=0;

ftenen=sum(sum((mag_grad)));
