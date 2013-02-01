
;@prueba_baciles_compare_1

; Comprueba el resultado de la segmentación de bacilos con las imágenes cargadas en disco
;

path_images_original = 'e:\micro\images\'
path_images_results  = 'e:\micro\results\'

pathadd_directory    = '21_09_01\'
pathadd_session      = 'Prueba_1\'

path_results  = path_images_results  + pathadd_directory + pathadd_session
path_original = path_images_original + pathadd_directory

file_image_o   = 'image1.tif'
file_image_r   = 'image1_mask1.tif'

im_orig = READ_TIFF(path_original + file_image_o)
im_mask = READ_TIFF(path_results  + file_image_r, ORDER=order)

imo_green = im_orig[1,*,*]		; Canal verde

IF order EQ 1 THEN 	!ORDER=1
IF order EQ 0 THEN 	!ORDER=0

;viewt, im_orig


