%Funcion que subdivide una imagen en vecindades de tamano wxh (10 x 20) para calcular
%la suma de sus momentos en las vecindades. Esta funcion esta asociada a la funcion mpq. 
%Los datos de entrada son los valores de la imagen. Si se quieren sumar
%otros momentos hay que recurrir a la funcion addmoments

function salida=addmomenreg(I)

[n,m]=size(I);
w=10;           %ancho de la vencidad
h=20;           %alto de la vecindad
r=n/w;
s=m/h;
l=1;

for i=1:r:n,
    for j=1:s:m,
        I1=I(i:i+(r-1),j:j+(s-1));
        mu(l)=mpq(2,0,I1)+mpq(0,2,I1);
        l=l+1;
    end
end

salida=sum(mu);

end