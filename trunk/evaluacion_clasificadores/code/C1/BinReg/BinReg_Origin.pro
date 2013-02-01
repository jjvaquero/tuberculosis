
FUNCTION binreg_origin, arr_orig, XSIZE=xsize, YSIZE=ysize

; Esta función devuelve las coordenadas del origen de una región dada por sus puntos
; La salida es en formato (x,y)
; Esquina izquierda y arriba del cuadrado a 90 grados que contiene a la región
; una región binaria dada.
;
; La entrada son los indices de los puntos, en valor x,y. O bien absolutos con los
; parámetros XSIZE e YSIZE
;
; Esta función debe estar "sincronizada" con binreg_isolate.
;
; origin = binreg_origin(arr_orig, XSIZE=xsize, YSIZE=ysize)
;--------------------------------------------------------------------------------------

IF NOT KEYWORD_SET(image) THEN opt_imag = 0 ELSE opt_imag = 1

IF N_ELEMENTS(xsize) AND N_ELEMENTS(ysize) THEN BEGIN

	arr_x = LONG(arr_orig) MOD xsize
	arr_y = LONG(arr_orig) / xsize

	min_x = MIN(arr_x)
	min_y = MIN(arr_y)

	RETURN, [min_x, min_y]

ENDIF


RETURN, -1

END