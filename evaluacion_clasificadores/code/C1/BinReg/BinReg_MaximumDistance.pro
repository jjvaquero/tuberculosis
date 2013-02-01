
FUNCTION binreg_MaximumDistance, image_o

; Calcula el valor de la m�xima distancia de un punto de la imagen binaria al background
;
; Cuidado con el efecto de bordes, por lo mal que est� hecha la funci�n MORPH_DISTANCE
;
;
;--------------------------------------------------------------------------------------

;imag_dist = MORPH_DISTANCE(image_o, NEIGHBOR_SAMPLING=3)
imag_dist = binreg_distance(image_o)

max_dist = MAX(imag_dist)

;------------------------------------------------------------

RETURN, max_dist


END

;------------------------------------------------------------