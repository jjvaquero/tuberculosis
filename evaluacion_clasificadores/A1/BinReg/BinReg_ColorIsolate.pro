
FUNCTION binreg_Colorisolate, arr_orig, imag_orig, XSIZE=xsize, YSIZE=ysize

; Esta función tiene el objetivo de separar la parte de la imagen que contenga
; una región binaria dada. Pero en la imagen de color asociada
;
; La entrada son los indices de los puntos, en valor x,y absolutos con los
; parámetros XSIZE e YSIZE. Además de la imagen de color asociada (tres canales)
; Detecta automáticamente si está en TRUE=1, o TRUE=3
;
;
; im_sal = binreg_colorisolate(arr_orig, imag_orig, XSIZE=xsize, YSIZE=ysize)
;--------------------------------------------------------------------------------------

IF NOT KEYWORD_SET(image) THEN opt_imag = 0 ELSE opt_imag = 1


IF N_ELEMENTS(xsize) AND N_ELEMENTS(ysize) THEN BEGIN

	tam_col = SIZE(imag_orig)

	IF tam_col[1] EQ 3 THEN opt_true = 1
	IF tam_col[3] EQ 3 THEN opt_true = 3

	arr_x = LONG(arr_orig) MOD xsize
	arr_y = LONG(arr_orig) / xsize

	min_x = MIN(arr_x)
	max_x = MAX(arr_x)
	min_y = MIN(arr_y)
	max_y = MAX(arr_y)

	tam_x = max_x - min_x + 1
	tam_y = max_y - min_y + 1

	arr_x = arr_x - min_x
	arr_y = arr_y - min_y

	;arr_sal = arr_x + (tam_x*arr_y)

	IF opt_true EQ 1 THEN imag_sal = imag_orig[*, min_x:max_x, min_y:max_y]
	IF opt_true EQ 2 THEN imag_sal = imag_orig[min_x:max_x, *, min_y:max_y]
	IF opt_true EQ 3 THEN imag_sal = imag_orig[min_x:max_x, min_y:max_y, *]

	RETURN, imag_sal

ENDIF


RETURN, -1

END