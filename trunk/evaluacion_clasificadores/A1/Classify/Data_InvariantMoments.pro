

;--------------------------------------------------------------------
;
; Esta función retorna una matriz de momentos invariantes derivados
; de los fundamentales de orden >= 3
;
; La matriz de datos inicial es:
;
; [m11, m20, m02, m21, m12, m30, m03]
;
;--------------------------------------------------------------------

FUNCTION data_invariantmoments, mat_data

tam = SIZE(mat_data)

n_samples  = tam[2]
n_param    = tam[1]

IF n_param NE 7 THEN RETURN, -1

m11 = mat_data[0,*]
m20 = mat_data[1,*]
m02 = mat_data[2,*]
m21 = mat_data[3,*]
m12 = mat_data[4,*]
m30 = mat_data[5,*]
m03 = mat_data[6,*]

;-------------------------------

u1 = m20 + m02

u2 = (m20 - m02)^2 + 4*(m11^2)

u3 = (m30 - 3*m12)^2 + (m03 - 3*m21)^2

u4 = (m30 + m12)^2 + (m03 + m21)^2

u5 =    (m30 - 3*m12)*(m30 + m12)*((m30 + m12)^2 - 3*((m03 + m21)^2)) + $
		(3*m21 - m03)*(m03 + m21)*(3*((m30 + m12)^2)- (m03 + m21)^2)

u6 = (m20 - m02)*((m30 + m12)^2 - (m21 + m03)^2) + 4*m11*(m30 + m12)*(m03 + m21)

u7 = 	(3*m21 - m03)*(m30 + m12)*((m30 + m12)^2 -3*((m21 + m03)^2)) - $
		(m30 - 3*m12)*(m21 + m03)*(3*((m30 + m12)^2) -(m21 + m03)^2)


RETURN, [u1,u2,u3,u4,u5,u6,u7]


END