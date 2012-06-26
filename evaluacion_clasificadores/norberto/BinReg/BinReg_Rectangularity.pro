
FUNCTION binreg_Rectangularity, image_o

; Calcula el valor de rectangularidad de una forma binaria
; Tal como se define en [Parker93], como el cociente entre el area del objeto y el
; area del minimo rectangulo que la circunscribe (MER).
; Aquí se emplea el MER mínimo orientado según los ejes principales.
;
;
;
;--------------------------------------------------------------------------------------

rect_length = binreg_mer(image_o, /AXIS_LENGTH, /FLOATING)

length_1 = rect_length[0]
length_2 = rect_length[1]

Mer_area = (length_1+1)*(length_2+1)

area  = TOTAL(image_o)

Rr = FLOAT(area)/Mer_area

IF Rr GT 1.0 THEN BEGIN
	PRINT, 'Breakpoint'
ENDIF

;------------------------------------------------------------

RETURN, Rr


END

;------------------------------------------------------------