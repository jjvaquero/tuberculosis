
FUNCTION binreg_FormFactor, image_o

; Obtiene el parámetro del factor de forma (o "circleness" ) de una región binaria
; La fórmula aceptada es Ff = 4*Pi*Area/(perimetro^2)
; Definción según [Jain96]
;
;
;
;--------------------------------------------------------------------------------------


area = TOTAL(image_o)
perimeter = binreg_perimeter(image_o)

ffactor = (4.0*!PI*FLOAT(area))/(perimeter^2)

IF ffactor GT 1.0 THEN BEGIN
	PRINT, 'Breakpoint'
ENDIF

RETURN, ffactor

END


;------------------------------------------------------------