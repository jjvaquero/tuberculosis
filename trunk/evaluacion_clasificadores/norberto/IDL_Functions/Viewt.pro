PRO viewt, imag, wind, NOSCALE=noscale, _EXTRA=extra


;; Visualiza correctamente imágenes de greyscale y color
;;

IF N_ELEMENTS(imag) EQ 0 THEN BEGIN & PRINT, 'Datos no válidos' & RETURN & END
IF NOT KEYWORD_SET(noscale) THEN noscal=0 ELSE noscal=1


tam=SIZE(imag)

IF N_ELEMENTS(wind) EQ 1 THEN BEGIN
	WINDOW, wind   ; Ventana por defecto
ENDIF
IF N_ELEMENTS(wind) GT 1 THEN BEGIN
	PRINT, 'Datos no válidos' & RETURN
ENDIF
IF N_ELEMENTS(wind) EQ 0 THEN BEGIN
	WINDOW, 0  ;
ENDIF

IF tam[0] EQ 2  THEN BEGIN 	; gris
	WINDOW, !D.window,  XSIZE=tam(1), YSIZE=tam(2)
	IF noscal EQ 0 THEN TVSCL, imag, _EXTRA=extra ELSE TV, imag, _EXTRA=extra
	RETURN
ENDIF


IF tam[0] EQ 3  THEN BEGIN     ; color

	IF tam[1] EQ 3  THEN BEGIN  ; TRUE=1
		WINDOW, !D.window,  XSIZE=tam(2), YSIZE=tam(3)
		IF noscal EQ 0 THEN TVSCL, imag, TRUE=1, _EXTRA=extra ELSE TV, imag, TRUE=1, _EXTRA=extra
		RETURN
	ENDIF
	IF tam[2] EQ 3  THEN BEGIN  ; TRUE=2
		WINDOW, !D.window,  XSIZE=tam(1), YSIZE=tam(3)
		IF noscal EQ 0 THEN TVSCL, imag, TRUE=2, _EXTRA=extra ELSE TV, imag, TRUE=3, _EXTRA=extra
		RETURN
	ENDIF
	IF tam[3] EQ 3  THEN BEGIN  ; TRUE=3
		WINDOW, !D.window,  XSIZE=tam(1), YSIZE=tam(2)
		IF noscal EQ 0 THEN TVSCL, imag, TRUE=3, _EXTRA=extra ELSE TV, imag, TRUE=3, _EXTRA=extra
		RETURN
	ENDIF

ENDIF

END