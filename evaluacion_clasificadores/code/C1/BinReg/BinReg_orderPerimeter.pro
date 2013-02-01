
FUNCTION binreg_orderperimeter, image_o

; Retorna un array ordenado de posiciones [x,y,xy] del perímetro de una forma binaria
; Ojito, porque puede repetir valores (tiene que recorrer el perímetro hasta cerrarlo
;
;--------------------------------------------------------------------------------------

image = enmarca2d(image_o)	; Evita problemas de bordes

tam = SIZE(image)
xsize = tam[1]
ysize = tam[2]
xysize = LONG(xsize)*ysize

imag_perim = binreg_frontier(image)
imag_index = LONG(imag_perim*0) ; imagen con los indices iguales al orden de
								; anñalisis de los píxeles

arr_pos = WHERE(imag_perim EQ 1)

IF arr_pos[0] EQ -1 THEN RETURN, -1

;------------------------------------------------------------

arr_vecc = LONARR(8)

pos_ini = arr_pos[0]
pos_act = pos_ini
imag_index[pos_ini] = 1

arr_ordered = [pos_ini]
index = 2

FOR i=2l, 10000 DO BEGIN

	arr_vecc[0] = [pos_act - xsize +1]
	arr_vecc[1] = [pos_act + 1]			; Vecinos en orden de las manecillas del reloj
	arr_vecc[2] = [pos_act + xsize +1]
	arr_vecc[3] = [pos_act + xsize]
	arr_vecc[4] = [pos_act + xsize -1]
	arr_vecc[5] = [pos_act - 1]
	arr_vecc[6] = [pos_act - xsize -1]
	arr_vecc[7] = [pos_act - xsize]

	arr_1 = WHERE(imag_perim[arr_vecc] LT 3 AND imag_perim[arr_vecc] GT 0)
	IF arr_1[0] NE -1 THEN BEGIN

		arr_vecc2 = arr_vecc[arr_1]
		arr_index = imag_index[arr_vecc2]
		pos = (WHERE(arr_index EQ MIN(arr_index)))[0]
		pos_act = arr_vecc2[pos]

		imag_perim[pos_act] = imag_perim[pos_act] + 1
		imag_index[pos_act] = index
		index = index + 1

	ENDIF ELSE BEGIN
		GOTO, fin_for	; Todos marcados a 3
	ENDELSE

	arr_ordered = [arr_ordered, pos_act]

ENDFOR

fin_for:
;------------------------------------------------------------

arr_orderedxy = LONARR(3, N_ELEMENTS(arr_ordered))
arr_orderedxy[0,*] = (arr_ordered MOD xsize) -1
arr_orderedxy[1,*] = (arr_ordered / xsize)   -1	; Restamos 1 para quitar el marco

arr_orderedxy[2,*] = arr_orderedxy[0,*] + arr_orderedxy[1,*]*(xsize-2)
RETURN, arr_orderedxy

END



;------------------------------------------------------------
;------------------------------------------------------------