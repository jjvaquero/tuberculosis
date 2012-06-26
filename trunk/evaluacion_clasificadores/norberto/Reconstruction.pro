;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; FUNCTION Reconstruction, i_Mayor, i_Menor, Estructura=Estructura
;
; PROGRAMADO POR:		José Ignacio Roldán Lozón
; ULT. MODIFICACION:	28/11/97
; VERSION IDL:			5.02
; PROPOSITO:			Realiza la reconstrucción morfológica de la imagen mayor a partir
;							de la imagen menor.
; PARAMETROS:			i_Mayor -> Imagen mayor
;						i_Menor -> Imagen menor
;						Estructura -> Estructura para realizar las aperturas y cierres en
;							niveles de gris. Por defecto = matriz cuadrada 3x3
; ALGORITMO:
; BIBLIOGRAFIA:			Luc VINCENT, Edward R. DOUGHERTY
;						"Morphological Segmentation for Textures and Particles"
;						Recopilado en "Digital Image Processing Methods"
;						Ed: ??
;						Pags: 60..102
;						Biblioteca ETSI Telecomunicacion: L4n/Dig
; COMENTARIOS:			Resulta Lenta. Debería hacerla en C y llamarla con CALLEXTERN
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

FUNCTION Reconstruction, i_Mayor, i_Menor, Estructura=Estructura

	PRINT, 'Reconstruction.c     ' & T = SYSTIME(1)

    IF (MIN(i_Mayor-i_Menor) LT 0) THEN BEGIN
		return, 0*i_Menor
	ENDIF
	IF (N_ELEMENTS(Estructura) EQ 0) THEN BEGIN
		Estructura = REPLICATE(1,3,3)
	ENDIF
	IF ((SIZE(i_Mayor))[0] EQ 1) THEN BEGIN
		Estructura = Estructura[0:2]
	ENDIF

	i_Aux = i_Menor
	i_Rec = i_Mayor < DILATE(i_Aux, Estructura, /GRAY)
	WHILE (MAX(i_Rec GT i_Aux) GT 0) DO BEGIN
		i_Aux = i_Rec
		i_Rec = i_Mayor < DILATE(i_Aux, Estructura, /GRAY)
	ENDWHILE

	PRINT, 'reconstruction.c     ',  SYSTIME(1) - T, ' Seg'

return, i_Rec;
END