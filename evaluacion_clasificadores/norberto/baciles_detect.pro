
FUNCTION baciles_detect, image_o, IDL=idl, $
	THRESHOLD=threshold, FILTER=filter, RADIUS=radius

; Separa los bacilos para obtener sus características
; La salida es una imagen máscara donde cada candidato a bacilo tiene su identificador, de
; 1 a 32000. El cero es para el fondo

; Deteccion de bacilos en imagenes de auramina
; Entrada: Imagen original de tres canales de color, tal cual es leida del disco
; Salida:  Imagen etiquetada de los bacilos detectados
;
; Con opción IDL, realiza la recosntrucción en IDL (algo distinto el resultado)
;
; Pasos que realiza:
;
;  1 - Extrae el canal verde:
;  2 - Filtrado binomial
;  3 - Opening (Erosión + dilatación)
;  4 - Recontrucción morfológica del opening sobre la imagen original
;  5 - Imagen original menos reconstruida
;      Los pasos 3,4 y 5 son un TopHat con reconstrucción (extracción de cúpulas)
;  6 - Umbralización del tophat
;
;  Tiene 4 parámetros:
;
;  RADIUS    - Radio del Elemento estructurante del opening
;  FILTER    - Diámetro del filtro binomial 2D
;  THRESHOLD - El valor de la umbralización
;  Elem. Estructurante de la reconstrucción (en /IDL los dos son iguales) - No modificable


;-----------------------------------------------------------------------------------------

IF KEYWORD_SET(idl) THEN opt_idl = 1 ELSE opt_idl = 0

;-----------------------------------------------------------------------------------------
; Parámetros fijados


IF N_ELEMENTS(threshold) EQ 0 THEN fix_level  = 30 ELSE fix_level  = threshold
IF N_ELEMENTS(radius)    EQ 0 THEN fix_radius = 6  ELSE fix_radius = radius
IF N_ELEMENTS(filter)    EQ 0 THEN fix_binomial_filter = 5 ELSE fix_binomial_filter = filter

;fix_radius = 6  ; 5
;fix_level  = 30 ; 35
;fix_binomial_diamenter = 5;
;-----------------------------------------------------------------------------------------

size_framing = fix_radius*2 + 1

tam = SIZE(image_o)

IF tam[1] EQ 3 THEN BEGIN	;TRUE=1
	image_og = REFORM(image_o[1,*,*])		; Canal verde
ENDIF
IF tam[3] EQ 3 THEN BEGIN	;TRUE=3
	image_og = REFORM(image_o[*,*,1])		; Canal verde
ENDIF

image_og2 = FIX(filter_Binomial_2d(image_og, DIAMETER=fix_binomial_diameter))

image_ogf = image_framing2d(image_og2, size_framing,0)

kernel    = UINT(crea_disco(fix_radius))

im_open = MORPH_OPEN(UINT(image_ogf), kernel, /GRAY, /PRESERVE_TYPE)
; opim = grayopen(im,Estructura=kernel) -> Erosión + dilatación

; White top-hat  => original - opening
; Black toop-hat => closing  - original
; Aquí se hace un top-hat blanco pero con reconstrucción de opening ("opening by reconstruction")

IF opt_idl EQ 1 THEN BEGIN
	im_rec = reconstruction(image_ogf, im_open, ESTRUCTURA=kernel)
ENDIF ELSE BEGIN
	im_rec = reconstruction_c(image_ogf, im_open, OPTION=4)
	; Kernel = de  7x7 hay que hacerlo con cualquier kernel
	; Con OPTION=3, kernel de cruz
	;im_rec    = reconstruction_c(image_og, im_open, OPTION=5, RADIUS=5)
	; El kernel es un circulo de radio 5
ENDELSE

im_tophat = image_ogf - im_rec

im_sal = im_tophat GT fix_level

im_sal = image_deframing2d(im_sal, size_framing)

RETURN, im_sal

END