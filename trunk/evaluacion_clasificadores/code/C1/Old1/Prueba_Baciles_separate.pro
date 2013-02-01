
;@prueba_baciles_separate



path_images_pos =     'e:\micro\images_positive\'

path_images_results = 'e:\micro\results_juanen\images_positive\'


str_study_1    = '21_09_01\'

str_image_1    = 'image1.tif'
str_image_1m   = 'image1mar.tif'

str_image_res  = STRMID(str_image_1, 0, STRLEN(str_image_1)-4)


im1   = READ_TIFF(path_images_pos + str_study_1 + str_image_1,  ORDER=order)
im1_m = READ_TIFF(path_images_pos + str_study_1 + str_image_1m, ORDER=order)

im1 = Change_true(im1)

im1_green = im1[*,*,1]		; Canal verde

IF order EQ 1 THEN 	!ORDER=1
IF order EQ 0 THEN 	!ORDER=0


im1 = Change_true(im1)

;im1 = CONGRID(im1,800,600)

;ims_1 = baciles_separate_1(im1_green, 15) ; Original de Norberto
ims_2 = baciles_separate_2(im1_green, 15) ; Con elemento cruz 3x3

;ims3 = detecta_bacilos3(im1) ; Como Norberto, pero con mi reconstrucción con elemento 7x7

;PRINT, N_ELEMENTS(WHERE(ims1 NE ims3))

ims_2mask = ims_2 GT 0

;***********************************************************************************************
WRITE_TIFF, path_images_results + str_study_1 + str_image_res + '_sep1.tif',   ims_2, order
;******************************************************help*************************************

;***********************************************************************************************
WRITE_TIFF, path_images_results + str_study_1 + str_image_res + '_mask1.tif',  ims_2mask, order
;******************************************************help*************************************