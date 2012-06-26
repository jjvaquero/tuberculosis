

 FUNCTION Write_SPSS_archive_2, file, image_orig, image_mask, $
 		IM_MARKED=im_marked, HEAD=head, $
 		CULTURE=culture, N_IMAGE=n_image, SIMPLE=simple, ADVANCED=advanced, MOMENTS=moments, $
 		FOURIER=fourier

;---------------------------------------------------------------------------------------
; Esta función escribe un archivo de texto compatible con SPSS
; a partir de una imagen original (tres canales y true =1) y la máscara de segmentación

; Necesita introducir dos arrays: la cultura y el número de imagen (para identificacion posterior)

; Con la imagen IM_MARKED, además se trabaja con imágenes marcadas: que tienen la siguiente clave
;
; 1 - Es bacilo
; 2 - No es bacilo
; 3 - Dudoso
;
; Si se trabaja con imágenes sin marcar. la colummna de 'class' se deja a cero
;
; Como los parámetros de las imágenes son bastantes. Se decide crear dos archivos de tabuladores
; Opción HEAD = escribe cabecera con nombre de funciones
;
; Con el keyword /SIMPLE, /ADVANCED, /MOMENTS o /FOURIER, se crean
; distintas series de valores (se pueden sumar)
;
; Parámetros comunes:
;
; - culture  : Identificador  de cultivo (directorio)
; - n_image  : Número de imagen
; - class    : Clase (si la imagen está marcada) si no, cero
; - index    : Identificador de región

; Con /SIMPLE:
;
; - size     : Número de píxeles
; - perim    : Perímetro
; - mean_r   : media del canal rojo
; - mean_g   : media del canal verde
; - mean_b   : media del canal azul
; - stdv_r   : desviación standard del canal rojo
; - stdv_g   : desviación standard del canal verde
; - stdv_b   : desviación standard del canal azul
;
; Con /ADVANCED:

; - origin_x : El lugar X del cuadrado recto que inscribe a la imagen
; - origin_y : El lugar Y del cuadrado recto que inscribe a la imagen
; - cmass_x   : Centro de masas relativo en X de la máscara (se suma a origin_x)
; - cmass_y   : Centro de masas relativo en Y de la máscara
; - gcmass_x  : Centro de masas relativo en X (en el canal verde)
; - gcmass_y  : Centro de masas relativo en Y (en el canal verde)
; - longdim   : "Longest Dimension", la longitud del mayor segmento contenido en la imagen
; - thinness  : "thinness" o delgadez mediante computo de los momentos
; - angle     : Angulo mediante computo de los momentos
; - ffactor   : Factor de forma, o circularidad (4*pi*A/P^2)
; - feretd    : "Feret diameter"
; - compact   : "compactness" dividiendo el diñametro de Feret entre el eje mayor
; - maxr      : Radio máximo
; - minr      : Radio mínimo
; - maxdist   : Distancia máxima de un punto al fondo
; - rectness  : Rectangularidad, o relación con el área del rectángulo inscrito más pequeño
;
; con /MOMENTS,
;
;  'm11'      - Momentos (i,j) (en imagen de gris del canal verde)
;  'm20'
;  'm02'
;  'm21'
;  'm12'
;  'm30'
;  'm03'
;  'm22'
;  'm31'
;  'm13'
;  'm40'
;  'm04'
;
; Con FOURIER,
;
; - f_1x	; Descriptores de Fourier ( de la forma o shape)
; - f_1y
; - f_2x
; - f_2y
;---------------------------------------------------------------------------------------
;---------------------------------------------------------------------------------------

T = SYSTIME(1)

IF KEYWORD_SET(head) THEN opt_head = 1 ELSE opt_head = 0

IF N_ELEMENTS(im_marked) EQ 0 THEN opt_marked = 0 ELSE opt_marked = 1
IF KEYWORD_SET(advanced) THEN opt_advanced = 1 ELSE opt_advanced = 0
IF KEYWORD_SET(simple)   THEN opt_simple   = 1 ELSE opt_simple   = 0
IF KEYWORD_SET(moments)  THEN opt_moments  = 1 ELSE opt_moments  = 0
;-------------------------------------------------------------------------

