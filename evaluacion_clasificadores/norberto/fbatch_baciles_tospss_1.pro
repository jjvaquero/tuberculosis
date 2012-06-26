
;Fbatch_baciles_toSPSS_1

;
; ok = Fbatch_baciles_toSPSS_1(CULTURE='21_09_01', /MARKED)
;
; el objetivo (bastante ambicioso) se esta función es leer una serie de imágenes originales,
; sus máscaras de segmentación, evaluar las características de los candidatos a bacilos y crear
; un archivo de texto que pueda leer el Programa SPSS
;
; Además también tiene que saber leer automáticamente una imagen marcada manualmente y asignarle a
; cada candidato bacilo una etiqueta de 1 ,2, 3. Según la marcación manual (esto lo incluiremos
; como parámetro para imagenes marcadas (si existen)
;
; Como los parámetros de las imágenes son bastantes. Se decide crear dos archivos de tabuladores
;
; Con el keyword /ADVANCED, se crea otra serie de archivos con otros parámetros
;
;
;-------------------------------------------------------------------------------------------

FUNCTION  Fbatch_baciles_toSPSS_1, CULTURE=culture, MARKED=marked, $
									ADVANCED=advanced, SIMPLE=simple, MOMENTS=moments


IF KEYWORD_SET(marked)   THEN opt_marked   = 1 ELSE opt_marked=0
IF KEYWORD_SET(advanced) THEN opt_advanced = 1 ELSE opt_advanced = 0
IF KEYWORD_SET(simple)   THEN opt_simple   = 1 ELSE opt_simple   = 0
IF KEYWORD_SET(moments)  THEN opt_moments  = 1 ELSE opt_moments  = 0
;-------------------------------------------------------------------------------------------

str_disk = 'e:' ;'e:'

path_images_original = str_disk + '\micro\images\'
path_images_results  = str_disk + '\micro\results\'


IF N_ELEMENTS(culture) EQ 0 THEN BEGIN
	culture = '21_09_01'
	pathadd_directory    = culture + '\'  ; 13_10_01\ ; 27_09_01
ENDIF ELSE BEGIN
	IF STRPOS(culture, '\') EQ -1 THEN $
		pathadd_directory     = culture +'\' $
	ELSE pathadd_directory    = culture
ENDELSE

;pathadd_session      = 'Prueba_1\'
pathadd_session      = ''

path_results  = path_images_results  + pathadd_directory + pathadd_session
path_original = path_images_original + pathadd_directory
path_marked   = path_images_original + pathadd_directory + 'marked\'

; Busca todas las imagenes del directorio
;-------------------------------------------------------------------------------
str_out = 'mar.tif'
str_fileimages = FINDFILE(path_original+'*.tif')
str_fileimages = STRLOWCASE(str_fileimages)
n_images = N_ELEMENTS(str_fileimages)

matcharr_string    = STRPOS(str_fileimages, str_out)
pos_fileimages_out = WHERE(matcharr_string NE -1)

IF pos_fileimages_out[0] NE -1 THEN BEGIN	;hay imagenes que hay que descartar
	str_fileimages[pos_fileimages_out] = ''
ENDIF
str_fileimages_2 = ''
FOR i=0L, n_images-1 DO BEGIN
	IF str_fileimages[i] NE '' THEN BEGIN
		str_aux = str_fileimages[i]
		str_fileimages_2 = [str_fileimages_2, str_aux]
	ENDIF
ENDFOR
IF N_ELEMENTS(str_fileimages_2) GT 1 THEN BEGIN
	str_fileimages_2 = str_fileimages_2[1:N_ELEMENTS(str_fileimages_2)-1]
ENDIF
str_fileimages = REFORM(str_fileimages_2, 1, N_ELEMENTS(str_fileimages_2))
n_images       = N_ELEMENTS(str_fileimages)

; Ahora separa el path de la fila
;------------------------------------------------------------------------------
FOR i=0l, n_images-1 DO BEGIN
	pos = STRPOS(str_fileimages[i], '\', /REVERSE_SEARCH)
	str_fileimages[i] = STRMID(str_fileimages[i], pos+1)
	pos = STRPOS(str_fileimages[i], '.')
	str_fileimages[i] = STRMID(str_fileimages[i], 0, pos)
ENDFOR
;------------------------------------------------------------------------------
; Ahora busca las imagenes marcadas,
IF opt_marked EQ 1 THEN BEGIN
	str_fileimagesmarked = STRARR(1, n_images)
	str_fileimagesmarked = str_fileimages + 'marked'
ENDIF
;------------------------------------------------------------------------------
; Ahora busca las imagenes segmentadas,
str_fileimagessegmented = STRARR(1, n_images)
str_fileimagessegmented  = str_fileimages + '_mask1'

;------------------------------------------------------------------------------

; Ya tenemos los arrays de strings con las imagenenes originales, marcadas y segmentadas
; (deberán tener igual número de elementos y estar ordenadas)
; Por lo tanto, a leer y ver datos
;------------------------------------------------------------------------------

FOR i=0L, n_images-1  DO BEGIN

	file_im_orig   = str_fileimages[i] + '.tif'
	file_im_mask   = str_fileimagessegmented[i] + '.tif'

	im_orig   = READ_TIFF(path_original + file_im_orig,  ORDER=order1)
	im_mask   = READ_TIFF(path_results  + file_im_mask,  ORDER=order3)
	IF opt_marked EQ 1 THEN BEGIN
		file_im_marked = str_fileimagesmarked[i] + '.tif'
		im_marked = READ_TIFF(path_marked   + file_im_marked, ORDER=order2)
		im_marked = classify_class(im_mask, im_marked)
	ENDIF

	;-------------------------------------------------------
	pos_aux     = STRPOS(file_im_orig, '.')
	str_number1 = STRMID(file_im_orig, pos_aux-2, 1)
	str_number2 = STRMID(file_im_orig, pos_aux-1, 1)
	ascii_num1  = (BYTE(str_number1))[0]
	ascii_num2  = (BYTE(str_number2))[0]
	IF (ascii_num1 LT 48) OR (ascii_num1 GT 57) THEN $
		str_number = str_number2 $
	ELSE $
		str_number = str_number1 + str_number2
	;-------------------------------------------------------


	length_number = STRLEN(str_number)
	IF length_number EQ 1 THEN BEGIN	; Cambiamos '1' a '01'
	   strarr_parts = STRSPLIT(str_fileimages[i], str_number, /EXTRACT, /PRESERVE_NULL)
	   str_filename = strarr_parts[0] + '0' + str_number + strarr_parts[1]
	ENDIF ELSE BEGIN
		str_filename = str_fileimages[i]
	ENDELSE

	;-------------------------------------------------------
	str_ind = '_i'
	IF opt_simple   EQ 1 THEN str_ind = str_ind + 'S'
	IF opt_advanced EQ 1 THEN str_ind = str_ind + 'A'
	IF opt_moments  EQ 1 THEN str_ind = str_ind + 'M'

	file_spss = path_results + str_filename + '_IDL_spss' + str_ind + '.txt'

	IF i EQ 0L THEN opt_head = 1 ELSE opt_head = 0

	IF (opt_marked EQ 1) THEN BEGIN
		;****************************************************************************
		ok = Write_SPSS_archive_2(file_spss, im_orig, im_mask, IM_MARKED=im_marked, $
			CULTURE=culture, N_IMAGE=str_number, HEAD=opt_head, $
			SIMPLE=simple, ADVANCED=opt_advanced, MOMENTS=opt_moments)
		;****************************************************************************
	ENDIF ELSE BEGIN
		;****************************************************************************
		ok = Write_SPSS_archive_2(file_spss, im_orig, im_mask, $
			CULTURE=culture, N_IMAGE=str_number,  HEAD=opt_head, $
			SIMPLE=simple, ADVANCED=opt_advanced, MOMENTS=opt_moments)
		;****************************************************************************
	ENDELSE

	PRINT, 'Nueva imagen  ', i , ' de ' , n_images

ENDFOR

PRINT, 'yastá'

RETURN, 1

END



