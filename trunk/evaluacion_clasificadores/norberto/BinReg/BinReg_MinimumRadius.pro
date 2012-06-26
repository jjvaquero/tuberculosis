
FUNCTION binreg_MinimumRadius, image_o

; Calcula el valor del parámetro MINR (radio máximo) según se define en [Jain96]
; La distancia a la que está el centro de masas del perímetro
;
; Cuidado con esta función y la de Maimumradius. Como utilizan la función
; MORPH_DISTANCE, tienen efecto de bordes que haga que el resultado esté mal -> ARREGLAR
;--------------------------------------------------------------------------------------

centermass = binreg_centermass(image_o)	; Centro de masas en entero
c_x = centermass[0]
c_y = centermass[1]



;imag_dist = MORPH_DISTANCE(image_o, NEIGHBOR_SAMPLING=3)
imag_dist = binreg_distance(image_o)

min_dist = imag_dist[c_x, c_y]

;------------------------------------------------------------

RETURN, min_dist


END

;------------------------------------------------------------