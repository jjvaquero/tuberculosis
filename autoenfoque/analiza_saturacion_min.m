function void = analiza_saturacion_min
% evalua_enfoques evalúa los distintos algoritmos de autoenfoque
% mezclándolos con distintos tipos de filtrado:
% - Filtrado de mediana 2x2.
% - Filtrado de mediana 4x4.
% - Filtrado de mediana 8x8.
% - Filtrado top-hat.

PATH_DATA = 'C:/CURRENT/stacks_paper_micro/';

void = 0; 
dir_list = dir(PATH_DATA);
file_saturacion = fopen(sprintf('%s/minimos.txt', PATH_DATA), 'w');
saturacion = uint32(zeros(300, 1))+255;

for i=3:length(dir_list),
    %
    % BUCLE PRINCIPAL
    %
    
    nextfile_str = sprintf('%s/%s/', PATH_DATA, dir_list(i).name);    
    nextfile = dir(sprintf('%s/*bmp', nextfile_str));
    
    disp(sprintf('Procesando directorio %s', dir_list(i).name));     
      
    for j=1:20,

        orig_img = imread(sprintf('%s/%s', nextfile_str, nextfile(j).name));
        
        % Cojo el canal verde
        orig_img_green = orig_img(:,:,2);
        
        minimo = min(min(orig_img_green));
        
        if (minimo < saturacion(i-2))
            saturacion(i-2) = minimo;
        end           
        
    end
    
    fprintf(file_saturacion, '%G\n', saturacion(i-2));
               
end

fclose(file_saturacion);

