


PRO fbat_ProcessFiles_all

; Aquí se pretende procesar los archivos de tabuladores para entre otras cosas:
; - Normalizar las variables entre 0 y 1
; - Eliminar las clases 2 y 3
; - Cambiar puntos por comas
;---------------------------------------------------------------------

T = SYSTIME(1)

str_file1 = 'Tabfile_all_iSAM.txt'
;str_file1 = 'Tabfile_all_x100_iSAM.txt'
;str_file2 = 'Tabfile_all_x100_iM.txt'

str_disk = 'e:\'
str_path = 'micro\results\files_tab_all\'

path_file1 = str_disk + str_path + str_file1
;path_file2 = str_disk + str_path + str_file2

new_file1 = path_file1 + '.txt'
;new_file2 = path_file2 + '.txt



strarr_file = read_archive(path_file1)

strarr_new = process_spss_array(strarr_file, /NORMALIZE, /CLASSES)

ok = write_archive(new_file1, strarr_new)




PRINT, '----------------------------------------------------------------'
PRINT, 'TIEMPO TOTAL  :', SYSTIME(1)- T
PRINT, '----------------------------------------------------------------'

END