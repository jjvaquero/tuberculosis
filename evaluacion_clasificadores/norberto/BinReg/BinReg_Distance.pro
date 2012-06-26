
FUNCTION binreg_Distance, image_o

; Calcula la imagen de distancia morfológica (MORPH_DISTANCE) con
; distancia euclídea a los valores de cero, pero sin efecto de bordes
; (a menos que no haya ninguún cero)
;
; Si toda la imagen está a uno, creo un cero en [0,0]
;
; Aquí la entrada es una imagen binaria (habrá que separar)
;
;
;------------------------------------------------------------


tam = SIZE(image_o)

CASE (SIZE(image_o))[0] OF; Las dimensiones de la imagen original

    0: BEGIN    ; Un punto
        xsize = FIX(1)
        ysize = FIX(1)
    END

    1: BEGIN    ; Una fila
        xsize = (SIZE(image_o))[1]
        ysize = FIX(1)
    END

    2: BEGIN    ; Una Matriz
         xsize = (SIZE(image_o))[1]
         ysize = (SIZE(image_o))[2]
    END

ENDCASE

imag = image_o

IF MIN(imag) GT 0 THEN imag[0]=0

;--------------------------------------------
maxi = MAX([xsize, ysize])

;--------------------------------------------
xsize2 = (xsize*3)
ysize2 = (ysize*3)
maxi3  = (maxi*3)

xbegin = maxi
xend   = xbegin + xsize - 1

ybegin = maxi ;ysize
yend   = ybegin + ysize - 1

im  = INTARR(maxi3+2, maxi3+2)+1

im[xbegin+1 : xend+1, ybegin+1:yend+1] = imag
;--------------------------------------------


imag_dist = MORPH_DISTANCE(im, NEIGHBOR_SAMPLING=3)

imag_d = imag_dist[xbegin+1 : xend+1, ybegin+1:yend+1]

;--------------------------------------------

RETURN, imag_d

END