n_regs = MAX(image_mask)	;número de baciletes

IF n_regs LE 0 THEN BEGIN
	PRINT, 'No hay ninguna región, no se escriben datos, solamente la cabecera'

	;RETURN, -1
ENDIF

tam_1 = SIZE(image_mask)
tam_2 = SIZE(image_orig)

xsize = tam_1[1]
ysize = tam_1[2]

;image_orig_r = image_orig[0,*,*]
;image_orig_g = image_orig[1,*,*]
;image_orig_b = image_orig[2,*,*]

IF tam_2[1] EQ 3 THEN BEGIN	;true=1
	IF MIN(tam_1[1:2] EQ tam_2[2:3]) NE 1 THEN BEGIN
		PRINT, 'Las imagenes no son complatibles'
		RETURN, -1
	ENDIF
ENDIF
IF tam_2[1] NE 3 THEN BEGIN
	PRINT, 'Las imagenes necesitan tener TRUE = 1'
	RETURN, -1
ENDIF

;------------------------------------------------------------------------------
;------------------------------------------------------------------------------
; Comunes

str_tab = STRING(9B)

IF opt_head EQ 1 THEN BEGIN	; Tiene que escribir la cabecera con el nombre de variable

		str_culture = 'culture'
		str_nimage  = 'n_image'
		str_class   = 'class'
		str_index   = 'index'

	IF opt_simple EQ 1 THEN BEGIN
		str_size    = 'size'
		str_peri    = 'perim'
		str_mean_r  = 'mean_r'
		str_mean_g  = 'mean_g'
		str_mean_b  = 'mean_b'
		str_stdv_r  = 'stdv_r'
		str_stdv_g  = 'stdv_g'
		str_stdv_b  = 'stdv_b'
	ENDIF
	IF opt_advanced EQ 1 THEN BEGIN
		str_origin_x = 'origin_x'
		str_origin_y = 'origin_y'
		str_cmass_x  = 'cmass_x'
		str_cmass_y  = 'cmass_y'
		str_gcmass_x = 'gcmass_x'
		str_gcmass_y = 'gcmass_y'
		str_longdim  = 'longdim'
		str_thinness = 'thinness'
		str_angle    = 'angle'
		str_ffactor  = 'ffactor'
		str_feretd   = 'feretd'
		str_compact  = 'compact'
		str_maxr     = 'maxr'
		str_minr     = 'minr'
		str_maxdist  = 'maxdist'
		str_rectness = 'rectness'
	ENDIF
	IF opt_moments EQ 1 THEN BEGIN
		str_m11    = 'm11'
		str_m20    = 'm20'
		str_m02    = 'm02'
		str_m21    = 'm21'
		str_m12    = 'm12'
		str_m30    = 'm30'
		str_m03    = 'm03'
		str_m22    = 'm22'
		str_m31    = 'm31'
		str_m13    = 'm13'
		str_m40    = 'm40'
		str_m04    = 'm04'
	ENDIF
ENDIF

