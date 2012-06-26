;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; FUNCTION THRESOTSU, Imag, Nivel=Nivel, Mask=Mask, Hist=Hist
;
; PROGRAMADO POR:		José Ignacio Roldán Lozón
; ULT. MODIFICACION:	29/11/97
; VERSION IDL:			5.02
; PROPOSITO:			Obtiene imagen binarizada de la original calculando el umbral
;						como aquel que maximiza la varianza entre grupos
; PARAMETROS:			Imag -> Imagen original en niveles de gris con la que trabajar
;						Nivel -> Devuelve el nivel del umbral utilizado
;						Mask -> Imagen binaria con 1s en la zona que queremos estudiar.
;							Si no se especifica trabajamos con toda la imagen.
;						Hist -> Devuelve el histograma de la imagen (o parte enmascarada)
; ALGORITMO:			Otsu (1979)
; BIBLIOGRAFIA:			Robert M. HARALICK, Linda G. SHAPIRO
;						"Computer and Robot Vision. Volume I"
;						Addison Wesley Publishing Company. 1992.
;						Pags: 20..23
; COMENTARIOS:			La máscara es útil para segmentar imagenes con más de dos niveles
;							de gris diferenciables.
;						FALLA para imágenes sintéticas en 0 y otro nivel. Difuminarlas
;							antes con un smooth(imag,3)
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

FUNCTION THRESOTSU, Imag, Nivel=Nivel, Mask=Mask, Hist=Hist

   	IF (N_ELEMENTS(Mask) GT 0) THEN BEGIN
		Hist = HISTOGRAM(Imag[WHERE(Mask GE 1)])
	ENDIF ELSE BEGIN
		Hist = HISTOGRAM(Imag)
	ENDELSE

	G_Tot = (SIZE(Hist))[1]
	Indice = INDGEN(G_Tot)

	Q1 = REPLICATE(0L, G_Tot)
	Mu1 = REPLICATE(0.0, G_Tot)
	Mu2 = REPLICATE(0.0, G_Tot)
	G_Fin = G_Tot-1
	G_Ini = ((WHERE(Hist GT 0))[0])

   	FOR i=G_Ini, G_Fin DO BEGIN
		Q1[i] = TOTAL(Hist[0:i])
		Mu1[i] = TOTAL((Indice[0:i]*Hist[0:i])/Q1[i])
	ENDFOR

	Q2 = TOTAL(Hist) - Q1
	Q2Pos = (WHERE(Q2 GT 0))
	G_Ini2 = (Q2Pos[0])
	G_Fin2 = (Q2Pos[((SIZE(Q2Pos))[1])-1])
	FOR i = G_Ini2, G_Fin2-1 DO BEGIN
		Mu2[i] = TOTAL((Indice[i+1:G_Fin]*Hist[i+1:G_Fin]) / Q2[i])
	ENDFOR

   	BG_Var = Q1*Q2*((MU1-MU2)^2)
	Max_BGV = MAX(BG_Var, Nivel)

	i_Bin = (Imag GE Nivel)

return, i_Bin
END