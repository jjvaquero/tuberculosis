
; Clasificador Fuzzy Knn

; mat_training - Matriz de las muestras de entrenamiento. Formato Float
;			   - Cada fila es un par�metro. Tama�o n_params*n_samples
;
; mat_data     - Matriz de las muestras a clasificar. Tama�o n_params*n_data
;
; arr_classes  - Etiquetas de los datos de entrenamiento (n�mero de clase)
;              - Valor entero, tama�o 1*n_samples
;			   - Las etiquetas son = 0,1, UNICAMENTE para dos clases
;
; N       - n�mero de clases
; K       - N�mero de vecinas computadas en el algoritmo knn
; WEIGHTS - array de pesos de par�metros, tama�o n_params
;
; THRESHOLD - El umbral de decisi�n final de pertenencia: de 0 a 1
; M_MULT    - La ponderaci�n de la distancia en la modificaci�n del knn "crisp"
;
; En este fuzzy knn se pondera la pertennecia a cada clase en funci�n inversa
; de la distancia eucl�dea a las muestras
;
;Autor: Juan Enrique Ortu�o Fisac, 2002
;--------------------------------------------------------------------


FUNCTION classify_FuzzyKnn, mat_training, mat_data, arr_classes, K=k, N=n, WEIGTHS=weights, $
							THRESHOLD = threshold, M_MULT=m_mult


IF N_ELEMENTS(threshold) EQ 0 THEN threshold =0.5
IF N_ELEMENTS(m_mult) EQ 0 THEN m_mult = 2

opt_euclidean = 1	; Se trabahjar� solamente con distancia eucl�dea


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

arr_sal_class = FLTARR(1, n_samples)

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
	;-----------------------------------------------------
	; Devuelve el array de clases de las k m�s cercanas
	pos_sortdis = SORT(arr_dist)
	pos_sortk   = pos_sortdis[0:k-1]
	arr_classk  = arr_classes[pos_sortk]
	;histo_class = HISTOGRAM(arr_classk, MIN=0, MAX=n-1)
	;class_max = MAX(histo_class)
	;arr_sal_class[0,i] = (WHERE(histo_class EQ class_max))[0]

	class_1 = WHERE(arr_classk EQ 0, ct1)
	class_2 = WHERE(arr_classk EQ 1, ct2)

	IF ct1 GT 0 THEN BEGIN
		arr_dist_c1 = arr_dist[pos_sortk[class_1]]
		value_1 = TOTAL(1/arr_dist_c1)
	ENDIF ELSE BEGIN
		arr_dist_c1 = [0]
		value_1 = 0
	ENDELSE
	IF ct2 GT 0 THEN BEGIN
		arr_dist_c2 = arr_dist[pos_sortk[class_2]]
		value_2 = TOTAL(1/arr_dist_c2)
	ENDIF ELSE BEGIN
		arr_dist_c2 = [0]
		value_2 = 0
	ENDELSE

	arr_sal_class[0,i] = value_2/(value_1 + value_2)

ENDFOR

RETURN, FIX(arr_sal_class GT threshold)

END