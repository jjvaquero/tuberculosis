
FUNCTION binreg_Perimeter, image_o, OPTION=option

; Obtiene el valor numérico del perímetro de una imagen binaria
; (1 - Objeto, 0 - fondo)
;
; Aquí la entrada es una imagen binaria (habrá que separar)
;
; OPTION - 1, según la medida propuesta en el libro de C
;        - 2, Más basta
;
; La salida pueden ser los indices reformateados o una imagen, según la orden /IMAGE
;
; im_sal = binreg_Perimeter(arr_orig, XSIZE=xsize, YSIZE=ysize)
;
;--------------------------------------------------------------------------------------


IF N_ELEMENTS(option) EQ 0 THEN opt = 1 ELSE opt = option

image_bin= enmarca2d(image_o)

tam = SIZE(image_bin)
xsize = tam[1]
ysize = tam[2]
xysize = LONG(xsize)*ysize

;------------------------------------------------------------
IF opt EQ 2 THEN BEGIN

	perimeter = 0D

	FOR j=1L, ysize-2 DO BEGIN
		FOR i=1L, xsize-2 DO BEGIN
			per_pix = 0D
			IF image_bin[i,j] EQ 1 THEN BEGIN	; Pixel object
				v1 = image_bin[i-1,j  ] EQ 0
				v2 = image_bin[i+1,j  ] EQ 0
				v3 = image_bin[i,  j-1] EQ 0
				v4 = image_bin[i,  j+1] EQ 0

				per_pix = SQRT(0D + v1 + v2 + v3 + v4)
			ENDIF
			perimeter = perimeter + per_pix
		ENDFOR
	ENDFOR

	RETURN, perimeter
ENDIF
;------------------------------------------------------------
IF opt EQ 1 THEN BEGIN

	image_perim = image_bin*0
	;image_per   = image_bin*0
	perimeter = 0D
	val_1 = 1D
	val_2 = SQRT(2)
	val_3 = (val_2 + val_1)/2

	;FOR j=1L, ysize-2 DO BEGIN		; Contruct image of perimeter
	;	FOR i=1L, xsize-2 DO BEGIN
	;		IF image_bin[i,j] EQ 1 THEN BEGIN ; PIxel object
	;			v1 = image_bin[i-1,j  ]
	;			v2 = image_bin[i+1,j  ]
	;			v3 = image_bin[i,  j-1]
	;			v4 = image_bin[i,  j+1]
	;			IF (v1+ v2 +v3 +v4) NE 4 THEN BEGIN ; Perimeter Pixel (4 neighbours)
	;				image_perim[i,j] = 1
	;			ENDIF
	;		ENDIF
	;	ENDFOR
	;ENDFOR

	image_perim = Binreg_frontier(image_bin)

	FOR j=1L, ysize-2 DO BEGIN		; Measures perimeter with templates
		FOR i=1L, xsize-2 DO BEGIN
			IF image_perim[i,j] EQ 1 THEN BEGIN
				v1 = image_perim[i-1,j  ] + $
					image_perim[i+1,j  ] + $
					image_perim[i,  j-1] + $
					image_perim[i,  j+1]

				IF v1 GE 2 THEN $
					perimeter = perimeter + val_1 $
				ELSE IF v1 EQ 1 THEN $
					perimeter = perimeter + val_3 $
				ELSE IF v1 EQ 0 THEN $
					perimeter = perimeter + val_2

				;image_per[i,j] = v1
			ENDIF
		ENDFOR
	ENDFOR

	IF perimeter EQ 255 THEN BEGIN
		PRINT, 'hello'
	ENDIF

	RETURN, perimeter

ENDIF

END