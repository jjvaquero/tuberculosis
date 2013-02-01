
; Clasificador por discriminante lineal entre dos clases


; mat_data     - Matriz de las muestras a clasificar. Tamaño n_params*n_data
;
; arr_discriminant  - Valores de la función lineal discriminante. El primero
;                     es el término independiente seguido de otros n_params términos
;
;
; WEIGHTS - array de pesos de parámetros (multiplicaciones de los valores
;           antes de clasificar) tamaño n_params
;
;
;--------------------------------------------------------------------

FUNCTION classify_Lineardiscriminant ,mat_data, arr_discriminant, WEIGTHS=weights


tam = SIZE(mat_data)

n_samples  = tam[2]
n_param    = tam[1]

IF (n_param + 1) NE N_ELEMENTS(arr_discriminant) THEN BEGIN
	PRINT, 'datos incorrectos'
	RETURN, -1
ENDIF

IF N_ELEMENTS(weights) EQ 0 THEN BEGIN
	arr_weight = FLTARR(n_param) +1.0
ENDIF ELSE BEGIN
	IF N_ELEMENTS(weights) NE n_param THEN BEGIN
		PRINT, 'datos incorrectos'
		RETURN, -1
	ENDIF
	arr_weight = weights
ENDELSE

arr_sal_class = INTARR(1, n_samples)

;------------------------------------------------------------------------
; Discriminante lineal

FOR i=0L, n_samples-1 DO BEGIN	; Procesa todas la muestras
	IF (i MOD 200 EQ 0) THEN PRINT, i
	sample = mat_data[*,i]*arr_weight
	;------------------------
	result = TOTAL(sample*arr_discriminant[1:n_param-1]) + arr_discriminant[0]
	;------------------------
	arr_sal_class[i] = result GE 0

ENDFOR

RETURN, arr_sal_class

END