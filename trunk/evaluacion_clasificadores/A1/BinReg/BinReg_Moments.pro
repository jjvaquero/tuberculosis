
FUNCTION binreg_Moments, image_o, image_gray, NI=ni, NJ=nj, NORMALIZE=normalize

; Obtiene los momentos centrales de una imagen binaria (momento, ni, nj)
; (1 - Objeto, 0 - fondo)
;
; Con la opción NORMALIZE se calculan los momentos standard
; Si se añade una segunda imagen, entonces se calculan los momentos de imagen de gris
;
;
;--------------------------------------------------------------------------------------

IF N_PARAMS() EQ 2 THEN opt_gray = 1 ELSE opt_gray = 0
IF KEYWORD_SET(normalize) THEN opt_normal = 1 ELSE opt_normal = 0

IF N_ELEMENTS(ni) EQ 0 THEN RETURN, -1
IF N_ELEMENTS(nj) EQ 0 THEN RETURN, -1

;--------------------------------------------------------------------------------------

tam = SIZE(image_o)
xsize = tam[1]
ysize = tam[2]
xysize = LONG(xsize)*ysize

;------------------------------------------------------------

arr_imag = WHERE(image_o EQ 1)
IF arr_imag[0] EQ -1 THEN RETURN, -1

n_pixels = FLOAT(N_ELEMENTS(arr_imag))

arr_y = FLOAT((arr_imag / xsize)  ) + 1
arr_x = FLOAT((arr_imag MOD xsize)) + 1

;------------------------------------------------------------

IF opt_gray EQ 0 THEN BEGIN
	c_x = (TOTAL(arr_x)/n_pixels)
	c_y = (TOTAL(arr_y)/n_pixels)
ENDIF
IF opt_gray EQ 1 THEN BEGIN ; Centro de masas de imagen de gris

	arr_val = image_gray[arr_imag]

	c_x = (TOTAL(arr_x*arr_val)/ TOTAL(arr_val))
	c_y = (TOTAL(arr_y*arr_val)/ TOTAL(arr_val))
ENDIF
;------------------------------------------------------------

IF opt_gray EQ 0 THEN BEGIN
	moment = TOTAL(((arr_x-c_x)^ni)*((arr_y-c_y)^nj))
    IF opt_normal EQ 1 THEN moment = moment/n_pixels

ENDIF

IF opt_gray EQ 1 THEN BEGIN ; Centro de masas de imagen de gris
	moment = TOTAL(((arr_x-c_x)^ni)*((arr_y-c_y)^nj)*image_gray[arr_imag])
	IF opt_normal EQ 1 THEN moment = moment/TOTAL(image_gray[arr_imag])

ENDIF



;------------------------------------------------------------

RETURN, moment

END

;------------------------------------------------------------