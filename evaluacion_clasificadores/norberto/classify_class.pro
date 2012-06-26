

FUNCTION Classify_class, im_mask, im_marked

; Toma como partida una imagen etiquetada y otra imagen marcada a mi estilo (de tras canales)
; La salida es otra imagen etiquetada donde los bacilos toman los siguientes valores:
;
; 1 - Es bacilo
; 2 - No es bacilo
; 3 - Dudoso

;----------------------------------------------------------------------------------------

T = SYSTIME(1)

xsize = (SIZE(im_mask))[1]
ysize = (SIZE(im_mask))[2]

im_recs = INTARR(xsize, ysize)
im_circl= INTARR(xsize, ysize)
im_etiq = INTARR(xsize, ysize)

im_recs = FIX(im_marked[0,*,*]) +  im_marked[1,*,*] +  im_marked[2,*,*]
im_recs = im_recs GT 760	; Mayor que 253 en los tres canales:
arr_class_1 = WHERE(im_recs  EQ 1, count_1)
IF count_1 GT 0 THEN $
	im_etiq[arr_class_1] = 1
undefine, im_recs

im_circl = (im_marked[0,*,*] EQ 255) AND (im_marked[1,*,*] LT 150)	; Igual a 255 en el canal rojo
arr_class_3 = WHERE(im_circl  EQ 1, count_3)
IF count_3 GT 0 THEN $
	im_etiq[arr_class_3] = 3

undefine, im_circl


;----------------------------------------------------------

n_regs = MAX(im_mask)
im_sal = im_mask

FOR i=1L, n_regs DO BEGIN
	arr_pospixel = WHERE(im_mask EQ i, count)
	IF count GT 0 THEN BEGIN
		num_class  = im_etiq[arr_pospixel[0]]
		IF num_class EQ 0 THEN num_class = 2
		im_sal[arr_pospixel] = num_class
	ENDIF
ENDFOR

;----------------------------------------------------------

PRINT, 'Tiempo de Classify Class  :',  SYSTIME(1)-T

RETURN, im_sal

END









