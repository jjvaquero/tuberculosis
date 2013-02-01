
FUNCTION Image_framing2d, imag2d, thick, valor

;; Enmarca una imagen de dos dimensiones por una capa de espesor de espesor variable (key thick)
;; indicado pr la key Valor
;;

tam = SIZE(imag2d)

CASE (SIZE(imag2d))[0] OF; Las dimensiones de la imagen original

    0: BEGIN    ; Un punto
        xsize = 1
        ysize = 1
    END

    1: BEGIN    ; Una fila
        xsize = (SIZE(imag2d))[1]
        ysize = 1
    END

    2: BEGIN    ; Una Matriz
         xsize = (SIZE(imag2d))[1]
         ysize = (SIZE(imag2d))[2]
    END

ENDCASE

IF N_ELEMENTS(valor) NE 1 THEN value = 0 ELSE value = valor

thick2 = thick*2

im  = INTARR(xsize+thick2,ysize+thick2)+value

im[thick:xsize+thick-1,thick:ysize+thick-1] = imag2d


RETURN, im

END ; Enmarca2d