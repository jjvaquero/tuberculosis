function [reslog, resrob, resvol, reslap] = comprueba_enfoques_func_tophat ...
    (directory, extension, output, filtro, nombre)

% función llamada desde comprueba_enfoques.m. No hay que llamarla
% directamente, se utiliza desde el programa anterior.

if nargin < 2, extension = 'tif'; end;
if nargin < 1, directory = 'C:\temp\imagenes_enfoque\'; end;

files = dir(sprintf('%s*.%s', directory, extension));

image_result = sprintf('%s\\%s.jpg', output, nombre);

loghist_result = zeros(1, length(files), 'uint32'); %Preallocate
robust_result = zeros(1, length(files), 'uint32'); %Preallocate
vollath_result = zeros(1, length(files), 'uint32'); %Preallocate
laplacian_result = zeros(1, length(files), 'uint32'); %Preallocate

reslog = 0;
resrob = 0;
resvol = 0;
reslap = 0;

imagen_enfocada_histogram = 'NONE';
imagen_enfocada_robust = 'NONE';
imagen_enfocada_vollath = 'NONE';
imagen_enfocada_laplacian = 'NONE';

temp_max_histogram = uint32(0);
temp_max_robust = uint32(0);
temp_max_vollath = uint32(0);
temp_max_laplacian = uint32(0);

t_histogram = 0.0;
t_robust = 0.0;
t_vollath = 0.0;
t_laplacian = 0.0;
t_filtrado = 0.0;


for i=1:length(files),
    current_file = sprintf('%s%s', directory, files(i).name);
    data = imread(current_file, extension);
    datagreen = data(:,:,2); % Verde: segundo canal
    
    tic
    mascara = strel('disk', 4);
    opened = imopen(datagreen, mascara);
    %eroded = imerode(opened, mascara);
    %datagreen = datagreen-eroded;
    datagreen = datagreen-opened;
    t_filtrado = t_filtrado + toc;
    
    %%%%
    %
    % FILTRADO DE MEDIANA, PARA EL RUIDO
    %
    %%%%
    
    % filtro = 0 no hace nada
    
    if filtro == 1
        datagreen = medfilt2(datagreen, [2 2]);
    elseif filtro == 2
        datagreen = medfilt2(datagreen, [4 4]);
    elseif filtro == 3
        datagreen = medfilt2(datagreen, [8 8]);
    end
      
    tic;
    valora = -log_histogram(datagreen);
    t_histogram = t_histogram + toc;
    
    tic;
    valorb = robust_function(datagreen, 0.5);
    t_robust = t_robust + toc;
    
    tic;
    valorc = vollath(datagreen);
    t_vollath = t_vollath + toc;
     
    tic;
    valore = laplacian(datagreen);
    t_laplacian = t_laplacian + toc;
    
    
    if temp_max_histogram < valora,
        temp_max_histogram = valora;
        imagen_enfocada_histogram = files(i).name;
        reslog = i;
    end
    %disp(sprintf('%d', valora));
    
    if temp_max_robust < valorb,
        temp_max_robust = valorb;
        imagen_enfocada_robust = files(i).name;
        resrob = i;
    end

    
    if temp_max_vollath < valorc, 
        temp_max_vollath = valorc; 
        imagen_enfocada_vollath = files(i).name;
        resvol = i;
    end
    
    if temp_max_laplacian < valore,
        temp_max_laplacian = valore;
        imagen_enfocada_laplacian = files(i).name;
        reslap = i;
    end
   
    loghist_result(i) = valora; % Asignamos el resultado
    robust_result(i) = valorb;
    vollath_result(i) = valorc;
    
    laplacian_result(i) = valore;
end
% 
% disp(sprintf('Imagen enfocada por loghist: %s', imagen_enfocada_histogram));
 disp(sprintf('Tiempo loghist: %2.2f s', t_histogram));
% disp(sprintf('Imagen enfocada por robust: %s', imagen_enfocada_robust));
 disp(sprintf('Tiempo robust: %2.2f s', t_robust));
% disp(sprintf('Imagen enfocada por vollath: %s', imagen_enfocada_vollath));
 disp(sprintf('Tiempo vollath: %2.2f s', t_vollath));
% disp(sprintf('Imagen enfocada por laplacian: %s', imagen_enfocada_laplacian));
 disp(sprintf('Tiempo laplacian: %2.2f s', t_laplacian));
  disp(sprintf('Tiempo top-hat: %2.2f s', t_filtrado));
% disp('Fin');

%disp(sprintf('Guardaré la imagen en %s', image_result));

my_image =  figure;
subplot(2, 2, 1);
plot(loghist_result);
title('Forma de la función "loghist"');
subplot(2, 2, 2);
plot(robust_result);
title('Forma de la función "robust"');
subplot(2, 2, 3);
plot(vollath_result);
title('Forma de la función "vollath"');
subplot(2, 2, 4);
plot(laplacian_result);
title('Forma de la función "laplacian"');
saveas(my_image, image_result);
close(my_image);
end

