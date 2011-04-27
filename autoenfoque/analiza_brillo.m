function void = analiza_brillo
% evalua_enfoques evalúa los distintos algoritmos de autoenfoque
% mezclándolos con distintos tipos de filtrado:
% - Filtrado de mediana 2x2.
% - Filtrado de mediana 4x4.
% - Filtrado de mediana 8x8.
% - Filtrado top-hat.

PATH_DATA = 'C:/CURRENT/stacks_paper_micro/';

void = 0; 
dir_list = dir(PATH_DATA);
file_brillo = fopen(sprintf('%s/brillo.txt', PATH_DATA), 'w');
brillo = uint32(zeros(20, 1));

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
        
        brillo(j) = sum(sum(orig_img_green));          
                
    end
    
    brillo_medio = sum(brillo)/20;
    fprintf(file_brillo, '%G\n', brillo_medio);
    
           
end

fclose(file_brillo);

end
