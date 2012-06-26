
FUNCTION view_microimage, n_imag, CULTURE=culture, MASK=mask, $
	MARKED=marked, ORIG=orig, RET=ret

;---------------------------------------------------------------------------------------
; Función diseñada para visualizar en pantalla una imagen de microscopia guardada en disco
; Necesita saber el identificador de cultura, y el número de imagen
;
; ok = view_microimage( 3, CULTURE='21_09_01', /MASK, /RET)
;---------------------------------------------------------------------------------------


str_disk = 'e:'

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

IF NOT KEYWORD_SET(mask)   THEN opt_mask   = 0 ELSE opt_mask   = 1
IF NOT KEYWORD_SET(marked) THEN opt_marked = 0 ELSE opt_marked = 1
IF NOT KEYWORD_SET(orig)   THEN opt_orig   = 0 ELSE opt_orig   = 1

path_results  = path_images_results  + pathadd_directory + pathadd_session
path_original = path_images_original + pathadd_directory
path_marked   = path_images_original + pathadd_directory

file_imag_orig   = 'image'+STRTRIM(STRING(n_imag),2)+'.tif'
file_imag_mask   = 'image'+STRTRIM(STRING(n_imag),2)+'_mask1.tif'
file_imag_marked = 'image'+STRTRIM(STRING(n_imag),2)+'mar.tif'

IF opt_mask THEN BEGIN
	im_mask   = READ_TIFF(path_results  + file_imag_mask,  ORDER=order)
	!ORDER=order
	viewg, im_mask NE 0  ,0
	PRINT, 'Maximo valor de la imagen segmentada: ', MAX(im_mask)
ENDIF
IF opt_marked THEN BEGIN
	im_marked = READ_TIFF(path_marked   + file_imag_marked, ORDER=order)
	!ORDER=order
	viewg, im_marked, 1
ENDIF
IF opt_orig   THEN BEGIN
	im_orig   = READ_TIFF(path_marked   + file_imag_orig, ORDER=order)
	!ORDER=order
	viewg, im_orig,   2
ENDIF




IF KEYWORD_SET(ret) EQ 1 THEN BEGIN
	IF opt_mask   EQ 1 THEN $
		RETURN, im_mask
	IF opt_marked EQ 1 THEN $
		RETURN, im_marked
	IF opt_orig EQ 1 THEN   $
		RETURN, im_orig
ENDIF ELSE BEGIN
	RETURN, 1
ENDELSE

END