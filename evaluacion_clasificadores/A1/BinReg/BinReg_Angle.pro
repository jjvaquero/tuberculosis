
FUNCTION binreg_Angle, image_o

; Obtiene el parámetro de ángulo mediante cálculo de momentos de una región binaria
; Valor en radianes
; Definción según [Jain96]
;
;
;
;--------------------------------------------------------------------------------------

m_11 = binreg_moments(image_o, NI=1, NJ=1)
m_20 = binreg_moments(image_o, NI=2, NJ=0)
m_02 = binreg_moments(image_o, NI=0, NJ=2)

;------------------------------------------------------------

IF m_20 EQ m_02 THEN RETURN, 0.0 ; Figura simétrica

angle = 0.5*ATAN(2*m_11/(m_20-m_02))

RETURN, angle

END


;------------------------------------------------------------