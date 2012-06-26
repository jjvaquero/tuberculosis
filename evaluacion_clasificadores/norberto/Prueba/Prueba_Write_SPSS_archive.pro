

;@Prueba_Write_SPSS_archive

path_disk = 'e:'

path_imag_orig   = path_disk + '\micro\images_positive\21_09_01\image1.tif'

path_imag_marked = path_disk + '\micro\images_positive\21_09_01\marked\image1marked.tif'

path_imag_mask   = path_disk + '\micro\results\images_positive\21_09_01\image1_mask1.tif'

file  = path_disk + '\micro\results\images_positive\21_09_01\image1_mask1_st2.txt'

image_orig = READ_TIFF(path_imag_orig)
image_mask = READ_TIFF(path_imag_mask)
image_marked = READ_TIFF(path_imag_marked)

image_marked = classify_class(image_mask, image_marked)


ok =Write_SPSS_archive_2(file, image_orig, image_mask,  IM_MARKED=image_marked, CULTURE='21_09_01', N_IMAGE='1', /ADVANCED, /SIMPLE)