IF n_regs GE 1 THEN BEGIN

		regs_class = INTARR(1, n_regs)
		regs_index = INTARR(1, n_regs)

	IF opt_simple EQ 1 THEN BEGIN
		regs_size    = INTARR(1, n_regs)
		regs_peri  	 = FLTARR(1, n_regs)
		regs_mean_r  = FLTARR(1, n_regs)
		regs_mean_g  = FLTARR(1, n_regs)
		regs_mean_b  = FLTARR(1, n_regs)
		regs_stdv_r  = FLTARR(1, n_regs)
		regs_stdv_g  = FLTARR(1, n_regs)
		regs_stdv_b  = FLTARR(1, n_regs)
	ENDIF
	IF opt_advanced EQ 1 THEN BEGIN
		regs_origin_x  = INTARR(1, n_regs)
		regs_origin_y  = INTARR(1, n_regs)
		regs_cmass_x  = FLTARR(1, n_regs)
		regs_cmass_y  = FLTARR(1, n_regs)
		regs_gcmass_x = FLTARR(1, n_regs)
		regs_gcmass_y = FLTARR(1, n_regs)
		regs_longdim  = FLTARR(1, n_regs)
		regs_thinness = FLTARR(1, n_regs)
		regs_angle    = FLTARR(1, n_regs)
		regs_ffactor  = FLTARR(1, n_regs)
		regs_feretd   = FLTARR(1, n_regs)
		regs_compact  = FLTARR(1, n_regs)
		regs_maxr     = FLTARR(1, n_regs)
		regs_minr     = FLTARR(1, n_regs)
		regs_maxdist  = FLTARR(1, n_regs)
		regs_rectness = FLTARR(1, n_regs)
	ENDIF
	IF opt_moments EQ 1 THEN BEGIN
		regs_m11  = FLTARR(1, n_regs)
		regs_m20  = FLTARR(1, n_regs)
		regs_m02  = FLTARR(1, n_regs)
		regs_m21  = FLTARR(1, n_regs)
		regs_m12  = FLTARR(1, n_regs)
		regs_m30  = FLTARR(1, n_regs)
		regs_m03  = FLTARR(1, n_regs)
		regs_m22  = FLTARR(1, n_regs)
		regs_m31  = FLTARR(1, n_regs)
		regs_m13  = FLTARR(1, n_regs)
		regs_m40  = FLTARR(1, n_regs)
		regs_m04  = FLTARR(1, n_regs)
	ENDIF
ENDIF

IF opt_head EQ 1 THEN BEGIN

		str_variables = $
			str_culture + str_tab + $
			str_nimage  + str_tab + $
			str_index   + str_tab + $
			str_class

	IF opt_simple EQ 1 THEN BEGIN
		str_variables = $
			str_variables + str_tab + $
			str_size    + str_tab + $
			str_peri    + str_tab + $
			str_mean_r  + str_tab + $
			str_mean_g  + str_tab + $
			str_mean_b  + str_tab + $
			str_stdv_r  + str_tab + $
			str_stdv_g  + str_tab + $
			str_stdv_b
	ENDIF
	IF opt_advanced EQ 1 THEN BEGIN
		str_variables = $
			str_variables + str_tab + $
			str_origin_x  + str_tab + $
			str_origin_y  + str_tab + $
			str_cmass_x  + str_tab + $
			str_cmass_y  + str_tab + $
			str_gcmass_x + str_tab + $
			str_gcmass_y + str_tab + $
			str_longdim  + str_tab + $
			str_thinness + str_tab + $
			str_angle    + str_tab + $
			str_ffactor  + str_tab + $
			str_feretd   + str_tab + $
			str_compact  + str_tab + $
			str_maxr     + str_tab + $
			str_minr     + str_tab + $
			str_maxdist  + str_tab + $
			str_rectness
	ENDIF
	IF opt_moments EQ 1 THEN BEGIN
		str_variables = $
			str_variables + str_tab + $
			str_m11  + str_tab + $
			str_m20  + str_tab + $
			str_m02	 + str_tab + $
			str_m21	 + str_tab + $
			str_m12	 + str_tab + $
			str_m30	 + str_tab + $
			str_m03	 + str_tab + $
			str_m22	 + str_tab + $
			str_m31	 + str_tab + $
			str_m13  + str_tab + $
			str_m40	 + str_tab + $
			str_m04
	ENDIF
ENDIF

;-----------------------------------------------------------------------------
;-----------------------------------------------------------------------------
;SIMPLE

