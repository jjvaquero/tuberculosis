
FUNCTION binreg_MinorAxis, image_o

; Obtiene las coordenadas [x,y]) de dos extremos del eje menor de una imagen binaria
; y del centro de masas (por el que debe pasar)
; El formato de salida es un matriz 2x3
; (1 - Objeto, 0 - fondo)
;
; Según el algoritmo propuesto por [Parker], para obtener el eje principal, y a partir de
; este y perpendicular, el eje menor (quetambién pasa por el centro de masas)
;
;--------------------------------------------------------------------------------------

imag = image_o

tam = SIZE(image_o)
xsize = tam[1]
ysize = tam[2]
xysize = LONG(xsize)*ysize

sal_paxis = binreg_principalaxis(image_o)
;------------------------------------------------------------

c_x = FLOAT(sal_paxis[4])
c_y = FLOAT(sal_paxis[5])
p1_x = FLOAT(sal_paxis[0])
p1_y = FLOAT(sal_paxis[1])
p2_x = FLOAT(sal_paxis[2])
p2_y = FLOAT(sal_paxis[3])

;------------------------------------------------------------

IF (p1_x EQ p2_x) AND (p1_y EQ p2_y) THEN RETURN, -1

;------------------------------------------------------------
; Equation of the line is a*x + b*y +c = 0 (principal axis)

a = p2_y - p1_y
b = p1_x - p2_x
c = (-(p1_x - p2_x)*p1_y) + ((p1_y - p2_y)*p1_x)

;------------------------------------------------------------
; Coeficients of the minor axis

a1 = b
b1 = -a
c1 = a*c_y -b*c_x

;------------------------------------------------------------


END

;------------------------------------------------------------