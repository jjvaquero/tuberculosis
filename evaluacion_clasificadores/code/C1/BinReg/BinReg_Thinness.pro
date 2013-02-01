
FUNCTION binreg_thinness, image_o

; Obtiene el par�metro 'Thinness' de una regi�n binaria
; Definci�n seg�n [Jain96]
;
; Cuanto m�s "alargado" es el objeto, menor es este par�metro
;
;--------------------------------------------------------------------------------------

m_11 = binreg_moments(image_o, NI=1, NJ=1)
m_20 = binreg_moments(image_o, NI=2, NJ=0)
m_02 = binreg_moments(image_o, NI=0, NJ=2)

;------------------------------------------------------------
im_matrix = [[m_20, -m_11],[-m_11, m_02]]

eigenvals = EIGENQL(im_matrix)

thinness = MIN(eigenvals)/MAX(eigenvals)

RETURN, thinness

END


;------------------------------------------------------------