IF n_regs GE 1 THEN BEGIN

	FOR i=0L, n_regs-1 DO BEGIN
		regs_index[i] = i+1
		arr_pospixel  = WHERE(image_mask EQ i+1)
		smallimag     = binreg_isolate(arr_pospixel, XSIZE=xsize, YSIZE=ysize, /IMAGE)
		smallimag_col = binreg_colorisolate(arr_pospixel, image_orig, XSIZE=xsize, YSIZE=ysize)
		smallimag_r   = REFORM(smallimag_col[0,*,*])
		smallimag_g   = REFORM(smallimag_col[1,*,*])
		smallimag_b   = REFORM(smallimag_col[2,*,*])
		arr_valuepixel_r = smallimag_r[WHERE(smallimag)]
		arr_valuepixel_g = smallimag_g[WHERE(smallimag)]
		arr_valuepixel_b = smallimag_b[WHERE(smallimag)]
		IF opt_marked EQ 1 THEN BEGIN	; averiguar la clase marcada
			regs_class[i] = im_marked[arr_pospixel[0]]
			IF i EQ 56 THEN BEGIN
				PRINT, 'Breakpoint'
			ENDIF
		ENDIF
		IF opt_simple EQ 1 THEN BEGIN
			regs_size[i]    = N_ELEMENTS(arr_pospixel)
			regs_mean_r[i]  = MEAN(arr_valuepixel_r)
			regs_mean_g[i]  = MEAN(arr_valuepixel_g)
			regs_mean_b[i]  = MEAN(arr_valuepixel_b)
			regs_stdv_r[i]  = SQRT(varianza(arr_valuepixel_r))
			regs_stdv_g[i]  = SQRT(varianza(arr_valuepixel_g))
			regs_stdv_b[i]  = SQRT(varianza(arr_valuepixel_b))
			regs_peri[i]    = binreg_perimeter(smallimag)
		ENDIF
		IF opt_advanced EQ 1 THEN BEGIN
			origin = Binreg_origin(arr_pospixel, XSIZE=xsize, YSIZE=ysize)
			cmass  = Binreg_centermass(smallimag, /FLOATING)
			gcmass = Binreg_centermass(smallimag, smallimag_g, /FLOATING)
			regs_origin_x[i] = origin[0]
			regs_origin_y[i] = origin[1]
			regs_cmass_x[i]  = cmass[0]
			regs_cmass_y[i]  = cmass[1]
			regs_gcmass_x[i] = gcmass[0]
			regs_gcmass_y[i] = gcmass[1]
			regs_longdim[i]  = Binreg_longestDimension(smallimag)
			regs_thinness[i] = Binreg_Thinness(smallimag)
			regs_angle[i]    = Binreg_angle(smallimag)
			regs_ffactor[i]  = Binreg_formfactor(smallimag)
			regs_feretd[i]   = Binreg_feretdiameter(smallimag)
			regs_compact[i]  = Binreg_compactness(smallimag)
			regs_maxr[i]     = Binreg_maximumradius(smallimag)
			regs_minr[i]     = Binreg_minimumradius(smallimag)
			regs_maxdist[i]  = Binreg_maximumdistance(smallimag)
			regs_rectness[i] = Binreg_rectangularity(smallimag)
		ENDIF
		IF opt_moments EQ 1 THEN BEGIN
			regs_m11[i]  = Binreg_moments(smallimag, smallimag_g, NI=1, NJ=1, /NORMALIZE)
			regs_m20[i]  = Binreg_moments(smallimag, smallimag_g, NI=2, NJ=0, /NORMALIZE)
			regs_m02[i]  = Binreg_moments(smallimag, smallimag_g, NI=0, NJ=2, /NORMALIZE)
			regs_m21[i]  = Binreg_moments(smallimag, smallimag_g, NI=2, NJ=1, /NORMALIZE)
			regs_m12[i]  = Binreg_moments(smallimag, smallimag_g, NI=1, NJ=2, /NORMALIZE)
			regs_m30[i]  = Binreg_moments(smallimag, smallimag_g, NI=3, NJ=0, /NORMALIZE)
			regs_m03[i]  = Binreg_moments(smallimag, smallimag_g, NI=0, NJ=3, /NORMALIZE)
			regs_m22[i]  = Binreg_moments(smallimag, smallimag_g, NI=2, NJ=2, /NORMALIZE)
			regs_m31[i]  = Binreg_moments(smallimag, smallimag_g, NI=3, NJ=1, /NORMALIZE)
			regs_m13[i]  = Binreg_moments(smallimag, smallimag_g, NI=1, NJ=3, /NORMALIZE)
			regs_m40[i]  = Binreg_moments(smallimag, smallimag_g, NI=4, NJ=0, /NORMALIZE)
			regs_m04[i]  = Binreg_moments(smallimag, smallimag_g, NI=0, NJ=4, /NORMALIZE)
		ENDIF

	ENDFOR

