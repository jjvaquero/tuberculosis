

FUNCTION Superpone_mask,  image_1, im_2, COLOR1=color1, COLOR2=color2, LEVEL=level, $
							PIA=pia

; Superpone una máscara binaria, "im_2" sobre "im_1", con COLOR=color1 y transparencia level

; imágenes planas de NIVEL DE GRIS y de COLOR. La máscara del mismo tamaño
; a la primera en color
;
;   PIA       - Con esta keyword, utiliza el estilo de la plataforma

;--------------------------------------------------------------------------------------

IF MAX(im_2) GT 1 THEN BEGIN & PRINT, ' No es máscara válida' & RETURN, -1 & ENDIF
IF MAX(im_2) LT 0 THEN BEGIN & PRINT, ' No es máscara válida' & RETURN, -1 & ENDIF

IF KEYWORD_SET(pia)   THEN opt_pia = 1 ELSE opt_pia = 0
IF NOT KEYWORD_SET(color1)   THEN col1=[0,0,255] ELSE col1 = color1
IF NOT KEYWORD_SET(color2)   THEN col2=[0,0,0]   ELSE col2 = color2
IF     N_ELEMENTS(level) EQ 0  THEN lev=0.5      ELSE  lev = 0.0 > FLOAT(level) < 1.0

;--------------------------------------------------------------------------------------

DEVICE, decomposed=1

tam   = SIZE(image_1)
xsize = (SIZE(im_2))[1]
ysize = (SIZE(im_2))[2]

;--------------------------------------------------------------------------------------
IF tam[0] EQ 2  THEN BEGIN 	   ; imagen de gris
	IF MIN(image_1) LT 0 OR MAX(image_1) GT 255 THEN im_1 = BYTSCL(image_1) ELSE im_1 = BYTE(image_1)
	imag1_R = im_1
	imag1_G = im_1
	imag1_B = im_1
ENDIF

IF tam[0] EQ 3  THEN BEGIN     ; Imagen de color

	IF tam[1] EQ 3  THEN BEGIN  ; TRUE=1
		imag1_R = REFORM(image_1[0,*,*], tam[2],tam[3])
		imag1_G = REFORM(image_1[1,*,*], tam[2],tam[3])
		imag1_B = REFORM(image_1[2,*,*], tam[2],tam[3])
	ENDIF
	IF tam[2] EQ 3  THEN BEGIN  ; TRUE=2
		imag1_R = REFORM(image_1[*,0,*], tam[1],tam[3])
		imag1_G = REFORM(image_1[*,1,*], tam[1],tam[3])
		imag1_B = REFORM(image_1[*,2,*], tam[1],tam[3])
	ENDIF
	IF tam[3] EQ 3  THEN BEGIN  ; TRUE=3
		imag1_R = REFORM(image_1[*,*,0], tam[1],tam[2])
		imag1_G = REFORM(image_1[*,*,1], tam[1],tam[2])
		imag1_B = REFORM(image_1[*,*,2], tam[1],tam[2])
	ENDIF
ENDIF
;--------------------------------------------------------------------------------------

IF  MIN((SIZE(imag1_R))[1:2] EQ (SIZE(im_2))[1:2]) NE 1 THEN BEGIN
	PRINT, 'Tamaños incompatibles'
	DEVICE, decomposed=0
	RETURN, -1
ENDIF
;--------------------------------------------------------------------------------------

IF opt_pia EQ 0 THEN BEGIN

	COLOR_CONVERT, imag1_R, imag1_G, imag1_B,   imag1_H, imag1_S, imag1_V, /RGB_HSV

	imag2_R = im_2*col1[0]
	imag2_G = im_2*col1[1]
	imag2_B = im_2*col1[2]

	COLOR_CONVERT, imag2_R, imag2_G, imag2_B, imag2_H, imag2_S, imag2_V, /RGB_HSV
	;--------------------------------------------------------------------------------

	imag_final_H = imag1_H
	imag_final_S = imag1_S
	imag_final_V = imag1_V

	IF TOTAL(im_2) GT 0 THEN BEGIN	;Previene máscaras con todo cero

		imag_final_H(WHERE(im_2 NE 0))  = (imag2_H(WHERE(im_2 NE 0)))
		imag_final_S(WHERE(im_2 NE 0))  = (imag2_S(WHERE(im_2 NE 0)))
		imag_final_V(WHERE(im_2 NE 0))  = (imag2_V(WHERE(im_2 NE 0))*lev + imag1_V(WHERE(im_2 NE 0))*(1-lev)) < 1.0

	ENDIF

	COLOR_CONVERT, imag_final_H, imag_final_S, imag_final_V, imag_final_R, imag_final_G, imag_final_B, /HSV_RGB

	imag_final_RGB = BYTARR(xsize, ysize, 3)
	imag_final_RGB[*,*,0]=imag_final_R
	imag_final_RGB[*,*,1]=imag_final_G
	imag_final_RGB[*,*,2]=imag_final_B

;--------------------------------------------------------------------------------
ENDIF
IF opt_pia EQ 1 THEN BEGIN

	auxRGB = BYTARR(xsize, ysize, 3)
	auxRGB[*,*,1] = im_2*FIX(lev*100)

	imag_final_RGB = BYTARR(xsize, ysize, 3)

    imag_final_RGB[*,*,0] = BYTE( (auxRGB[*,*,0] +FIX(imag1_R)) <255B)
	imag_final_RGB[*,*,1] = BYTE( (auxRGB[*,*,1] +FIX(imag1_G)) <255B)
	imag_final_RGB[*,*,2] = BYTE( (auxRGB[*,*,2] +FIX(imag1_B)) <255B)

ENDIF

DEVICE, decomposed=0

RETURN, imag_final_RGB


END