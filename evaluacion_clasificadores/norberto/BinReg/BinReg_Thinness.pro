
FUNCTION binreg_thinness, image_o

; Obtiene el parámetro 'Thinness' de una región binaria
; Definción según [Jain96]
;
; Cuanto más "alargado" es el objeto, menor es este parámetro
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