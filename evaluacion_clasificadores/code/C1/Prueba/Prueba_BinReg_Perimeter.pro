
;@prueba_binReg_perimeter

; Prueba las medidas de perímetro en la imagen
;

path_images_original = 'f:\juanen\images\prueba\'

file_image_o   = 'perimeter_1.bmp'



im_orig = READ_BMP(path_images_original + file_image_o)

;!ORDER = order

tam = SIZE(im_orig)
xsize = tam[1]
ysize = tam[2]

;viewt, im_orig

arr_1 = WHERE(im_orig EQ 250)
arr_2 = WHERE(im_orig EQ 100)
arr_3 = WHERE(im_orig EQ 148)
arr_4 = WHERE(im_orig EQ 150)
arr_5 = WHERE(im_orig EQ 200)
arr_6 = WHERE(im_orig EQ  50)

reg_1 = binreg_isolate(arr_1, XSIZE=xsize, YSIZE=ysize, /IMAGE) NE 0
reg_2 = binreg_isolate(arr_2, XSIZE=xsize, YSIZE=ysize, /IMAGE) NE 0
reg_3 = binreg_isolate(arr_3, XSIZE=xsize, YSIZE=ysize, /IMAGE) NE 0
reg_4 = binreg_isolate(arr_4, XSIZE=xsize, YSIZE=ysize, /IMAGE) NE 0
reg_5 = binreg_isolate(arr_5, XSIZE=xsize, YSIZE=ysize, /IMAGE) NE 0
reg_6 = binreg_isolate(arr_6, XSIZE=xsize, YSIZE=ysize, /IMAGE) NE 0


arr_perimeter=FLTARR(6)

arr_perimeter[0] = binreg_perimeter(reg_1, OPTION=2)
arr_perimeter[1] = binreg_perimeter(reg_2, OPTION=2)
arr_perimeter[2] = binreg_perimeter(reg_3, OPTION=2)
arr_perimeter[3] = binreg_perimeter(reg_4, OPTION=2)
arr_perimeter[4] = binreg_perimeter(reg_5, OPTION=2)
arr_perimeter[5] = binreg_perimeter(reg_6, OPTION=2)

PRINT, arr_perimeter




