

; Clasificador Bayesiano para dos clases

; mat_training - Matriz de las muestras de entrenamiento. Formato Float
;			   - Cada fila es un parámetro. Tamaño n_params*n_samples
;				 (para obtener la función densidad de probabilidad gaussiana multivarida
;
; mat_data     - Matriz de las muestras a clasificar. Tamaño n_params*n_data
;
; arr_classes  - Etiquetas de los datos de entrenamiento (número de clase)
;              - Valor entero, tamaño 1*n_samples
;			   - Las etiquetas son = 0,1, para dos clases, 0,1,2,3 ...
;
; WEIGHTS - array de pesos de parámetros, tamaño n_params
;
;
;--------------------------------------------------------------------

FUNCTION classify_bayesian, mat_training, mat_data, arr_classes, WEIGTHS=weights

tam = SIZE(mat_data)

n_samples  = tam[2]
n_param    = tam[1]

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

samples_c1 = WHERE(arr_classes EQ 0, count_c1)
samples_c2 = WHERE(arr_classes EQ 1, count_c2)

IF (count_c1 LT 2) OR (count_c2 LT 2) THEN BEGIN
	PRINT, 'Insuficientes datos de una clase'
	RETURN, -1
ENDIF

PRINT, count_c2, count_c1

mat_train_c1 = mat_training[*, samples_c1]
mat_train_c2 = mat_training[*, samples_c2]

;------------------------------------------------------------------------
; Obtienen los parámetros de la función gaussiana
mat_gauss_c1 = Get_GaussianMultivariate(mat_train_c1)
mat_gauss_c2 = Get_GaussianMultivariate(mat_train_c2)
arr_mean_c1 = mat_gauss_c1[*,0]
arr_mean_c2 = mat_gauss_c2[*,0]
mat_covar_c1 = mat_gauss_c1[*,1:n_param]
mat_covar_c2 = mat_gauss_c2[*,1:n_param]
;------------------------------------------------------------------------
;
FOR i=0L, n_samples-1 DO BEGIN	; Procesa todas la muestras
	IF (i MOD 200 EQ 0) THEN PRINT, i
	sample = mat_data[*,i]*arr_weight
	;------------------------
	logprob_c1 = Value_GaussianMultivariate(sample, arr_mean_c1, mat_covar_c1, LOG=1)
	logprob_c2 = Value_GaussianMultivariate(sample, arr_mean_c2, mat_covar_c2, LOG=1)
	;------------------------
	arr_sal_class[i] = logprob_c2 GT logprob_c1

ENDFOR

RETURN, arr_sal_class

END