;------------------------------------------------------

		s_culture = culture
		s_nimage  = n_image
		s_index   = STRTRIM(STRING(regs_index,   FORMAT ='(I24)'), 2)
		s_class   = STRTRIM(STRING(regs_class,   FORMAT ='(I24)'), 2)

	IF opt_simple EQ 1 THEN BEGIN
		s_size    = STRTRIM(STRING(regs_size,    FORMAT ='(I24)'), 2)
		s_peri    = STRTRIM(STRING(regs_peri,    FORMAT ='(F33.8)'),2)
		s_mean_r  = STRTRIM(STRING(regs_mean_r,  FORMAT ='(F33.8)'),2)
		s_mean_g  = STRTRIM(STRING(regs_mean_g,  FORMAT ='(F33.8)'),2)
		s_mean_b  = STRTRIM(STRING(regs_mean_b,  FORMAT ='(F33.8)'),2)
		s_stdv_r  = STRTRIM(STRING(regs_stdv_r,  FORMAT ='(F33.8)'),2)
		s_stdv_g  = STRTRIM(STRING(regs_stdv_g,  FORMAT ='(F33.8)'),2)
		s_stdv_b  = STRTRIM(STRING(regs_stdv_b,  FORMAT ='(F33.8)'),2)
	ENDIF
	IF opt_advanced EQ 1 THEN BEGIN
		s_origin_x = STRTRIM(STRING(regs_origin_x, FORMAT ='(I24)'), 2)
		s_origin_y = STRTRIM(STRING(regs_origin_y, FORMAT ='(I24)'), 2)
		s_cmass_x  = STRTRIM(STRING(regs_cmass_x,  FORMAT ='(F33.8)'), 2)
		s_cmass_y  = STRTRIM(STRING(regs_cmass_y,  FORMAT ='(F33.8)'), 2)
		s_gcmass_x = STRTRIM(STRING(regs_gcmass_x, FORMAT ='(F33.8)'), 2)
		s_gcmass_y = STRTRIM(STRING(regs_gcmass_y, FORMAT ='(F33.8)'), 2)
		s_longdim  = STRTRIM(STRING(regs_longdim,  FORMAT ='(F33.8)'), 2)
		s_thinness = STRTRIM(STRING(regs_thinness, FORMAT ='(F33.8)'), 2)
		s_angle    = STRTRIM(STRING(regs_angle,    FORMAT ='(F33.8)'), 2)
		s_ffactor  = STRTRIM(STRING(regs_ffactor,  FORMAT ='(F33.8)'), 2)
		s_feretd   = STRTRIM(STRING(regs_feretd,   FORMAT ='(F33.8)'), 2)
		s_compact  = STRTRIM(STRING(regs_compact,  FORMAT ='(F33.8)'), 2)
		s_maxr     = STRTRIM(STRING(regs_maxr,     FORMAT ='(F33.8)'), 2)
		s_minr     = STRTRIM(STRING(regs_minr,     FORMAT ='(F33.8)'), 2)
		s_maxdist  = STRTRIM(STRING(regs_maxdist,  FORMAT ='(F33.8)'), 2)
		s_rectness = STRTRIM(STRING(regs_rectness, FORMAT ='(F33.8)'), 2)
	ENDIF
	IF opt_moments EQ 1 THEN BEGIN
		s_m11    = STRTRIM(STRING(regs_m11,    FORMAT ='(F33.8)'), 2)
		s_m20    = STRTRIM(STRING(regs_m20,    FORMAT ='(F33.8)'), 2)
		s_m02    = STRTRIM(STRING(regs_m02,    FORMAT ='(F33.8)'), 2)
		s_m21    = STRTRIM(STRING(regs_m21,    FORMAT ='(F33.8)'), 2)
		s_m12    = STRTRIM(STRING(regs_m12,    FORMAT ='(F33.8)'), 2)
		s_m30    = STRTRIM(STRING(regs_m30,    FORMAT ='(F33.8)'), 2)
		s_m03    = STRTRIM(STRING(regs_m03,    FORMAT ='(F33.8)'), 2)
		s_m22    = STRTRIM(STRING(regs_m22,    FORMAT ='(F33.8)'), 2)
		s_m31    = STRTRIM(STRING(regs_m31,    FORMAT ='(F33.8)'), 2)
		s_m13    = STRTRIM(STRING(regs_m13,    FORMAT ='(F33.8)'), 2)
		s_m40    = STRTRIM(STRING(regs_m40,    FORMAT ='(F33.8)'), 2)
		s_m04    = STRTRIM(STRING(regs_m04,    FORMAT ='(F33.8)'), 2)
	ENDIF
