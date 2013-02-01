

FUNCTION FBatch_Baciles_Segment_1, CULTURE=culture

; ok = FBatch_Baciles_Segment_1(CULTURE='21_09_01')
;
; El objetivo de esta función es aplicar un algoritmo de segmentación (o en principio de
; cualquier otro tipo) a las imágenes almacenadas en un directorio y grabar los resultados en
; otro directorio especificado
;
; Al ser de tipo "batch" aunque sigue siendo una función, los parámetros se introducirán
; internamente (en el código) por defecto.
;
;
;
; El directorio de las imágenes que se van a procesar
; Se procesarán todas las imágenes de ese directorio
;-----------------------------------------------------------------------------

str_disk = 'e:' ;'e:'

path_images_original = str_disk + '\micro\images\'
path_images_results  = str_disk + '\micro\results\'


IF N_ELEMENTS(culture) EQ 0 THEN BEGIN
	culture = '21_09_01'
	pathadd_directory    = culture + '\'  ; 13_10_01\ ; 27_09_01
ENDIF ELSE BEGIN
	IF STRPOS(culture, '\') EQ -1 THEN $
		pathadd_directory    = culture +'\' $
	ELSE pathadd_directory   = culture
ENDELSE

;pathadd_session      = 'Prueba_1\'
pathadd_session      = ''

path_results  = path_images_results  + pathadd_directory + pathadd_session
path_original = path_images_original + pathadd_directory

pathw_results = strmid(path_results, 0, STRLEN(path_results)-1)

IF file_test(pathw_results, /directory) EQ 0 THEN BEGIN
	FILE_MKDIR, path_results
ENDIF


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
;------------------------------------------------------------------------------

; ahora el bath de segmentación con todas las imágenes

IF n_images EQ 1 AND str_fileimages[0] EQ '' THEN BEGIN
	PRINT, ' Ninguna imagen en el subdirectorio'
	RETURN, -1
ENDIF

;--------------------------------------------------------------------

FOR i=0L, n_images-1 DO BEGIN

	pathc_image_o  = str_fileimages[i]
	;patgc_image_s1 = path_results +

	pos_file     = STRPOS(pathc_image_o, '\', /REVERSE_SEARCH)
	file_image_o = STRMID(pathc_image_o, pos_file+1)
	str_aux      = STRSPLIT(file_image_o, '.', /EXTRACT)

	file_image_s1 = str_aux[0] + '_mask1.' + str_aux[1]
	file_image_s2 = str_aux[0] + '_sal2.' + str_aux[1]

	pathc_image_s1 = path_results + file_image_s1

	;--------------------------------------------------------------

	image_o = READ_TIFF(pathc_image_o, ORDER=order)

	PRINT, 'Procesando la imagen ', STRTRIM(i,2), ' de ', STRTRIM(n_images, 2)
	PRINT, 'Imagen:  ', pathc_image_o
	PRINT, ''
	;***********************************************
	;***********************************************
	; Segmentacion
	image_s = Baciles_detect(image_o, THRESHOLD=30, FILTER=5, RADIUS=6)
	image_s = marcaminimos_c(image_s)			; Marcado
	image_s = immarked_elim(image_s, 60, /EQUAL, /LIMIT255, /BORDER)
										; Elimina lo marcado menor de 10
										; Y limita a 255 marcas
	;***********************************************
	;***********************************************

	WRITE_TIFF, pathc_image_s1, image_s, order
	;-------------------------------------------------------------


ENDFOR

RETURN, 1

END










