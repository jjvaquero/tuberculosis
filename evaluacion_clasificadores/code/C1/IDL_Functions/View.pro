
PRO view, imagen, wind

;; Visualiza correctamente una imagen en pantalla
;;
;; En la ventana indicada (cero por defecto)
;;
;; Ultima modificación: 26-09-2000
;;

IF N_ELEMENTS(wind) EQ 0  THEN wind=0   ; Ventana por defecto
IF (SIZE(imagen))[0] NE 2 THEN BEGIN
    PRINT, 'datos incorrectos'
    RETURN
ENDIF

tam = SIZE(imagen)

lg_win = tam(1)
wd_win = tam(2)

WINDOW, wind,  XSIZE=lg_win, YSIZE=wd_win
TVSCL, imagen, ORDER=!order

END
