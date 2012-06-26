
FUNCTION binreg_Linedist, point_d, end_point, front_point

; Calcula la distancia entre un eje definido por dos puntos  (end_point y front_point)
; y el punto point_d
; Se parece a  la función "all_dist" de [Parker]
;
; Los tres puntos están dados en formato x-y
;
;--------------------------------------------------------------------------------------

;------------------------------------------------------------

p2_x = FLOAT(end_point[0])
p2_y = FLOAT(end_point[1])
p1_x = FLOAT(front_point[0])
p1_y = FLOAT(front_point[1])

pd_x = FLOAT(point_d[0])
pd_y = FLOAT(point_d[1])
;------------------------------------------------------------

IF (p1_x EQ p2_x) AND (p1_y EQ p2_y) THEN RETURN, -1

;------------------------------------------------------------
; Equation of the line is a*x + b*y +c = 0

a = p2_y - p1_y
b = p1_x - p2_x
c = (-(p1_x - p2_x)*p1_y) + ((p1_y - p2_y)*p1_x)
e = a*a + b*b
dist = 0.0

;------------------------------------------------------------

f = a*pd_x + b*pd_y + c
f = (f*f)/e

;------------------------------------------------------------

RETURN, SQRT(f)

END

;------------------------------------------------------------