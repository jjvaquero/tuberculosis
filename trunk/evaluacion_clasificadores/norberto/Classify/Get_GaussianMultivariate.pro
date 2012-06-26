
;Get_GaussianMultivariate.pro

; Calcula los paráametros de una función gaussiana multivariada a partir
; de las muestras de entrada
;
; mat_data, matriz de n_samples (filas) por n_params (columnas), es decir
; tantos parámetros por muestra como columnas
;
; La salida es una matriz de dimensiones [n_params*n_params+1]
; donde la primera fila es el vector de medias, y la matriz cuadrada
; restante es la matriz de covarianza
;--------------------------------------------------------------------

FUNCTION Get_GaussianMultivariate , mat_data


tam = SIZE(mat_data)

n_samples  = tam[2]
n_param    = tam[1]

;--------------------------------------------------------------------

arr_means  = FLTARR(n_param, 1)
mat_covars = FLTARR(n_param, n_param)

FOR i=0L, n_param-1 DO BEGIN
	arr_means[i] = MEAN(mat_data[i,*])
ENDFOR

mat_covars = CORRELATE(mat_data, /COVARIANCE)*n_samples/(n_samples+1)

;FOR i=0L, n_param-1 DO BEGIN
;	FOR j=0L, n_param-1 DO BEGIN
;		mat_covars[i,j] = (1.0/n_samples)*TOTAL((mat_data[i,*]-arr_means[i])*(mat_data[j,*]-arr_means[j]))
;	ENDFOR
;ENDFOR

RETURN, [[arr_means], [mat_covars]]

END