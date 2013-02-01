
;@prueba_baciles_detect



path_images_pos1 =     'e:\micro\images\'
path_images_pos2 =     'e:\micro\images\'


str_study_1    = '21_09_01\'
str_study_2    = '127820\'

str_image_1    = 'image1.tif'
str_image_1m   = 'image1mar.tif'

str_image_2    = 'image6.tif'

path_1 = path_images_pos1 + str_study_1 + str_image_1
path_2 = path_images_pos2 + str_study_2 + str_image_2


im_o   = READ_TIFF(path_2,  ORDER=order)
;im_m   = READ_TIFF(path_images_pos1 + str_study_1 + str_image_1m,  ORDER=order)
;im_o   = READ_TIFF(path_images_pos2 + str_study_2 + str_image_2, ORDER=order)

;im_o = im_o[*, 100:400,100:400]

IF order EQ 1 THEN 	!ORDER=1
IF order EQ 0 THEN 	!ORDER=0

;***********************************************
im_s1 = baciles_detect(im_o, IDL=0, THRESHOLD=30, RADIUS=6, FILTER=5)		; Segmentacion
im_s2 = marcaminimos_c(im_s1)				; Marcado
im_s3 = immarked_elim(im_s2, 60, /EQUAL, /BORDERS, /LIMIT255)	; Elimina lo marcado menor de 10
;***********************************************

;ok = view_bacile_memory(im_o, im_s3, 23)