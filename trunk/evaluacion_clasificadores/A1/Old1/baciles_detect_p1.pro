
FUNCTION baciles_detect_p1, image_o, IDL=idl

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
;  Elemento estructurante del opening
;  E. Estructurante de la reconstrucción (en /IDL los dos son iguales)
;  Tipo de filtro binomial
;  El valor de la umbralización


;-----------------------------------------------------------------------------------------

IF KEYWORD_SET(idl) THEN opt_idl = 1 ELSE opt_idl = 0

;-----------------------------------------------------------------------------------------
; Parámetros fijados

fix_radius = 6  ; 5
fix_level  = 30 ; 35
fix_binomial_diamenter = 5;
;-----------------------------------------------------------------------------------------

tam = SIZE(image_o)

IF tam[1] EQ 3 THEN BEGIN	;TRUE=1
	image_og = REFORM(image_o[1,*,*])		; Canal verde
ENDIF
IF tam[3] EQ 3 THEN BEGIN	;TRUE=3
	image_og = REFORM(image_o[*,*,1])		; Canal verde
ENDIF

image_og = FIX(filter_Binomial_2d(image_og, DIAMETER=fix_binomial_diameter))

image_og = image_framing2d(image_og, fix_radius*2, 0)

kernel    = UINT(crea_disco(fix_radius))

im_open = MORPH_OPEN(UINT(image_og), kernel, /GRAY, /PRESERVE_TYPE)
; opim = grayopen(im,Estructura=kernel) -> Erosión + dilatación

; White top-hat  => original - opening
; Black toop-hat => closing  - original
; Aquí se hace un top-hat blanco pero con reconstrucción de opening ("opening by reconstruction")

IF opt_idl EQ 1 THEN BEGIN
	im_rec = reconstruction(image_og, im_open, ESTRUCTURA=kernel)
ENDIF ELSE BEGIN
	im_rec = reconstruction_c(image_og, im_open, OPTION=4)
	; Kernel = de  7x7 hay que hacerlo con cualquier kernel
	; Con OPTION=3, kernel de cruz
	;im_rec    = reconstruction_c(image_og, im_open, OPTION=5, RADIUS=5)
	; El kernel es un circulo de radio 5
ENDELSE

im_tophat = image_og - im_rec

im_sal = im_tophat GT fix_level

im_sal = image_deframing2d(im_sal, fix_radius*2)

RETURN, im_sal

END