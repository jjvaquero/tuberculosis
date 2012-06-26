
FUNCTION binreg_PrincipalAxis, image_o

; Obtiene las coordenadas [x,y]) de dos extremos del eje principal de una imagen binaria
; y del centro de masas (por el que debe pasar)
; El formato de salida es un matriz 2x3
; (1 - Objeto, 0 - fondo)
;
; Según el algoritmo propuesto por [Parker]
;
;--------------------------------------------------------------------------------------

imag = image_o

tam = SIZE(image_o)
xsize = tam[1]
ysize = tam[2]
xysize = LONG(xsize)*ysize
;------------------------------------------------------------

centermass = binreg_centermass(image_o)
c_x = FLOAT(centermass[0])
c_y = FLOAT(centermass[1])
centermassxy = c_x + c_y*xsize

;------------------------------------------------------------

imag_front = binreg_frontier(image_o)

arr_border = WHERE(imag_front EQ 1)
IF arr_border[0] EQ -1 THEN RETURN, -1

pos_1 = WHERE(arr_border LT centermassxy)
pos_2 = WHERE(arr_border GT centermassxy)
IF pos_1[0] NE -1 THEN $
	arr_border_1 = arr_border[pos_1] $
ELSE $
	arr_border_1 = centermassxy
IF pos_2[0] NE -1 THEN $
	arr_border_2 = arr_border[pos_2] $
ELSE $
	arr_border_2 = centermassxy


n_pixels_1 = FLOAT(N_ELEMENTS(arr_border_1))
n_pixels_2 = FLOAT(N_ELEMENTS(arr_border_2))

arr_y1 = FLOAT((arr_border_1 / xsize)  )
arr_x1 = FLOAT((arr_border_1 MOD xsize))
arr_y2 = FLOAT((arr_border_2 / xsize)  )
arr_x2 = FLOAT((arr_border_2 MOD xsize))

;------------------------------------------------------------
paxis_1 = centermass
paxis_2 = centermass
paxis_3 = centermass
;-------------------------------------------------------------
dist_min = FLOAT(10e30)
FOR i=0L, n_pixels_1-1 DO BEGIN
	dist = Binreg_alldist(image_o, centermass, [arr_x1[i], arr_y1[i]])
	IF dist NE -1 THEN BEGIN
		IF dist LE dist_min THEN BEGIN
			dist_min = dist
			paxis_1   = [arr_x1[i], arr_y1[i]]
		ENDIF
	ENDIF
ENDFOR
IF dist_min EQ 10e30 THEN BEGIN	; Error, o solamente un punto en la region
	paxis_1 = centermass
ENDIF
dist_min = FLOAT(10e30)
;------------------------------------------------------------
FOR i=0L, n_pixels_2-1 DO BEGIN
	dist = Binreg_alldist(image_o, centermass, [arr_x2[i], arr_y2[i]])
	IF dist NE -1 THEN BEGIN
		IF dist LE dist_min THEN BEGIN
			dist_min = dist
			paxis_2   = [arr_x2[i], arr_y2[i]]
		ENDIF
	ENDIF
ENDFOR
IF dist_min EQ 10e30 THEN BEGIN	; Error, o solamente un punto en la region
	paxis_2 = centermass
ENDIF
;------------------------------------------------------------

ret =[[paxis_1], [paxis_2], [centermass]]

RETURN, FIX(ROUND(ret))

END

;------------------------------------------------------------