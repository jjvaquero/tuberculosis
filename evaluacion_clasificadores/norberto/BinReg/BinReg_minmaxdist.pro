
FUNCTION binreg_minmaxdist, image_o, centermass, front_point

; Calcula los dos puntos de la imagen binaria más alejados del eje definido
; por los dos puntos de entrada
; Salida en formato de matriz 2x2 (min,max)
; Se corresponde con la función "minmax_dist" de [Parker]
;
;
;--------------------------------------------------------------------------------------

tam = SIZE(image_o)
xsize = tam[1]
ysize = tam[2]
xysize = LONG(xsize)*ysize

;------------------------------------------------------------

c_x = FLOAT(centermass[0])
c_y = FLOAT(centermass[1])
p_x = FLOAT(front_point[0])
p_y = FLOAT(front_point[1])

;------------------------------------------------------------

IF (c_x EQ p_x) AND (c_y EQ p_y) THEN RETURN, -1

;------------------------------------------------------------
; Equation of the line is a*x + b*y +c = 0

a = p_y - c_y
b = c_x - p_x
c = (-(c_x - p_x)*c_y) + ((c_y - p_y)*c_x)
e = a*a + b*b
dist_min = 10.0E30
dist_max = 0.0

;------------------------------------------------------------

arr_imag = WHERE(image_o EQ 1)
IF arr_imag[0] EQ -1 THEN RETURN, -1

n_pixels = FLOAT(N_ELEMENTS(arr_imag))

arr_y = FLOAT((arr_imag / xsize)   )	; El menor es 1, no cero
arr_x = FLOAT((arr_imag MOD xsize) )

p_min = FLOAT([0,0])
p_max = FLOAT([0,0])
;------------------------------------------------------------

FOR i=0L, n_pixels -1 DO BEGIN
	f = a*arr_x[i] + b*arr_y[i] + c
	;PRINT, f
	;PRINT, [arr_x[i], arr_y[i]]
	IF f LE dist_min THEN BEGIN
		p_min = [arr_x[i], arr_y[i]]
		dist_min = f
	ENDIF
	IF f GE dist_max THEN BEGIN
		p_max = [arr_x[i], arr_y[i]]
		dist_max = f
	ENDIF
ENDFOR

;------------------------------------------------------------

RETURN, FIX(ROUND([[p_min], [p_max]]))

END

;------------------------------------------------------------