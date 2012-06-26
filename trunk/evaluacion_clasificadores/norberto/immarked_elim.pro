

FUNCTION Immarked_elim, im_marked, min_tam, EQUAL=equal, LIMIT255=limit255, BORDERS=borders

; Esta función trabaja con imágenes marcadas "label_region"
; Elimina las regiones que son menores de un cierto umbral ,
; Además, con la keword "equal" vuelve a marcar bien la imagen
;
; Además, con LIMIT255, deja solamente las primeras 255 marcas
; Admás, con BORDERS, elimina las regiones marcadas que toquen el borde o estén a un píxel
;
; im_sal = immarked_elim(im_ent, 10, /EQUAL)
;----------------------------------------------------------------------------------------

T = SYSTIME(1)
IF KEYWORD_SET(limit255) THEN opt_limit1  = 1 ELSE opt_limit1  = 0
IF KEYWORD_SET(equal)    THEN opt_equal   = 1 ELSE opt_equal   = 0
IF KEYWORD_SET(borders)  THEN opt_borders = 1 ELSE opt_borders = 0

;----------------------------------------------------------

im_sal = im_marked
flag_change = 0

max_val = MAX(im_marked)

IF max_val LE 0 THEN RETURN, im_marked

;ptr_arr = PTRARR(max_val, /ALLOCATE_HEAP)

FOR i=1, max_val DO BEGIN
	pos_pixel = WHERE(im_marked EQ i)
	IF pos_pixel[0] NE -1 THEN BEGIN
		n_pixel = N_ELEMENTS(pos_pixel)
		IF n_pixel LT min_tam THEN BEGIN
			im_sal[pos_pixel] = 0
			flag_change = 1
		ENDIF
	ENDIF
ENDFOR

IF opt_equal EQ 1 THEN BEGIN	; ecualiza imag
	IF flag_change EQ 1 THEN BEGIN
		im_sal = im_sal NE 0
		im_sal = marcaminimos_c(im_sal)
	ENDIF
ENDIF

IF opt_borders EQ 1 THEN BEGIN	; Elimina regiones que tocan borde
	tam    = SIZE(im_sal)
	xsize = tam[1]
	ysize = tam[2]
	arr_border1 = [REFORM(im_sal[0:xsize-1, 0]),  REFORM(im_sal[0:xsize-1, ysize-1]), $
				  REFORM(im_sal[0, 0:ysize-1]),  REFORM(im_sal[xsize-1, 0:ysize-1])]
	arr_border2 = [REFORM(im_sal[1:xsize-2, 1]),  REFORM(im_sal[1:xsize-2, ysize-2]), $
				  REFORM(im_sal[1, 1:ysize-2]),  REFORM(im_sal[xsize-2, 1:ysize-2])]
	arr_border = arr_border1 + arr_border2

	histo_border = HISTOGRAM(arr_border, MIN=0)
	mark_border  = WHERE(histo_border GT 0,count)
	changes = 0
	FOR i=0L, N_ELEMENTS(mark_border)-1 DO BEGIN
		IF mark_border[i] NE 0 THEN BEGIN
			im_sal[WHERE(im_sal EQ mark_border[i])] = 0
			changes = changes +1
		ENDIF
	ENDFOR
	IF changes GT 0 THEN BEGIN
		im_sal = im_sal NE 0
		im_sal = marcaminimos_c(im_sal)
	ENDIF
ENDIF

IF opt_limit1 EQ 1 THEN BEGIN
	arr_plus255 = WHERE(im_sal GT 255, count)
	IF count GT 0 THEN BEGIN
		im_sal[arr_plus255] = 0
	ENDIF
ENDIF

;----------------------------------------------------------

PRINT, 'Tiempo de eliminación de regiones pequeñas  :',  SYSTIME(1)-T

RETURN, im_sal

END









