
FUNCTION binreg_CenterMass, image_o, image_gray, OPTION=option, FLOATING=floating

; Obtiene las coordenadas (x,y) del centro de masas o gravedad de una imagen binaria
; (1 - Objeto, 0 - fondo)
;
; Si se añade una segunda imagen, entonces se calcula el centro de masas de imagen de gris
; Se redondea al entero más próximo, salvo con la opción FLOAT
;
;--------------------------------------------------------------------------------------

IF KEYWORD_SET(floating) THEN opt_float = 1 ELSE opt_float = 0
IF N_PARAMS() EQ 2 THEN opt_gray = 1 ELSE opt_gray = 0

tam = SIZE(image_o)
xsize = tam[1]
ysize = tam[2]
xysize = LONG(xsize)*ysize

;------------------------------------------------------------

arr_imag = WHERE(image_o EQ 1)
IF arr_imag[0] EQ -1 THEN RETURN, 0

n_pixels = FLOAT(N_ELEMENTS(arr_imag))

arr_y = FLOAT((arr_imag / xsize)   + 1)	; El menor es 1, no cero
arr_x = FLOAT((arr_imag MOD xsize) + 1)

;------------------------------------------------------------

IF opt_gray EQ 0 THEN BEGIN
	c_x = TOTAL(arr_x)/n_pixels
	c_y = TOTAL(arr_y)/n_pixels
ENDIF

IF opt_gray EQ 1 THEN BEGIN ; Centro de masas de imagen de gris

	arr_val = FIX(image_gray[arr_imag]) + 1

	c_x = TOTAL(arr_x*arr_val)/TOTAL(arr_val)
	c_y = TOTAL(arr_y*arr_val)/TOTAL(arr_val)
ENDIF


IF opt_float EQ 0 THEN BEGIN
	c_x = FIX(ROUND(c_x)) - 1	; Se resta el punto de antes, para indexar a cero
	c_y = FIX(ROUND(c_y)) - 1
ENDIF
IF opt_float EQ 1 THEN BEGIN
	c_x = c_x - 1
	c_y = c_y - 1
ENDIF

;------------------------------------------------------------

RETURN, [c_x, c_y]

END

;------------------------------------------------------------