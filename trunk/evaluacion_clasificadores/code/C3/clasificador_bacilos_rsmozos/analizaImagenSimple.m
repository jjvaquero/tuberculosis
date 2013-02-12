function [y2,y3,objects,patches]=analizaImagenSimple(directorio,imagen,clasificador1,param1,minPixels,media2,desv2,C2,normalizaC3,C3,objectdetector,visualiza)
% Analiza una imagen.
% directorio: directorio donde est'an las im'agenes.
% visualiza flag para mostrar los resultados

%estos par'ametros son los que usamos para esta base de datos.
tamVent=37;
pas= 4;
desp= 9;
%pas=2;
%desp=18;

                   

IM=imread([directorio filesep imagen]);



X = enventanaPasadas( IM(2:end-1,2:end-1,:) , tamVent , pas , desp );

[y yJRIP objects]=analizaVariableSimple2(X,clasificador1,param1,minPixels,media2,desv2,C2,normalizaC3,C3,objectdetector);

[IMBW,y2,y3]=DevuelveBacilos(size(IM(2:end-1,2:end-1,:),1),size(IM(2:end-1,2:end-1,:),2),tamVent,pas,desp,y,objects);

objects(find(y>0 & y2<0))={[]};
patches=uint8(X(y2>0,:));
if visualiza
indices=find(y2>0);
    if ~isempty(indices)
    IM2=muestraBacilos(IM(2:end-1,2:end-1,:),indices,tamVent,pas,desp);
    %check code
    % IM3=uint8(zeros(tamVent,tamVent,3));
    figure
    image(IM2+IM(2:end-1,2:end-1,:));
    title(imagen)
    % for k=1:length(indices)
    % figure(2)
    % IM3(:)=uint8(X(indices(k),:));
    % imshow(IM3);
    %pause
    end
    indices2=find(yJRIP>0);
    if ~isempty(indices2)
    IM2=muestraBacilos(IM(2:end-1,2:end-1,:),indices2,tamVent,pas,desp);
    %check code
    % IM3=uint8(zeros(tamVent,tamVent,3));
    figure
    image(IM2+IM(2:end-1,2:end-1,:));
     title([imagen ' preclasificador' ] )
%       IM2=muestraBacilos(IM(2:end-1,2:end-1,:),1:length(yJRIP),tamVent,pas,desp);
%     figure
%     image(IM2+IM(2:end-1,2:end-1,:));
%      title(imagen)
    % for k=1:length(indices)
    % figure(2)
    % IM3(:)=uint8(X(indices(k),:));
    % imshow(IM3);
    %pause
    end
end


