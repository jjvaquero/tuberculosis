
FUNCTION binreg_FormFactor, image_o

; Obtiene el par�metro del factor de forma (o "circleness" ) de una regi�n binaria
; La f�rmula aceptada es Ff = 4*Pi*Area/(perimetro^2)
; Definci�n seg�n [Jain96]
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