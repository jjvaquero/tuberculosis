function IM2=muestraBacilos(IM,indices,ventana,Nbarridos, ...
				  desplazamiento)
% muestra_bacilos - Muestra los bacilos detectados en una imagen
%
% Imagen:                Imagen entrada
% indices:               ventanas con bacilos.
% ventana:               Tamaño de la ventana
% Nbarridos:             Número de pasadas
% desplazamiento:        Desplazamiento
% etiquetas:             Etiquetas revisadas.
[fi,co,di]=size(IM);
IM2=zeros(size(IM),'uint8');

%ventana original
nf=floor(fi/ventana);
nc=floor(co/ventana);
indicemaximo=nf*nc;
k=1;
while (k <= length(indices))
    if indices(k)>indicemaximo
        break
    end
    fila=floor(indices(k)/nc)+1;
    columna=rem(indices(k),nc);
    if columna==0
        columna=nc;
        fila=fila-1;
    end
    %pintar cuadrado en las posiciones que corresponden a esa
    %ventana.
    IM2=marca_bacilo_color(IM2,fila,columna,ventana,0,desplazamiento,3,255);
    k = k + 1;
end

%desplazamientos. 
nf=floor(fi/ventana)-1;
nc=floor(co/ventana)-1;
for m=1:Nbarridos-1
    indicemaximo2=indicemaximo+m*nf*nc;
    while (k<=length(indices))
        if indices(k)>indicemaximo2
            break
        end
        fila=floor((indices(k)-nf*nc*(m-1)-indicemaximo)/nc)+1;
        columna=rem(indices(k)-nf*nc*(m-1)-indicemaximo,nc);
        if columna==0
            columna=nc;
            fila=fila-1;
        end
        %pintar cuadrado en las posiciones que corresponden a esa
        %ventana.
        IM2=marca_bacilo_color(IM2,fila,columna,ventana,m,desplazamiento,3,255);
        k=k+1;
    end
end



