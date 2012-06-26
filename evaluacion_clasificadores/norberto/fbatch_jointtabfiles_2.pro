

FUNCTION fbatch_jointtabfiles_2, NUMBER=number, REVERSE=reverse, STR=str, HEAD=head, $
								ELIM_BAD=elim_bad

; ok =  fbatch_jointtabfiles_2(NUMBER=10, REVERSE=0, STR='iSA.txt')
;
; Esta función es de gestión de archivos de texto
;
; Une las filas con terminación "str" del directorio principal de resultados
; La opción HEAD quita la primera linea de todos los archivos menos el primero
; La opción NUMBER solamente procesa como máximo ese número de archivos, en orden alfabético
; empezando desde el final si la keyword REVERSE está habilitada
;
; lña opción ELIM_BAD elimina las lineas que contengan 'NaN'
;
; Al ser de tipo "batch" aunque sigue siendo una función, algunos parámetros se introducirán
; internamente (en el código) por defecto. (como por ejemplo el directorio de partida
;
;
;-----------------------------------------------------------------------------

IF KEYWORD_SET(reverse)   THEN opt_reverse = 1 ELSE opt_reverse = 0
IF KEYWORD_SET(head)      THEN opt_head    = 1 ELSE opt_head    = 0
IF KEYWORD_SET(elim_bad)  THEN opt_elimbad = 1 ELSE opt_elimbad = 0
IF N_ELEMENTS(str) EQ 0   THEN str_endfile = 'iS.txt' ELSE str_endfile = str
IF N_ELEMENTS(number) EQ 0 THEN numbers = 0 ELSE numbers = FIX(number)

str_disk = 'e:' ;'d:'

path_files_results  = str_disk + '\micro\results\'

pathadd_directory = ''
pathadd_session   = ''
path_results  = path_files_results  + pathadd_directory + pathadd_session

pathw_results = STRMID(path_results, 0, STRLEN(path_results)-1)

IF FILE_TEST(pathw_results, /DIRECTORY) EQ 0 THEN BEGIN
	PRINT, 'Directorio no válido'
	RETURN, -1
ENDIF

str_numbers = 'x'+STRTRIM(STRING(numbers),2)

; Busca todas las filas de texto del directorio coincidentes con str
;-------------------------------------------------------------------------------

str_outputfile = path_files_results + 'files_tab\'+ 'Tabfile_' + 'all_' +str_numbers+ '_' + str_endfile

strarr_files = FINDFILE(path_results + '*' + str_endfile, COUNT=n_files)
IF n_files EQ 0 THEN BEGIN
	PRINT, 'No existe ningún archivo que concuerde'
	RETURN, -1
ENDIF
strarr_files = STRLOWCASE(strarr_files)
pos_order = SORT(strarr_files)
strarr_files = strarr_files[pos_order]

IF numbers NE 0 THEN BEGIN	; no se procesan todos
	IF numbers LT n_files THEN BEGIN
		IF opt_reverse EQ 0 THEN BEGIN
			strarr_files = strarr_files[0:numbers-1]
		ENDIF
		IF opt_reverse EQ 1 THEN BEGIN
			strarr_files = strarr_files[n_files-numbers:n_files-1]
		ENDIF
		n_files = N_ELEMENTS(strarr_files)
	ENDIF
ENDIF

;--------------------------------------------------------------------
; Ahora abre todos los archivos secuencialmente y los pone en el de
; salida. fila a fila
; Comprueba que la primera linea sea la cabecera, y la quita

j_begin = 0L

OPENW, unit, str_outputfile, /GET_LUN

IF opt_elimbad EQ 0 THEN BEGIN
	FOR i=0L, n_files-1 DO BEGIN
		strarr_1 = read_archive(strarr_files[i])
		IF opt_head EQ 1 THEN BEGIN	; Hay que quitar la primera fila
			IF (i NE 0) THEN j_begin = 1L ELSE j_begin = 0L
		ENDIF
		n_lines = N_ELEMENTS(strarr_1)
		IF n_lines-1 GE j_begin THEN BEGIN
			FOR j=j_begin, n_lines-1 DO BEGIN
				IF strarr_1[j] NE '' THEN $
					PRINTF, unit, 'c'+ strarr_1[j]
			ENDFOR
		ENDIF
	ENDFOR
ENDIF

IF opt_elimbad EQ 1 THEN BEGIN	;eliminando malas filas
	FOR i=0L, n_files-1 DO BEGIN
		strarr_1 = read_archive(strarr_files[i])
		IF opt_head EQ 1 THEN BEGIN	; Hay que quitar la primera fila
			IF (i NE 0) THEN j_begin = 1L ELSE j_begin = 0L
		ENDIF
		n_lines = N_ELEMENTS(strarr_1)
		IF n_lines-1 GE j_begin THEN BEGIN
			FOR j=j_begin, n_lines-1 DO BEGIN
				IF strarr_1[j] NE '' THEN BEGIN
					pos = STRPOS(strarr_1[j], 'NaN')
					IF pos EQ -1 THEN $
						PRINTF, unit, 'c'+ strarr_1[j]
				ENDIF
			ENDFOR
		ENDIF
	ENDFOR
ENDIF

CLOSE, unit
FREE_LUN, unit
;--------------------------------------------------------------------

RETURN, 1


END










