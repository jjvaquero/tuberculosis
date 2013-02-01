
FUNCTION binreg_FourierDescriptors, image_o, number

; Obtiene N descriptores de Fourier de una forma (shape) binaria
; Retorna un array con 2*N descriptores de fourier
;
; Ojito con el recorrido de píxeles de la forma
;
;--------------------------------------------------------------------------------------

IF N_PARAMS() NE 2 THEN number = 8 ; Por defecto, los descriptores son 8

;--------------------------------------------------------------------------------------

tam = SIZE(image_o)
xsize = tam[1]
ysize = tam[2]
xysize = LONG(xsize)*ysize

imag_perim    = binreg_frontier(image_o)

arr_pos = binreg_orderperimeter(image_o)

arr_fdest = FLTARR(2*number)

n_pixels = (SIZE(arr_pos))[2]

;------------------------------------------------------------

segm = FLOAT(n_pixels)/number
arr_segm = FLOAT(INDGEN(number))

;arr_dist = FIX(ROUND(arr_segm*segm))
arr_dist = FIX(arr_segm*segm)
IF arr_dist[number-1] GE n_pixels THEN arr_dist[number-1] = n_pixels-1
;------------------------------------------------------------

arr_x = arr_pos[0,arr_dist]
arr_y = arr_pos[1,arr_dist]
arr_complex = COMPLEX(arr_x, arr_y)

arr_fft = FFT(arr_complex)

arr_fft_x = REFORM(FLOAT(arr_fft), 1, number)
arr_fft_y = REFORM(IMAGINARY(arr_fft), 1, number)

arr_sal = [arr_fft_x, arr_fft_y]


;------------------------------------------------------------

RETURN, arr_sal

END

;------------------------------------------------------------