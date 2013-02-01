
PRO viewg, image, ventana

; Visualiza una imagen en pantalla a 512*x píxeles

	IF N_ELEMENTS(image) EQ 0 THEN RETURN

	true = 0

	tam = SIZE(image)
	IF tam[0] LT 2 THEN RETURN

	IF tam[0] EQ 3 THEN BEGIN
		IF MIN(tam[1:3]) GT 2 THEN true = 1 ELSE true = 0
	ENDIF

	IF true EQ 1 THEN BEGIN
		IF tam[1] EQ 3 THEN imag = change_true(image) ELSE imag = image
	ENDIF ELSE imag = REFORM(image)


	xsize =tam[1]
	ysize =tam[2]

	tmax = MAX([xsize, ysize])
	aspect = FLOAT(ysize)/FLOAT(xsize)

 	IF N_ELEMENTS(ventana) EQ 0 THEN ventana=0

	IF tmax EQ xsize THEN BEGIN
		IF (true EQ 0) THEN BEGIN
    	is = congrid(imag, 512, FIX(ROUND(512e*aspect)))
        view,  is, ventana
    ENDIF
    IF (true EQ 1) THEN BEGIN
        is = congrid(imag, 512,FIX(ROUND(512e*aspect)),3)
        viewt, is, ventana
    ENDIF
	ENDIF ELSE BEGIN
	    IF (true EQ 0) THEN BEGIN
	    	is = congrid(imag, FIX(ROUND(512e/aspect)), 512)
	        view,  is, ventana
	    ENDIF
	    IF (true EQ 1) THEN BEGIN
	        is = congrid(imag, FIX(ROUND(512e/aspect)), 512, 3)
	        viewt, is, ventana
	    ENDIF
	ENDELSE

END; vgrande.pro

