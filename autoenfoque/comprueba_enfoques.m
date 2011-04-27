function exit_status = comprueba_enfoques(input_dir, output_dir, filtro)

exit_status = 0; 

% input_dir = directorio de entrada. El contenido son directorios numerados
% según el patrón 01, 02, 03... Dentro de esos directorios están las
% imágenes a enfocar
% output_dir = directorio de salida. Ahí se escribirán las gráficas para
% cada enfoque y un archivo de texto con los resultados de cada algoritmo

reslog = 'loghist ';
resrob = 'robust ';
resvol = 'vollath ';
reslap = 'laplacian ';

if nargin < 3, return; end;

data_dirs = dir(input_dir);

if ~isdir(output_dir)
    disp('El directorio de salida tiene que existir');
    return
end

resultados = fopen(sprintf('%s\\resultados.txt', output_dir), 'w');

for i = 3:length(data_dirs),
    if data_dirs(i).isdir
        datos = sprintf('%s\\%s\\', input_dir, data_dirs(i).name);
        disp(sprintf('Enfocando directorio %s', datos));
        [log, rob, vol, lap] = comprueba_enfoques_func(datos, 'bmp', output_dir, filtro, ...
            data_dirs(i).name);
        reslog = sprintf('%s %d', reslog, log);
        resrob = sprintf('%s %d', resrob, rob);
        resvol = sprintf('%s %d', resvol, vol);
        reslap = sprintf('%s %d', reslap, lap);
    else
        continue
    end
    
    
end

fprintf(resultados, '%s\n', reslog);
fprintf(resultados, '%s\n', resrob);
fprintf(resultados, '%s\n', resvol);
fprintf(resultados, '%s\n', reslap);
fclose(resultados);
% disp(reslog);
% disp(resrob);
% disp(resvol);
% disp(reslap);

end