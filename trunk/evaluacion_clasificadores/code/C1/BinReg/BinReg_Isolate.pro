
FUNCTION binreg_isolate, arr_orig, XSIZE=xsize, YSIZE=ysize, IMAGE=image

; Esta función tiene el objetivo de separar la parte de la imagen que contenga
; una región binaria dada.
;
; La entrada son los indices de los puntos, en valor x,y. O bien absolutos con los
; parámetros XSIZE e YSIZE
;
; La salida pueden ser los indices reformateados o una imagen, según la orden /IMAGE
;
; im_sal = binreg_isolate(arr_orig, XSIZE=xsize, YSIZE=ysize, /IMAGE)
;--------------------------------------------------------------------------------------

IF NOT KEYWORD_SET(image) THEN opt_imag = 0 ELSE opt_imag = 1


IF N_ELEMENTS(xsize) AND N_ELEMENTS(ysize) THEN BEGIN

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

	arr_sal = arr_x + (tam_x*arr_y)

	IF opt_imag EQ 0 THEN BEGIN
		RETURN, arr_sal
	ENDIF

	IF opt_imag EQ 1 THEN BEGIN
		im_sal = BYTARR(tam_x, tam_y)
		im_sal[arr_sal] = 1
		RETURN, im_sal
	ENDIF

ENDIF

RETURN, -1

END