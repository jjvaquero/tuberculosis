
FUNCTION binreg_FeretDiameter, image_o

; Obtiene el parámetro del diámetro de Feret de una región binaria
; La fórmula aceptada es Fd = sqrt(4*area/pi)
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