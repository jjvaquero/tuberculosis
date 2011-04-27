function void = evalua_enfoques_ruido(path, landa)
% evalua_enfoques evalúa los distintos algoritmos de autoenfoque
% mezclándolos con distintos tipos de filtrado:
% - Filtrado de mediana 2x2.
% - Filtrado de mediana 4x4.
% - Filtrado de mediana 8x8.
% - Filtrado top-hat.

%PATH_DATA = 'C:/CURRENT/stacks_paper_micro/';
PATH_DATA = path;

void = 0; 
dir_list = dir(PATH_DATA);
%mask = strel('disk', 5); % - Generación de máscara para el filtrado tophat.
mask = ones(9,9); % La máscara será cuadrada, por motivos de eficiencia.

for i=3:length(dir_list),
    %
    % BUCLE PRINCIPAL
    %
    
    nextfile_str = sprintf('%s/%s/', PATH_DATA, dir_list(i).name);    
    nextfile = dir(nextfile_str);
    
    disp(sprintf('Procesando directorio %s', dir_list(i).name));
    
    disp(sprintf('\t* Generando archivos temporales...'));
    
    tiempo_m2 = 0.0;
    tiempo_m4 = 0.0;
    tiempo_m8 = 0.0;
    tiempo_th = 0.0;
    
    t_total = 0.0;
    
    % Referencias de las funciones:
    % * vollathf4: F4 de Vollath. En el paper de Juanjo, por ejemplo.
    %
    % * laplacian: 'Selecting the optimal focus measure for autofocusing
    %   and depth-from-focus'. Referenciado desde 'Evaluation of autofocus
    %   algorithms for tuberculosis microscopy'.
    %
    % * robustX: 'Robust autofocusing for automated microscopy imaging of
    %   fluorescently labelled bacteria'. La X denota el ancho del filtro
    %   gaussiano empleado. Se ha calculado teniendo en cuenta que el ancho
    %   del bastoncillo del bacilo es de entre 0.2-0.5 um (0.17 para el mínimo,
    %   0.43 para el máximo y 0.3 en media).
    %   Los datos del ancho han salido de
    %   http://www.textbookofbacteriology.net/tuberculosis.html
    %   Se prueba también con 1.0 y 2.0, por que se ha visto que
    %   funciona.
    %
    % * loghist: Función de Gabriel Cristóbal.
    %
    % * vollathf5: F5 de Vollath. También en el paper de Juanjo.
    %
    % * threshold: referenciada en el paper de Juanjo. El umbral me lo
    %   inventé yo.
    %
    % * power: referenciada en el paper de Juanjo (SIN REFERENCIA).
    %
    % * variance: referenciada en el paper de Juanjo.
    %
    % * variance_norm: referenciada en el paper de Juanjo.
    
    funciones_eval = {'vollathf4new', 'laplacian', 'robust03', 'loghistnew', ...
        'vollathf5new', 'threshold', 'power', 'variance', 'variance_norm', ...
        'robust043', 'robust017', 'robust1', 'robust2', 'dct', 'mdct', 'hu', ...
	'whs', 'ten', 'aten', 'totalvariation'};
    
    for j=3:22,

        orig_img = imread(sprintf('%s/%s', nextfile_str, nextfile(j).name));
        
        % Cojo el canal verde
	noise = uint8(poissrnd(landa,1200,1600)); % Genero el ruido en cada vuelta
        orig_img_green = orig_img(:,:,2) + noise;
        
        tic;
        orig_img_green_2 = medfilt2(orig_img_green, [2, 2]);
        tiempo_m2 = tiempo_m2 + toc;
        
        tic;
        orig_img_green_4 = medfilt2(orig_img_green, [4, 4]);
        tiempo_m4 = tiempo_m4 + toc;
        
        tic;        
        orig_img_green_8 = medfilt2(orig_img_green, [8, 8]);
        tiempo_m8 = tiempo_m8 + toc;
        
        tic;        
        orig_img_green_th = tophat_filter(orig_img_green, mask);
        tiempo_th = tiempo_th + toc;
          
        partes = regexp(nextfile(j).name, '\.bmp', 'split');
        
        base_nombre = char(partes(1)); % La base del nombre de mi fichero.
        
        file_none = sprintf('%s/%s/%s-orig.tif', PATH_DATA, dir_list(i).name, ...
            base_nombre);         
        file_m2 = sprintf('%s/%s/%s-m2.tif', PATH_DATA, dir_list(i).name, ...
            base_nombre); 
        file_m4 = sprintf('%s/%s/%s-m4.tif', PATH_DATA, dir_list(i).name, ...
            base_nombre);
        file_m8 = sprintf('%s/%s/%s-m8.tif', PATH_DATA, dir_list(i).name, ...
            base_nombre);
        file_th = sprintf('%s/%s/%s-th.tif', PATH_DATA, dir_list(i).name, ...
            base_nombre);
        
        imwrite(orig_img_green, file_none);
        imwrite(orig_img_green_2, file_m2);
        imwrite(orig_img_green_4, file_m4);
        imwrite(orig_img_green_8, file_m8);
        imwrite(orig_img_green_th, file_th);   
                
    end
    
    tiempo_file = fopen(sprintf('%s/tiempos-filtrado.txt', nextfile_str), 'w');
    fprintf(tiempo_file, ...
        '%G\t%G\t%G\t%G\n', tiempo_m2, tiempo_m4, ...
        tiempo_m8, tiempo_th);
    fclose(tiempo_file);
    
    t_total = tiempo_m2 + tiempo_m4 + tiempo_m8 + tiempo_th;
    
 
    for funcion=1:length(funciones_eval),
 
        [so, to] = enfoca(funcion, 0, nextfile_str, ...
            base_nombre, funciones_eval);
        [s2, t2] = enfoca(funcion, 1, nextfile_str, ...
            base_nombre, funciones_eval);
        [s4, t4] = enfoca(funcion, 2, nextfile_str, ...
            base_nombre, funciones_eval);
        [s8, t8] = enfoca(funcion, 3, nextfile_str, ...
            base_nombre, funciones_eval);
        [sth, tth] = enfoca(funcion, 4, nextfile_str, ...
            base_nombre, funciones_eval);

        disp(sprintf('\t* Guardando datos...'));

        seleccionadas_file = fopen(sprintf(...
            '%s/seleccionadas-%s.txt', nextfile_str, ...
            funciones_eval{funcion}), 'w');
        fprintf(seleccionadas_file, ...
            '%G\t%G\t%G\t%G\t%G\n', so, s2, s4, s8, sth);
        fclose(seleccionadas_file);

        tiempo_file = fopen(sprintf('%s/tiempos-%s.txt', ...
            nextfile_str, funciones_eval{funcion}), 'w');
        fprintf(tiempo_file, ...
            '%G\t%G\t%G\t%G\t%G\n', to, t2, t4, t8, tth);
        fclose(tiempo_file);    

        t_total = t_total + to + t2 + t4 + t8 + tth;
        
    end    
    
    disp(sprintf('\t* Borrando archivos temporales...'));
        
    delete(sprintf('%s/*tif', nextfile_str))
    
    disp(sprintf('Directorio %s procesado en %3.2f segundos', ...
        dir_list(i).name, t_total));
           
