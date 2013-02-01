
FUNCTION binreg_MaximumRadius, image_o

; Calcula el valor del parámetro MAXR (radio máximo) según se define en [Jain96]
; La distancia máxima de un punto de la imagen binaria al centro de masas
;
;
;--------------------------------------------------------------------------------------

centermass = binreg_centermass(image_o)	; Centro de masas en entero
c_x = centermass[0]
c_y = centermass[1]

imag_1 = image_o*0 + 1
imag_1[c_x, c_y] = 0

;imag_dist = MORPH_DISTANCE(imag_1, NEIGHBOR_SAMPLING=3)
imag_dist = binreg_distance(imag_1)
arr_zeros = WHERE(image_o EQ 0)
IF arr_zeros[0] NE -1 THEN $
	imag_dist[arr_zeros] = 0

max_dist = MAX(imag_dist)

;------------------------------------------------------------

RETURN, max_dist


END

;------------------------------------------------------------