function  IM=marca_bacilo_color(IM,fila,columna,ventana,barrido,desplazamiento,paso,color)
% marca_bacilo(fila,columna,ventana,barrido, desplazamiento);
% columna
% fila
% ventana:               Tamaño de la ventana
% Nbarridos:             Número de pasadas
% desplazamiento:        Desplazamiento
% colo el color que se quiere pintar (rojo =1, verde = -1, azul = 0)
[fi,co,di]=size(IM);

fil_si=(fila-1)*ventana + barrido*desplazamiento + 1;
col_si=(columna-1)*ventana + barrido*desplazamiento + 1;
fil_id=fila*ventana + barrido*desplazamiento;
col_id=columna*ventana + barrido*desplazamiento;
IM(fil_si:paso:fil_id,col_si,:)=color;
IM(fil_si:paso:fil_id,col_id,:)=color;
IM(fil_si,col_si:paso:col_id,:)=color;
IM(fil_id,col_si:paso:col_id,:)=color;

IM(fil_si:paso:fil_id,col_si+1,:)=color;
IM(fil_si:paso:fil_id,col_id-1,:)=color;
IM(fil_si+1,col_si:paso:col_id,:)=color;
IM(fil_id-1,col_si:paso:col_id,:)=color;
