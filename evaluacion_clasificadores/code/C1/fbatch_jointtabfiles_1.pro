

FUNCTION fbatch_jointtabfiles_1, CULTURE=culture, STR=str

; ok =  fbatch_jointtabfiles_1(CULTURE='21_09_01', STR='iSA.txt')
;
; Esta función es de gestión de archivos de texto
;
; Une las filas con terminación "str" de un directorio
; ;
;
; Al ser de tipo "batch" aunque sigue siendo una función, algunos parámetros se introducirán
; internamente (en el código) por defecto. (como por ejemplo el directorio de partida
;
;
;-----------------------------------------------------------------------------

str_disk = 'e:' ;'f:'

path_files_results  = str_disk + '\micro\results\'

IF N_ELEMENTS(str) EQ 0 THEN str_endfile = 'iS.txt' ELSE str_endfile = str

IF N_ELEMENTS(culture) EQ 0 THEN BEGIN
	culture = '21_09_01'
	pathadd_directory    = culture + '\'  ; 13_10_01\ ; 27_09_01
ENDIF ELSE BEGIN
	IF STRPOS(culture, '\') EQ -1 THEN $
		pathadd_directory    = culture +'\' $
	ELSE pathadd_directory   = culture
ENDELSE

pathadd_session      = ''
path_results  = path_files_results  + pathadd_directory + pathadd_session

pathw_results = STRMID(path_results, 0, STRLEN(path_results)-1)

IF FILE_TEST(pathw_results, /DIRECTORY) EQ 0 THEN BEGIN
	PRINT, 'Directorio no válido'
	RETURN, -1
ENDIF

;str_endfile = str


; Busca todas las filas de texto del directorio coincidentes con str
;-------------------------------------------------------------------------------

str_outputfile = path_files_results + 'Tabfile_' + culture + '_' + str_endfile

strarr_files = FINDFILE(path_results + '*' + str_endfile, COUNT=n_files)
IF n_files EQ 0 THEN BEGIN
	PRINT, 'No existe ningún archivo que concuerde'
	RETURN, -1
ENDIF
strarr_files = STRLOWCASE(strarr_files)
pos_order = SORT(strarr_files)
strarr_files = strarr_files[pos_order]

;--------------------------------------------------------------------
; Ahora abre todos los archivos secuencialmente y los pone en el de
; salida. fila a fila


OPENW, unit, str_outputfile, /GET_LUN

FOR i=0L, n_files-1 DO BEGIN
	strarr_1 = read_archive(strarr_files[i])
	n_lines = N_ELEMENTS(strarr_1)
	FOR j=0L, n_lines-1 DO BEGIN
		IF strarr_1[j] NE '' THEN $
			PRINTF, unit, strarr_1[j]
	ENDFOR
ENDFOR

CLOSE, unit
FREE_LUN, unit
;--------------------------------------------------------------------

RETURN, 1


END










