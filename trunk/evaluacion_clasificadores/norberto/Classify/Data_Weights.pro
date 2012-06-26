

;--------------------------------------------------------------------
;
; Esta función toma como entrada una matriz de parámetros (formato habitual)
; Y retorma un array de pesos para esos parámetros
; Resultado dependiente de la opción elegida
;
; Transformaciones para clustering t ordenación paramétrica
;
;--------------------------------------------------------------------

FUNCTION data_weights, mat_data, OPTION=option

tam = SIZE(mat_data)

n_samples  = tam[2]
n_param    = tam[1]

arr_vars    = FLTARR(n_param)
arr_weights = FLTARR(n_param)

IF KEYWORD_SET(option) THEN opt = option ELSE opt = 1


;--------------------------------------------------------
IF opt EQ 1 THEN BEGIN

	FOR i=0L, n_param-1 DO BEGIN
		arr_vars[i] = varianza(mat_data[i,*])
	ENDFOR

	totvar1 = TOTAL(1/arr_vars)

	FOR i=0L, n_param-1 DO BEGIN
		arr_weights[i] = 1/(arr_vars[i]*totvar1)
	ENDFOR

ENDIF
;--------------------------------------------------------
;--------------------------------------------------------
IF opt EQ 2 THEN BEGIN

	totvar2 = DOUBLE(1)

	FOR i=0L, n_param-1 DO BEGIN
		arr_vars[i] = varianza(mat_data[i,*])
		totvar2 = totvar2*arr_vars[i]
	ENDFOR

	torvar2 = torvar2^(1d/n_param)

	FOR i=0L, n_param-1 DO BEGIN
		arr_weights[i] = (1/arr_vars[i])*totvar2
	ENDFOR

ENDIF
;--------------------------------------------------------



RETURN, arr_weights

END