ENDIF

;-----------------------------------------------------------------------------
;-----------------------------------------------------------------------------

OPENW, unit, file, /GET_LUN

IF opt_head EQ 1 THEN BEGIN
	PRINTF, unit, str_variables
ENDIF

IF n_regs GE 1 THEN BEGIN
	FOR i=0L, n_regs-1 DO BEGIN

			str_completeline = $
				s_culture  + str_tab + $
				s_nimage   + str_tab + $
				s_index[i] + str_tab + $
				s_class[i]

		IF opt_simple EQ 1 THEN BEGIN
			str_completeline = $
				str_completeline + str_tab + $
				s_size[i]  + str_tab + $
				s_peri[i]  + str_tab + $
				s_mean_r[i]  + str_tab + $
				s_mean_g[i]  + str_tab + $
				s_mean_b[i]  + str_tab + $
				s_stdv_r[i]  + str_tab + $
				s_stdv_g[i]  + str_tab + $
				s_stdv_b[i]
		ENDIF

		IF opt_advanced EQ 1 THEN BEGIN
			str_completeline = $
				str_completeline + str_tab + $
				s_origin_x[i] + str_tab + $
				s_origin_y[i] + str_tab + $
				s_cmass_x[i]  + str_tab + $
				s_cmass_y[i]  + str_tab + $
				s_gcmass_x[i] + str_tab + $
				s_gcmass_y[i] + str_tab + $
				s_longdim[i]  + str_tab + $
				s_thinness[i] + str_tab + $
				s_angle[i]    + str_tab + $
				s_ffactor[i]  + str_tab + $
				s_feretd[i]   + str_tab + $
				s_compact[i]  + str_tab + $
				s_maxr[i]     + str_tab + $
				s_minr[i]     + str_tab + $
				s_maxdist[i]  + str_tab + $
				s_rectness[i]
		ENDIF

		IF opt_moments EQ 1 THEN BEGIN
			str_completeline = $
				str_completeline + str_tab + $
				s_m11[i]  + str_tab + $
				s_m20[i]  + str_tab + $
				s_m02[i]  + str_tab + $
				s_m21[i]  + str_tab + $
				s_m12[i]  + str_tab + $
				s_m30[i]  + str_tab + $
				s_m03[i]  + str_tab + $
				s_m22[i]  + str_tab + $
				s_m31[i]  + str_tab + $
				s_m13[i]  + str_tab + $
				s_m40[i]  + str_tab + $
				s_m04[i]
		ENDIF

		PRINTF, unit, str_completeline

	ENDFOR
ENDIF
;------------------------------------------------------

CLOSE, unit
FREE_LUN, unit


PRINT, 'Tiempo de proceso de una imagen (Write_SPSS_archive_2):  ', SYSTIME(1)-T

RETURN, 1

END


