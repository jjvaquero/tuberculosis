
FUNCTION binreg_Compactness, image_o

; Obtiene el parámetro de "compactness" o compactación de una imagen binaria
; La fórmula aceptada es C = (sqrt(4*area/pi))/eje mayor (feretd/ejemayor)
;
;
;--------------------------------------------------------------------------------------

area = TOTAL(image_o)

feretd =  SQRT((4.0*FLOAT(area))/!PI)
mayoraxis = binreg_longestdimension(image_o)

Cc = feretd/FLOAT(mayoraxis)

IF Cc GT 1.0 THEN BEGIN
	PRINT, 'Breakpoint'
ENDIF

RETURN, Cc

END


;------------------------------------------------------------