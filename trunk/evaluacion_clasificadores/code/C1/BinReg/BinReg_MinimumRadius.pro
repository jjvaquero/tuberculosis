
FUNCTION binreg_MinimumRadius, image_o

; Calcula el valor del par�metro MINR (radio m�ximo) seg�n se define en [Jain96]
; La distancia a la que est� el centro de masas del per�metro
;
; Cuidado con esta funci�n y la de Maimumradius. Como utilizan la funci�n
; MORPH_DISTANCE, tienen efecto de bordes que haga que el resultado est� mal -> ARREGLAR
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