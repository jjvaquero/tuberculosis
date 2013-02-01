

;@Carga_imag_baciles

path_images_original = 'e:\micro\images_positive\'
path_images_results  = 'e:\micro\results\images_positive\'

culture = '21_09_01\'
image   = 'image1'


path_imag_orig   = path_images_original + culture + image + '.tif'

path_imag_marked1 = path_images_original + culture + image + 'mar.tif'

path_imag_marked2 = path_images_original + culture + image + '_marked.tif'

path_imag_mask   = path_images_results + culture + 'prueba_1\' +image +'_mask1.tif'


im_orig = READ_TIFF(path_imag_orig, ORDER=order1)
im_mask = READ_TIFF(path_imag_mask, ORDER=order2)
im_marked1 = READ_TIFF(path_imag_marked1, ORDER=order3)
im_marked2 = READ_TIFF(path_imag_marked2, ORDER=order4)

tam = SIZE(im_mask)
xsize = tam[1]
ysize = tam[2]

;arr = WHERE(im_mask EQ 23)
;im  = binreg_isolate(arr, XSIZE=xsize, YSIZE=ysize, /IMAGE)
;imc = binreg_colorisolate(arr, im_orig, XSIZE=xsize, YSIZE=ysize)