end

end

function filtered_image = tophat_filter(image, mask)
        
    opened = imopen(image, mask);
    filtered_image = image-opened;

end

function [seleccionada, tiempo] = enfoca(func, filter, dir, ...
    base_nombre, funciones_lista)

valor_func = 0.0;
tiempo = 0.0;
seleccionada = 0;

filtro_lista = {'orig', 'm2', 'm4', 'm8', 'th'};

archivo_resultado = sprintf('%s/valores-%s-%s.txt', ... 
    dir, funciones_lista{func}, filtro_lista{filter+1});

result_handle = fopen(archivo_resultado, 'w');

archivo_norm = sprintf('%s/valores-norm-%s-%s.txt', ... 
    dir, funciones_lista{func}, filtro_lista{filter+1});

result_norm = fopen(archivo_norm, 'w');

disp(sprintf('\t* Calculando algoritmo %s con %s...', ...
    funciones_lista{func}, filtro_lista{filter+1}));


if (func ~= 6)
    % Funciones que usan información cuadro a cuadro
    norm = zeros(1, 20);
    for i=1:20,

        image = imread(sprintf('%s/%s%02d-%s.tif', dir, base_nombre(1:15), ...
            i, filtro_lista{filter+1}), 'tif');      

	image = double(image);

        if (func == 1)
            tic;
            aux = volf4(image);
            tiempo = tiempo + toc;
        elseif (func == 2)
            tic;
            aux = laplacian(image);
            tiempo = tiempo + toc;
        elseif (func == 3)
            tic;
            aux = robust_function(image, 0.3);
            tiempo = tiempo + toc;
        elseif (func == 4)
            tic;
            aux = log_hist(image);
            tiempo = tiempo + toc;
        elseif (func == 5)
            tic;
            aux = volf5(image);
            tiempo = tiempo + toc;   
        elseif (func == 7)
            tic;
            aux = power_image(image);
            tiempo = tiempo + toc;
        elseif (func == 8)
            tic;
            aux = variance(image);
            tiempo = tiempo + toc;
        elseif (func == 9)
            tic;
            aux = variance_norm(image);
            tiempo = tiempo + toc;
        elseif (func == 10)
            tic;
            aux = robust_function(image, 0.43);
            tiempo = tiempo + toc;
        elseif (func == 11)
            tic;
            aux = robust_function(image, 0.17);
            tiempo = tiempo + toc;
        elseif (func == 12)
            tic;
            aux = robust_function(image, 1.0);
            tiempo = tiempo + toc;
        elseif (func == 13)
            tic;
            aux = robust_function(image, 2.0);
            tiempo = tiempo + toc;
        elseif (func == 14)
            tic;
            aux = computeFocus(image, 21, 4, 43);
            tiempo = tiempo + toc;
        elseif (func == 15)
            tic;
            aux = filterdct(image);
            tiempo = tiempo + toc;
        elseif (func == 16)
            tic;
            aux = addmomenreg(image);
            tiempo = tiempo + toc;
        elseif (func == 17)
            tic;
            aux = weighted_histogram_sum(image);
            tiempo = tiempo + toc;
        elseif (func == 18)
            tic;
            aux = tenengrad(image);
            tiempo = tiempo + toc;
        elseif (func == 19)
            tic;
            aux = abs_grad(image);
            tiempo = tiempo + toc;
        elseif (func == 20)
            tic;
            aux = totalvariation(image);
            tiempo = tiempo + toc;
        end
                
        fprintf(result_handle, '%G\n', aux);

        if aux > valor_func,

            valor_func = aux;
            seleccionada = i;

        end
        
        norm(i) = aux;
    end
    
    norm = norm./max(norm);
    for i=1:length(norm),
        fprintf(result_norm, '%G\n', norm(i));
    end

else    
    
    % Funciones que necesitan el stack entero
    datos_threshold = cell(20, 1);
    for i=1:20,
        datos_threshold{i} = imread(sprintf('%s/%s%02d-%s.tif', ...
            dir, base_nombre(1:15), i, filtro_lista{filter+1}), 'tif');
    end    
    
    if (func == 6)
        tic;
        [valores, seleccionada] = threshold_func(datos_threshold);
        tiempo = tiempo + toc;        
    end
    
    valores = cell2mat(valores);
    valores_norm = valores./max(valores);
    
    for i=1:length(valores),
        fprintf(result_handle, '%G\n', valores(i));
        fprintf(result_norm, '%G\n', valores_norm(i));     
    end
end

fclose(result_handle);
fclose(result_norm);

end
