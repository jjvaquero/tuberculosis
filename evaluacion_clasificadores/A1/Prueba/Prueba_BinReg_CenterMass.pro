
;@prueba_binReg_centermass

; Prueba las medidas del centro de masas de la imagen
;

path_images_original = 'e:\juanen\images\prueba\'

file_image_o   = 'perimeter_2.bmp'

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

reg_1 = binreg_isolate(arr_1, XSIZE=xsize, YSIZE=ysize, /IMAGE)
reg_2 = binreg_isolate(arr_2, XSIZE=xsize, YSIZE=ysize, /IMAGE)
reg_3 = binreg_isolate(arr_3, XSIZE=xsize, YSIZE=ysize, /IMAGE)
reg_4 = binreg_isolate(arr_4, XSIZE=xsize, YSIZE=ysize, /IMAGE)
reg_5 = binreg_isolate(arr_5, XSIZE=xsize, YSIZE=ysize, /IMAGE)
reg_6 = binreg_isolate(arr_6, XSIZE=xsize, YSIZE=ysize, /IMAGE)


arr_perimeter=FLTARR(6)
;----------------------------------------------------------------------

arr_perimeter[0] = binreg_perimeter(reg_1, OPTION=2)
arr_perimeter[1] = binreg_perimeter(reg_2, OPTION=2)
arr_perimeter[2] = binreg_perimeter(reg_3, OPTION=2)
arr_perimeter[3] = binreg_perimeter(reg_4, OPTION=2)
arr_perimeter[4] = binreg_perimeter(reg_5, OPTION=2)
arr_perimeter[5] = binreg_perimeter(reg_6, OPTION=2)

;PRINT, arr_perimeter

;----------------------------------------------------------------------

arr_centermass = INTARR(2,6)

arr_centermass[*,0] = binreg_centermass(reg_1)
arr_centermass[*,1] = binreg_centermass(reg_2)
arr_centermass[*,2] = binreg_centermass(reg_3)
arr_centermass[*,3] = binreg_centermass(reg_4)
arr_centermass[*,4] = binreg_centermass(reg_5)
arr_centermass[*,5] = binreg_centermass(reg_6)


;PRINT, arr_centermass

;----------------------------------------------------------------------

arr_origin = INTARR(2,6)

arr_origin[*,0] = binreg_origin(arr_1, XSIZE=xsize, YSIZE=ysize)
arr_origin[*,1] = binreg_origin(arr_2, XSIZE=xsize, YSIZE=ysize)
arr_origin[*,2] = binreg_origin(arr_3, XSIZE=xsize, YSIZE=ysize)
arr_origin[*,3] = binreg_origin(arr_4, XSIZE=xsize, YSIZE=ysize)
arr_origin[*,4] = binreg_origin(arr_5, XSIZE=xsize, YSIZE=ysize)
arr_origin[*,5] = binreg_origin(arr_6, XSIZE=xsize, YSIZE=ysize)

;PRINT, arr_origin
;----------------------------------------------------------------------

arr_abscenter = LONG(arr_centermass + arr_origin)
arr_abscenterxy = LONARR(1,6)
arr_abscenterxy[*] = arr_abscenter[0,*] + arr_abscenter[1,*]*xsize

im_sal = im_orig

arr_originxy =  LONG(arr_origin[0,*]) + arr_origin[1,*]*xsize

im_sal[arr_abscenterxy] = 255
im_sal[arr_originxy] = 255

;view, im_sal

;----------------------------------------------------------------------

arr_moments  = FLTARR(6)
arr_thinness = FLTARR(6)

arr_moments[5]  = binreg_moments(reg_5, NI=0, NJ=0)
; PRINT, longest_dimension(reg_5)

arr_thinness[0] = binreg_thinness(reg_1)
arr_thinness[1] = binreg_thinness(reg_2)
arr_thinness[2] = binreg_thinness(reg_3)
arr_thinness[3] = binreg_thinness(reg_4)
arr_thinness[4] = binreg_thinness(reg_5)
arr_thinness[5] = binreg_thinness(reg_6)
;----------------------------------------------------------------------


;reg = reg_5
reg = INTARR(22,22)+1

paxis = binreg_principalaxis(reg)

reg[paxis[0],paxis[1]] = 3
reg[paxis[2],paxis[3]] = 3
reg[paxis[4],paxis[5]] = 2

pminmax = BinReg_minmaxdist(reg, [paxis[2],paxis[3]], [paxis[0],paxis[1]])

reg[pminmax[0], pminmax[1]]=4
reg[pminmax[2], pminmax[3]]=4

PRINT, ''

laxis = Binreg_mer(reg, /AXIS_LENGTH)

;viewg, reg

PRINT, laxis

;----------------------------------------------------------------------

;ok = view_orderperimeter(reg_1, /BIG)



