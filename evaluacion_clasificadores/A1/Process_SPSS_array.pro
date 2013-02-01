

 FUNCTION Process_SPSS_array, strarr_in, SEPARATE=separate, NORMALIZE=normalize, $
 								COMMAS = commas, CLASSES=classes

;---------------------------------------------------------------------------------------
; Función de procesado de un array de strings en formato tabuladores
;
; La estructura es de columna, El primer elemento tiene los nombres de las variables
; Los demás elementos son los que hay que procesar
;
; opciones:
;
; SEPARATE   - solamente separa el array en una matriz de variables,
; NORMALIZE  - Normaliza las variables en flotante entre 0 y 1
; CLASSES    - Borra las filas que no son de clase 0 o 1 (la variable nº4)
; COMMAS     - Cambia puntos por comas (para compatibilidad con SPSS)
;
;---------------------------------------------------------------------------------------

T = SYSTIME(1)

IF KEYWORD_SET(separate)  THEN opt_separate  = 1 ELSE opt_separate = 0
IF KEYWORD_SET(normalize) THEN opt_normalize = 1 ELSE opt_normalize= 0
IF KEYWORD_SET(commas)    THEN opt_commas    = 1 ELSE opt_commas   = 0
IF KEYWORD_SET(classes)   THEN opt_classes   = 1 ELSE opt_classes  = 0


;---------------------------------------------------------------------------------------

strarr_file = ''
str_line    = ''
str_tab     =  STRING(9B)
i = 0

n_files = N_ELEMENTS(strarr_in)

str_names    = strarr_in[0]
strarr_files = strarr_in[1:n_files-1]

n_files = n_files - 1

strarr_prueba = STRSPLIT(str_names, str_tab, /EXTRACT)
n_vars = N_ELEMENTS(strarr_prueba) ; Número de variables

strmat_vars = STRARR(n_vars, n_files)

;------------------------------------------------------------
FOR i=0L, n_files-1 DO BEGIN

	strarr_vars = STRSPLIT(strarr_files[i], str_tab, /EXTRACT)
	IF N_ELEMENTS(strarr_vars) NE n_vars THEN BEGIN
		PRINT, 'Formato de archivo inválido, distinto número de variables por fila'
		RETURN, -3
	ENDIF
	strmat_vars[*,i] = strarr_vars
ENDFOR
;------------------------------------------------------------

IF opt_separate EQ 1 THEN BEGIN
	PRINT, 'Tiempo de lectura y proceso de archivo  :', SYSTIME(1) - T
	RETURN, strmat_vars
ENDIF

;------------------------------------------------------------
first_var = 4 ; La primera variable a normalizar está en la columna 4

IF opt_normalize EQ 1 THEN BEGIN
	FOR i=first_var, n_vars-1 DO BEGIN
		array_var = FLOAT(strmat_vars[i, *])
		array_varnor = var_normalize_2(array_var)
		strmat_vars[i, *] = STRTRIM(STRING(array_varnor, FORMAT ='(F33.8)'), 2)
	ENDFOR
ENDIF

IF (opt_commas EQ 0) AND (opt_classes EQ 0) THEN BEGIN
	strarr_out = STRARR(1, n_files)
	FOR i=0L, n_files-1 DO BEGIN
		str_file = strmat_vars[0,i]
		FOR j=1L, n_vars-1 DO BEGIN
			str_file = str_file + str_tab + strmat_vars[j,i]
		ENDFOR
		strarr_out[i] = str_file
	ENDFOR
ENDIF


IF (opt_commas EQ 1) OR (opt_classes EQ 1) THEN BEGIN
	strarr_out = ''
	FOR i=0L, n_files-1 DO BEGIN
		IF FIX(strmat_vars[3,i]) LE 1 THEN BEGIN
			str_file = strmat_vars[0,i]
			FOR j=1L, n_vars-1 DO BEGIN
				str_file = str_file + str_tab + strmat_vars[j,i]
			ENDFOR
			strarr_out = [[strarr_out], [str_file]]
		ENDIF
	ENDFOR
	n_files = N_ELEMENTS(strarr_out)
	strarr_out = strarr_out[1:n_files-1]
	n_files = n_files-1
	strarr_out = REFORM(strarr_out,1, n_files)

ENDIF

strarr_out = [[str_names], [strarr_out]]
PRINT, 'Tiempo de proceso de archivo  :', SYSTIME(1) - T
RETURN, strarr_out

END


