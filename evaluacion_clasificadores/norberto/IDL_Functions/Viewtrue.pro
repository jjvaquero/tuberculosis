
PRO viewtrue, imagen, wind

;; Visualiza correctamente una imagen de tres canales en pantalla (24 bits)
;;
;; En la ventana indicada (cero por defecto)
;;
;; Ultima modificación: 5-10-2000
;;

IF N_ELEMENTS(wind) EQ 0 THEN wind=0    ; Ventana por defecto

img = BYTARR(3,(SIZE(imagen))[2], (SIZE(imagen))[3])

img(0,*,*) = ROTATE(REVERSE(REFORM(imagen(0,*,*))), 2)      ; Rota la imagen
img(1,*,*) = ROTATE(REVERSE(REFORM(imagen(1,*,*))), 2)
img(2,*,*) = ROTATE(REVERSE(REFORM(imagen(2,*,*))), 2)
tam = SIZE(imagen)

lg_win = tam(2)
wd_win = tam(3)

WINDOW, wind, XSIZE=lg_win, YSIZE=wd_win
TVSCL, img, /TRUE

END
