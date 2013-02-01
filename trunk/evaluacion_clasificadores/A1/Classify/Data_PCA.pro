

;--------------------------------------------------------------------
;
; Esta función transforma la matriz de datos (formato habitual) según una
; matriz de covarianza utilizando el método de componentes principales
; Elige los "n_dim" componentes principales
;--------------------------------------------------------------------


FUNCTION data_PCA, mat_data, mat_covar, N_DIM=n_dim

;--------------------------------------------------------------------


tam = SIZE(mat_data)

n_samples  = tam[2]
n_param    = tam[1]

tam2 = SIZE(mat_covar)

IF n_param LE 1 THEN RETURN, -1

IF tam2[2] NE n_param THEN RETURN, -1
IF tam2[1] NE n_param THEN RETURN, -1

IF N_ELEMENTS(n_dim) EQ 0 THEN n_dim = n_param

IF n_dim GT n_param THEN RETURN, -1

arr_eigenvalues = HQR(ELMHES(mat_covar), /DOUBLE)
mat_eigenvectors = EIGENVEC(mat_covar,arr_eigenvalues, /DOUBLE)

arr_eigenvalues  = FLOAT(arr_eigenvalues)
mat_eigenvectors = FLOAT(mat_eigenvectors)

;---------------------------------------------------------------------;

arr_means = DBLARR(n_param)

FOR i=0L, n_param-1 DO BEGIN
	arr_means[i] = MEAN(mat_data[i,*], /DOUBLE)
	mat_data[i,*] = mat_data[i,*]-arr_means[i]
ENDFOR

;---------------------------------------------------------------------

arr_sort = REVERSE(SORT(arr_eigenvalues))

mat_transpose = TRANSPOSE(mat_eigenvectors)

mat_bigger = mat_transpose(*,arr_sort[0:n_dim-1])

;---------------------------------------------------------------------

mat_result = FLTARR(n_dim, n_samples)

FOR i=0L, n_samples - 1 DO BEGIN
	mat_result[*,i] = mat_bigger##REFORM(mat_data[*,i], 1, n_param)
ENDFOR

RETURN, mat_result

END