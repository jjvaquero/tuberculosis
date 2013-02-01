

 FUNCTION Write_archive, file, strarr_in, NO_EMPTY=no_empty

;---------------------------------------------------------------------------------------
; Función de escritura en un archivo ascii de un array de strings
; Cada fila acabada en un RETURN es una celda del array de salida
;
; NO-EMPTY - No escribe lineas vacías
;---------------------------------------------------------------------------------------

T = SYSTIME(1)

IF KEYWORD_SET(no_empty) THEN opt_noempty = 1 ELSE opt_noempty = 0

n_lines = N_ELEMENTS(strarr_in)

;------------------------------------------------------------
OPENW, unit, file, /GET_LUN

IF opt_noempty EQ 0 THEN BEGIN
	FOR i=0L, n_lines-1 DO BEGIN
		PRINTF, unit, strarr_in[i]
	ENDFOR
ENDIF ELSE BEGIN
	FOR i=0L, n_lines-1 DO BEGIN
		IF strarr_in NE '' THEN $
			PRINTF, unit, strarr_in[i]
	ENDFOR
ENDELSE

CLOSE,    unit
FREE_LUN, unit
;------------------------------------------------------------



PRINT, 'Tiempo de escritura de archivo  :', SYSTIME(1) - T


RETURN, 1

END


