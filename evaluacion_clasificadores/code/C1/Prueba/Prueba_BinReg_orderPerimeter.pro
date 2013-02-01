
;@Prueba_binreg_orderperimeter

;reg = INTARR(6,6)+1
;reg[35]=0
;reg[33]=0
;reg[27]=0
;reg[29]=0
;reg[1]=0

;reg=[1,1,1,1,0]
;reg = REFORM(reg, 1, 5)

reg = INTARR(20, 10)
reg[[5,6,10,11]+20*1]  =1
reg[[2,5,6,7,9,10,11]+20*2]=1
reg[[2,3,4,5,6,7,8,9,10,11]+20*3]=1
reg[[3,4,5,6,7,9,10,11,12,13]+20*4]=1
reg[[3,5,6,10,11]+20*5]  =1
;---------------------------------

;arr_ord = binreg_orderperimeter(reg)

reg_perim1 = binreg_frontier(reg)

;PRINT, 'Numero de pixeles del perimetro :', TOTAL(reg_perim1)
;PRINT, 'Número de píxeles ordenados     :', N_ELEMENTS(arr_ord[2,*])

;reg_perim2 = reg*0
;reg_perim2[arr_ord[2,*]]=1

;print, REFORM(arr_ord[2,*])

;ok = view_orderperimeter(reg, /BIG)

;arr_fourier = binreg_FourierDescriptors(reg, 8)

;PRINT, arr_fourier





