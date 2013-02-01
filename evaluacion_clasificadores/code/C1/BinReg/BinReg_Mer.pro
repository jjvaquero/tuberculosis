
FUNCTION binreg_Mer, image_o, AXIS_LENGTH = axis_length, FLOATING=floating

; Devuelve las coordenadas (x,y) del mínimo rectángulo que contiene a la región binaria
; El formato de salida es un matriz 2x4
; Los valores de coordenada pueden ser negativos. Se corresponde a la función "mer"
; de Parker
;
; Con la opción axis_length, devielve los valores de longitud del eje mayor y el menor
; Con la opción FLOATING, no redondea el valor a entero
; ;
;--------------------------------------------------------------------------------------

IF KEYWORD_SET(axis_length) THEN opt_axis = 1 ELSE opt_axis = 0
IF KEYWORD_SET(floating)    THEN opt_float= 1 ELSE opt_float= 0

tam = SIZE(image_o)
xsize = tam[1]
ysize = tam[2]
xysize = LONG(xsize)*ysize

;------------------------------------------------------------
;centermass = Binreg_centermass(image_o)
p_axis = BinReg_PrincipalAxis(image_o)

c_x = FLOAT(p_axis[4])	; centro de masas
c_y = FLOAT(p_axis[5])
p1_x = FLOAT(p_axis[0])
p1_y = FLOAT(p_axis[1])
p2_x = FLOAT(p_axis[2])
p2_y = FLOAT(p_axis[3])
;------------------------------------------------------------
p_minmax = BinReg_minmaxdist(image_o, [c_x, c_y], [p1_x, p1_y])

pmax1_x = FLOAT(p_minmax[0])
pmax1_y = FLOAT(p_minmax[1])
pmax2_x = FLOAT(p_minmax[2])
pmax2_y = FLOAT(p_minmax[3])
;------------------------------------------------------------


;IF opt_axis EQ 1 THEN BEGIN	; No se pide construir el rectángulo, solo medir lo
							; Ejes menor y mayor

dist_1 = binreg_Linedist([pmax1_x, pmax1_y], [c_x, c_y], [p1_x, p1_y])
dist_2 = binreg_Linedist([pmax2_x, pmax2_y], [c_x, c_y], [p1_x, p1_y])

;-------------------------------------------------------------
; Equation of the line is a*x + b*y +c = 0 (principal axis)

a = c_y - p1_y
b = p1_x - c_x
c = (-(p1_x - c_x)*p1_y) + ((p1_y - c_y)*p1_x)
;------------------------------------------------------------
; Coeficients of the minor axis

a1 = b
b1 = -a
c1 = a*c_y -b*c_x
e1 = a1*a1 + b1*b1
;------------------------------------------------------------

arr_imag = WHERE(image_o EQ 1)
IF arr_imag[0] EQ -1 THEN RETURN, -1

n_pixels = FLOAT(N_ELEMENTS(arr_imag))

arr_y = FLOAT((arr_imag / xsize)   )	; El menor es 1, no cero
arr_x = FLOAT((arr_imag MOD xsize) )

p_min = FLOAT([0,0])
p_max = FLOAT([0,0])

dist_min = 10.0E30
dist_max = 0.0
;------------------------------------------------------------

FOR i=0L, n_pixels -1 DO BEGIN
	f = a1*arr_x[i] + b1*arr_y[i] + c1
	IF f LE dist_min THEN BEGIN
		p_min = [arr_x[i], arr_y[i]]
		dist_min = f
	ENDIF
	IF f GE dist_max THEN BEGIN
		p_max = [arr_x[i], arr_y[i]]
		dist_max = f
	ENDIF
ENDFOR
dist_min = SQRT((dist_min*dist_min) /e1)
dist_max = SQRT((dist_max*dist_max) /e1)

;------------------------------------------------------------

dist_3 = ABS(dist_max)+ABS(dist_min)

length_axis = [dist_3, dist_1+dist_2]

IF opt_float EQ 0 THEN BEGIN
	length_axis = FIX(ROUND(length_axis))
ENDIF

RETURN, length_axis

END

;------------------------------------------------------------