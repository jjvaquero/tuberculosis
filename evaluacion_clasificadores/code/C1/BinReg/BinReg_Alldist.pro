
FUNCTION binreg_Alldist, image_o, centermass, front_point

; Calcula la distancia entre un eje definido por dos puntos y la región binaria
; Se corresponde con la función "all_dist" de [Parker]
;
; Los dos puntos están dados en formato x-y
; si coinciden, la distancia dada será 1
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
dist = 0.0

;------------------------------------------------------------

arr_imag = WHERE(image_o EQ 1)
IF arr_imag[0] EQ -1 THEN RETURN, -1

n_pixels = FLOAT(N_ELEMENTS(arr_imag))

arr_y = FLOAT((arr_imag / xsize)   )	; El menor es 1, no cero
arr_x = FLOAT((arr_imag MOD xsize) )


FOR i=0L, n_pixels -1 DO BEGIN
	f = a*arr_x[i] + b*arr_y[i] + c
	f = f*f/e
	dist = dist + SQRT(f)
ENDFOR

;------------------------------------------------------------

RETURN, dist

END

;------------------------------------------------------------