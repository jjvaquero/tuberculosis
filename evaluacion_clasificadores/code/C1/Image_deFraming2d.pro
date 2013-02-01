
FUNCTION Image_deframing2d, imag2d, thick, valor

;; desemnarca una imagen de dos dimensiones por una capa de espesor de espesor variable (key thick)
;;
;; El marco fue puesto por Image_framing.pro

IF ((SIZE(imag2d))[0] NE 2) OR ((SIZE(imag2d))[1] LT 3)  $
    OR ((SIZE(imag2d))[2] LT 3) THEN BEGIN
    PRINT, 'No es una imagen adecuada'
    RETURN, 0
ENDIF

xsize = (SIZE(imag2d))[1]
ysize = (SIZE(imag2d))[2]

result  = imag2d[thick:xsize-thick-1, thick:ysize-thick-1]

RETURN, result

END; Desenmarca3d.pro