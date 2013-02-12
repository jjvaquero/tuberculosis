function [y yJRIP objects]=analizaVariableSimple2(X,clasificador1,param1,minPixels,media2,desv2,C2,normalizaC3,C3,objectdetector)
% X es la variable
% Y es la salida blanda del procesado.
% realiza el procesado de una variable.
% Emplea distintas reglas en cascada
tamVent=37;

try
NT=maxNumCompThreads;
catch
NT=8;
end

debug=0;

objects={};

disp(['analizando ' num2str(size(X,1)) ' parches'])
% El primer clasificador va a tener este formato 
% @clasificador1(X,param1)
%1. JRIP
%y=JRIP1(X); %deja atr'as muchos bacilos.
%y=JRIP2(X); %no va nada bien
y=feval(clasificador1,X,param1);
yJRIP=y;
Ind1=find(y>0);
%2 Object detection.
disp(['analizando ' num2str(length(Ind1)) ' despues de JRIP'])
IMaux=uint8(zeros(tamVent,tamVent,3));
for k=1:length(Ind1)
y(Ind1(k))=-1; % por defecto negativo.

    IMaux(:)=uint8(X(Ind1(k),:));
    if debug
        
        figure(gcf),imshow(IMaux)
        keyboard
    end
   [segmented_images,npixels,edge_boundaries]=feval(objectdetector,IMaux,4);
    I=find(npixels>=minPixels);
    if isempty(I)
        continue
    end
    F=zeros(length(I),6);
    F2=zeros(length(I),21);
    F4=zeros(length(I),12);
    NF2=8; %quiz'a 6
    F6=zeros(length(I),NF2);

    for k2=1:length(I)
        % obtenemos nuevas features para cada objeto
        Xaux=double(segmented_images{I(k2)});
        Xaux2=Xaux(:,:,1)|Xaux(:,:,2)|Xaux(:,:,3);
        [fil,col,dim]=size(Xaux);
        F(k2,:)=rsm_ecc_comp(double(Xaux2))';
        F2(k2,:)=rsm_mindru_gpd_invariant_moments(Xaux)';
        F4(k2,:)=[mean(mean(Xaux(:,:,1))) mean(mean(Xaux(:,:,2))) mean(mean(Xaux(:,:,3))) ...
            std(reshape(Xaux(:,:,1),1,fil*col))...
            std(reshape(Xaux(:,:,2),1,fil*col))...
            std(reshape(Xaux(:,:,3),1,fil*col))...
            max(max(Xaux(:,:,1))) max(max(Xaux(:,:,2))) max(max(Xaux(:,:,3))) ...
            min(min(Xaux(:,:,1))) min(min(Xaux(:,:,2))) min(min(Xaux(:,:,3)))];
        F6(k2,:)=rsm_fourier_boundary_descriptor2(edge_boundaries{I(k2)},NF2,64);
    end
    % normalizamos los coeficientes
    X3=rsm_normalizar([F F2 F4 F6],media2,desv2);
    % clasificamos con clasificador 1
    salida = evalua_svm_thread(C2.t,X3',C2.VS,C2.alfas,C2.rho,NT);
    
    I2=find(salida>0);
    if isempty(I2)
        continue
    end
    disp(['caso ' num2str(k) ': analizando ' num2str(length(I2)) ' despues de other features'])
    X3=zeros(length(I2),numel(Xaux));
    % los que aún sean positivos, los registramos y los analizamos con una SVM
    for k2=1:length(I2)
        % registramos.
        % a) luminancia see rsm_rgb2ycbcr
        IMaux2= double(segmented_images{I(I2(k2))}(:,:,1))* 0.25679 - ...
            double(segmented_images{I(I2(k2))}(:,:,2))* 0.14822 + ...
            double(segmented_images{I(I2(k2))}(:,:,3))* 0.43943;
        % b)registramos
        %[IM2C]=rsm_compact_image(IMaux2,segmented_images{I(k2)});% es m'as lento por culpa de la interpolaci'on
        [IM2C]=rsm_compact_image2(IMaux2,segmented_images{I(I2(k2))});
        % clasificamos.
        if   isfloat(IM2C)==0 %
            %error('something went wrong')
            IM2C=double(IM2C);
        end
        %           tic
        X3(k2,:)=normaliza_bacilos(IM2C(:)',normalizaC3);
        %           toc
    end
%    soft2=rsm_evalua_svm_thread_libsvm(X3,class3);
       soft2 = evalua_svm_thread(C3.t,X3',C3.VS,C3.alfas,C3.rho,NT);
       I3=find(soft2>0);
detecciones=sum(soft2>0);
if detecciones
    y(Ind1(k))=detecciones;
    objects{Ind1(k)}=segmented_images(I(I2(I3)));
end
end
