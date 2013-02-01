

 FUNCTION Read_SPSS_archive, file, NAMES=names

;---------------------------------------------------------------------------------------
; Función de lectura de un fichero de datos tipo tabulador. Almacena la salida en una
; estructura con:
; Array de strings con los nombres de las variables, si NAMES está habilitada
; o Bien:
; Matriz de strings con los valores (posteriormente habría que distinguir cuales son
; variables string o numéricas
;
;
; file = 'e:\micro\results\images_positive\21_09_01\image2_IDL_spss_iSA.txt'
; r = read_spss_archive_2(file)
;---------------------------------------------------------------------------------------

IF KEYWORD_SET(names) THEN opt_names = 1 ELSE opt_names = 0

IF NOT FILE_TEST(file) THEN BEGIN
	PRINT, ' Archivo inexistente'
	RETURN, -1
ENDIF

strarr_file = ''
str_line = ''
str_tab =  STRING(9B)
i = 0

T = SYSTIME(1)

;------------------------------------------------------------
OPENR, unit, file, /GET_LUN

IF opt_names EQ 1 THEN BEGIN	; solamente lee la primera fila
	READF, unit, str_line
	strarr_file[i] = str_line
    strarr_file    = [[strarr_file],['']]
    i=i+1
ENDIF

IF opt_names EQ 0 THEN BEGIN
	WHILE NOT EOF(unit) DO BEGIN
	    READF, unit, str_line
	    strarr_file[i] = str_line
	    strarr_file    = [[strarr_file],['']]
	    i=i+1
	ENDWHILE
ENDIF

CLOSE,    unit
FREE_LUN, unit
;------------------------------------------------------------

IF i LE 0 THEN BEGIN
	PRINT, 'No existen variables que leer'
	RETURN, -2
ENDIF
;------------------------------------------------------------

strarr_file = strarr_file[*, 0:i-1]
n_files = N_ELEMENTS(strarr_file)

strarr_vars = STRSPLIT(str_line, str_tab, /EXTRACT)
n_vars = N_ELEMENTS(strarr_vars) ; Número de variables


strmat_vars = STRARR(n_vars, n_files)

;------------------------------------------------------------
FOR j=0, n_files -1 DO BEGIN

	strarr_vars = STRSPLIT(strarr_file[j], str_tab, /EXTRACT)
	IF N_ELEMENTS(strarr_vars) NE n_vars THEN BEGIN
		PRINT, 'Formato de archivo inválido, distinto número de variables por fila'
		RETURN, -3
	ENDIF
	strmat_vars[*,j] = strarr_vars
ENDFOR
;------------------------------------------------------------

PRINT, 'Tiempo de lectura y proceso de archivo  :', SYSTIME(1) - T


RETURN, strmat_vars

END


