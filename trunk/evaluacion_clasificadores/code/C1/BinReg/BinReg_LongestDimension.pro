
FUNCTION binreg_LongestDimension, image_o

; Retorna la distancia máxima entre dos puntos del perímetro de una región binaria
;
; Es el parámetro "longest Dimension" de [Jain96]
;
;
;--------------------------------------------------------------------------------------


tam = SIZE(image_o)
xsize = tam[1]
ysize = tam[2]
xysize = LONG(xsize)*ysize

;------------------------------------------------------------

imag_front = fronterabin(image_o)	; Imagen Frontera

arr_front = WHERE(imag_front EQ 1)

arr_x = FLOAT(arr_front MOD xsize)
arr_y = FLOAT(arr_front / xsize)

n_pixels = N_ELEMENTS(arr_front)

max_dist = 0

FOR i=0L, n_pixels-1 DO BEGIN
	FOR j=0L, n_pixels-1 DO BEGIN
		dist_ij = SQRT(((arr_x[i]-arr_x[j])^2)+((arr_y[i]-arr_y[j])^2))
		max_dist = MAX([max_dist, dist_ij])
	ENDFOR
ENDFOR

RETURN, max_dist

END

;------------------------------------------------------------