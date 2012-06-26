
FUNCTION View_orderperimeter, image_o, BIG=big

; Visualiza iterativamente los pixeles del contorno de una imagen binaria
;
;--------------------------------------------------------------------------------------

IF KEYWORD_SET(big) THEN opt_big = 1 ELSE opt_big=0

arr_ord = binreg_orderperimeter(image_o)

n_perim = (SIZE(arr_ord))[2]

;tam = (SIZE(image_o))[2]
;xsize = tam[1]
;ysize = tam[2]

FOR i=0L, n_perim-1 DO BEGIN

	imag_view = image_o
	imag_view[arr_ord[2,i]]=3
	IF opt_big EQ 1 THEN $
		viewg, imag_view $
	ELSE $
		view, imag_view
ENDFOR

RETURN, 1

END





;------------------------------------------------------------
;------------------------------------------------------------