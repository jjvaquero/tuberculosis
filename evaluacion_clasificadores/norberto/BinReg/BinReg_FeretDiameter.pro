
FUNCTION binreg_FeretDiameter, image_o

; Obtiene el par�metro del di�metro de Feret de una regi�n binaria
; La f�rmula aceptada es Fd = sqrt(4*area/pi)
;
; El diametro del circulo con igual area que la region
;
;
;
;--------------------------------------------------------------------------------------


area = N_ELEMENTS(WHERE(image_o EQ 1))

feretd =  SQRT((4.0*FLOAT(area))/!PI)

RETURN, feretd

END


;------------------------------------------------------------