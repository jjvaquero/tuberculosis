
FUNCTION binreg_Angle, image_o

; Obtiene el par�metro de �ngulo mediante c�lculo de momentos de una regi�n binaria
; Valor en radianes
; Definci�n seg�n [Jain96]
;
;
;
;--------------------------------------------------------------------------------------

m_11 = binreg_moments(image_o, NI=1, NJ=1)
m_20 = binreg_moments(image_o, NI=2, NJ=0)
m_02 = binreg_moments(image_o, NI=0, NJ=2)

;------------------------------------------------------------

IF m_20 EQ m_02 THEN RETURN, 0.0 ; Figura sim�trica

angle = 0.5*ATAN(2*m_11/(m_20-m_02))

RETURN, angle

END


;------------------------------------------------------------