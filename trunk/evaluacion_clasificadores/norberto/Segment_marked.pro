

FUNCTION Segment_marked, im_orig, im_marked

; Separa en la imagen de salida los cuadrados (que marca a 1) y los circulos (que marca a dos)
; De la imagen marcada por el usuario
;
; La imagen de entrada es la marcada original
;----------------------------------------------------------------------------------------



xsize = (SIZE(im_orig))[2]
ysize = (SIZE(im_orig))[3]

im_recs = INTARR(xsize, ysize)
im_circl= INTARR(xsize, ysize)
im_sal  = INTARR(xsize, ysize)

im_recs = FIX(im_marked[0,*,*]) +  im_marked[1,*,*] +  im_marked[2,*,*]
im_recs = im_recs GT 750

im_circl= (im_marked[1,*,*] LT 40 ) AND (im_marked[0,*,*] GT 200)

im_sal[WHERE(im_recs  EQ 1)] = 1
im_sal[WHERE(im_circl EQ 1)] = 2

RETURN, im_sal

END









