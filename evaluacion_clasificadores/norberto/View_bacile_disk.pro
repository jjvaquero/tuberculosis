
FUNCTION view_bacile_disk, n_imag, n_reg, CULTURE=culture, MARKED=marked, $
	RET=ret

;---------------------------------------------------------------------------------------
; Funci�n dise�ada para visualizar en pantalla un bacilo segmentado y guardado en disco
; Necesita saber el identificador de cultura, el n�mero de imagen y el identificador de
; bacilo
;
; im1 = view_bacile_disk(3,23, CULTURE='21_09_01', /MARKED, /RET)
; im2 = baciles_detect_p1(im1)
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

path_results  = path_images_results  + pathadd_directory + pathadd_session
path_original = path_images_original + pathadd_directory


IF KEYWORD_SET(marked) THEN BEGIN
	file_imag_orig = 'image'+STRTRIM(STRING(n_imag),2)+'mar.tif'
ENDIF ELSE BEGIN
	file_imag_orig = 'image'+STRTRIM(STRING(n_imag),2)+'.tif'
ENDELSE
file_imag_mask = 	 'image'+STRTRIM(STRING(n_imag),2)+'_mask1.tif'

im_orig = READ_TIFF(path_original + file_imag_orig, ORDER=order1)
im_mask = READ_TIFF(path_results  + file_imag_mask, ORDER=order2)

PRINT, order1
PRINT, order2

;-----------------------------------------------------------------------------
tam = SIZE(im_mask)
xsize = tam[1]
ysize = tam[2]
;-----------------------------------------------------------------------------
pos_pixels = WHERE(im_mask EQ n_reg)
pos_pix    = pos_pixels[0]

pos_pix_xy = INTARR(2)
pos_pix_xy[0] = pos_pix MOD xsize
pos_pix_xy[1] = pos_pix / xsize

box_xmax = pos_pix_xy[0]+128 < (xsize-1)
box_xmin = pos_pix_xy[0]-128 > 0
box_ymax = pos_pix_xy[1]+128 < (ysize-1)
box_ymin = pos_pix_xy[1]-128 > 0

im_mask_frag = im_mask[box_xmin:box_xmax, box_ymin:box_ymax] EQ n_reg
im_orig_frag = im_orig[*, box_xmin:box_xmax, box_ymin:box_ymax]

im_frontier = binreg_frontier(im_mask_frag)

;im_superposition1 = superpone_mask(im_orig_frag, im_mask_frag, COLOR1=[0,0,255], LEVEL=0.5)
im_superposition2 = superpone_mask(im_orig_frag, im_frontier,  COLOR1=[0,0,255], LEVEL=1)

WINDOW,0, XSIZE = 257S*3, YSIZE = 257

TVSCL, im_orig_frag, 0, TRUE=1, ORDER=order1
TVSCL, im_mask_frag, 1, ORDER=order2
TVSCL, im_superposition2, 2, TRUE=3, ORDER=order1
;TVSCL, im_superposition1, 3, TRUE=3, ORDER=order1

PRINT, 'N�mero de p�xeles: ' , N_ELEMENTS(WHERE(im_mask_frag EQ 1))

IF KEYWORD_SET(ret) EQ 1 THEN BEGIN
	RETURN, im_mask_frag
ENDIF ELSE BEGIN
	RETURN, 1
ENDELSE

END