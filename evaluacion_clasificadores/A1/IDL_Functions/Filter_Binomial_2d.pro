

FUNCTION filter_Binomial_2d, image_o, DIAMETER=diameter, FLOATING=floating

;; Function filter_Binomial_2d.pro
;;
;; Convoluciona con las máscaras para realizar filtros binomiales 2D
;;
;; Resultado, LONG o FLOAT
;;

IF N_PARAMS() NE 1 THEN BEGIN & PRINT, 'Datos no válidos'    & RETURN, -1 & END


IF NOT KEYWORD_SET(floating) THEN but_float = 0 ELSE but_float = 1
IF N_ELEMENTS(diameter) EQ 0 THEN tam = 3 ELSE tam = diameter

;IF MAX(tam EQ [3,5,7,9]) LT 1 THEN BEGIN & PRINT, 'DIAMETER no válido'  & RETURN, -1 & END
IF (SIZE(image_o))[0] NE 2    THEN BEGIN & PRINT, 'Datos no válidos'    & RETURN, -1 & END

imag_o = LONG(image_o)

;************************************************************************

CASE tam OF

	3 : struct = [1,2,1]
	5 : struct = [1,4,6,4,1]
	7 : struct = [1,6,15,20,15,6,1]
	9 : struct = [1,8,28,56,70,56,28,8,1]
	ELSE : BEGIN
		n = tam-1
		r = INDGEN(n+1)
		struct = FACTORIAL(n)/(FACTORIAL(r)*FACTORIAL(n-r))
	ENDELSE

ENDCASE

;************************************************************************

struct2 = REFORM(struct, 1, tam)
scl     = TOTAL(struct)

imag_convol1 = CONVOL(imag_o,       struct,  scl, /CENTER)
imag_convol2 = CONVOL(imag_convol1, struct2, scl, /CENTER)

IF but_float EQ 1 THEN BEGIN
	RETURN, imag_convol2
ENDIF ELSE BEGIN
	RETURN, LONG(imag_convol2)
ENDELSE

;************************************************************************



END