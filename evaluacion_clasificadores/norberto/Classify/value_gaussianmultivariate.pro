
;Value_GaussianMultivariate.pro

;--------------------------------------------------------------------
;
; Calcula el valor de una función gausiana multidimensional para un vector dado
;
; arr_data  - Vector de datos a evaluar
; arr_mean  - Vector de medias de la función gausiana
; mat_covar - Matriz de covarianzas de la función gausiana
;
; Con opción LOG, calcula el logaritmo de la función (log probabilidad)
;
;--------------------------------------------------------------------

FUNCTION Value_GaussianMultivariate,  arr_data, arr_mean, mat_covar, LOG=log


IF KEYWORD_SET(log) THEN opt_log = 1 ELSE opt_log = 0
n_param = N_ELEMENTS(arr_data)
n_1 = N_ELEMENTS(arr_mean)
tam = SIZE(mat_covar)

IF n_param NE n_1    THEN BEGIN & PRINT, 'Datos incorrectos de entrada' & RETURN, 1 & ENDIF
IF n_param GT 1 THEN BEGIN
	IF n_param NE tam[1] THEN BEGIN & PRINT, 'Datos incorrectos de entrada' & RETURN, 1 & ENDIF
	IF n_param NE tam[2] THEN BEGIN & PRINT, 'Datos incorrectos de entrada' & RETURN, 1 & ENDIF
ENDIF

vect_1  = arr_data-arr_mean
mat_inv = INVERT(mat_covar, status)
IF status EQ 1 THEN BEGIN
	PRINT, 'Inversion imposible'
	RETURN, -1
ENDIF

exponent = vect_1##mat_inv##REFORM(vect_1, 1, n_param)

IF n_param GT 1 THEN BEGIN
	determ_cov = DETERM(mat_covar, /CHECK, /DOUBLE)
ENDIF ELSE BEGIN
	determ_cov = mat_covar
ENDELSE

IF opt_log EQ 1 THEN BEGIN
	;prob_log = -0.5*ALOG(2.0*!PI*SQRT(determ_cov)) -0.5*exponent
	prob_log = -exponent
	RETURN, prob_log
ENDIF ELSE BEGIN
	prob     = (1.0/(SQRT(2.0*!PI*determ_cov)))*EXP(-0.5*exponent)
	;PRINT, prob
	RETURN, prob
ENDELSE


; queda por hacer

RETURN, -1

END