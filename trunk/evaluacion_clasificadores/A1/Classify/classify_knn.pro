
; Clasificador Knn

; mat_training - Matriz de las muestras de entrenamiento. Formato Float
;			   - Cada fila es un parámetro. Tamaño n_params*n_samples
;
; mat_data     - Matriz de las muestras a clasificar. Tamaño n_params*n_data
;
; arr_classes  - Etiquetas de los datos de entrenamiento (número de clase)
;              - Valor entero, tamaño 1*n_samples
;			   - Las etiquetas son = 0,1, para dos clases, 0,1,2,3 ...
;
; N       - número de clases
; K       - Número de vecinas computadas en el algoritmo knn
; WEIGHTS - array de pesos de parámetros, tamaño n_params
; MAHALANOBIS - Por defecto calcula la distancia euclídea, pero con esta keyword
;               lo hace por mahalanobis
;
;Autor: Juan Enrique Ortu–o Fisac, 2002
;--------------------------------------------------------------------


FUNCTION classify_knn, mat_training, mat_data, arr_classes, K=k, N=n, WEIGTHS=weights, $
						MAHALANOBIS=mahalanobis, EUCLIDEAN=euclidean

IF KEYWORD_SET(mahalanobis) THEN opt_mahalanobis = 1 ELSE  opt_mahalanobis = 0
IF KEYWORD_SET(euclidean)   THEN opt_euclidean   = 1 ELSE  opt_euclidean   = 0

tam1 = SIZE(mat_training)
tam2 = SIZE(mat_data)

n_training = tam1[2]
n_samples  = tam2[2]

IF n_training NE N_ELEMENTS(arr_classes) THEN BEGIN
	PRINT, 'Datos incorrectos'
	RETURN, -1
ENDIF

n_param = tam1[1]

IF tam2[1] NE n_param THEN BEGIN
	PRINT, 'datos incorrectos'
	RETURN, -1
ENDIF
IF n_training NE N_ELEMENTS(arr_classes) THEN BEGIN
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
IF opt_mahalanobis EQ 1 THEN BEGIN	; Calcula la matriz de covarianzas
	samples_c1 = WHERE(arr_classes EQ 0, count_c1)
	samples_c2 = WHERE(arr_classes EQ 1, count_c2)

	IF (count_c1 LT 2) OR (count_c2 LT 2) THEN BEGIN
		PRINT, 'Insuficientes datos de una clase'
		RETURN, -1
	ENDIF

	mat_train_c1 = mat_training[*, samples_c1]
	mat_train_c2 = mat_training[*, samples_c2]

	mat_covars1 = CORRELATE(mat_train_c1, /COVARIANCE, /DOUBLE)*(count_c1-1)/count_c1
	mat_covars2 = CORRELATE(mat_train_c2, /COVARIANCE, /DOUBLE)*(count_c2-1)/count_c2
	mat_inv1 = INVERT(mat_covars1, status1, /DOUBLE)
	mat_inv2 = INVERT(mat_covars2, status2, /DOUBLE)
	IF (status1 EQ 1 OR status2) EQ 1 THEN BEGIN
		PRINT, 'Inversion imposible'
		RETURN, -1
	ENDIF

ENDIF


;------------------------------------------------------------------------
;Algoritmo K-nn

FOR i=0L, n_samples-1 DO BEGIN	; Procesa todas la muestras
	IF (i MOD 200 EQ 0) THEN PRINT, i
	sample = mat_data[*,i]
	;----------------------------------------------------
	IF opt_euclidean EQ 1 THEN BEGIN
		mat_sample = REBIN(sample, n_param, n_training)
		mat_dist   = mat_training - mat_sample
		arr_dist   = FLTARR(1, n_training)
		FOR j=0L, n_training-1 DO BEGIN
			arr_dist[j] = TOTAL(((mat_dist[*,j])^2)*arr_weight)
		ENDFOR
	ENDIF
	IF opt_mahalanobis EQ 1 THEN BEGIN
		arr_dist   = FLTARR(1, n_training)
		FOR j=0L, n_training-1 DO BEGIN
			vect_1 = mat_training[j]-sample
			IF arr_classes[j] EQ 0 THEN $
				arr_dist[j] = vect_1##mat_inv1##REFORM(vect_1, 1, n_param) $
			ELSE $
				arr_dist[j] = vect_1##mat_inv2##REFORM(vect_1, 1, n_param)
		ENDFOR
	ENDIF
	;-----------------------------------------------------
	; Devuelve el array de clases de las k más cercanas
	pos_sortdis = SORT(arr_dist)
	pos_sortk  = pos_sortdis[0:k-1]
	arr_classk = arr_classes[pos_sortk]
	histo_class = HISTOGRAM(arr_classk, MIN=0, MAX=n-1)

	class_max = MAX(histo_class)

	arr_sal_class[0,i] = (WHERE(histo_class EQ class_max))[0]
ENDFOR

RETURN, arr_sal_class

END