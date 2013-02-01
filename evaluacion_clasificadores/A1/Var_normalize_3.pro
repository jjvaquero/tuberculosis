

 FUNCTION var_normalize_3, arr_data

;---------------------------------------------------------------------------------------
; Normaliza un array de datos de entrada entre 0 y 10
;
;
;---------------------------------------------------------------------------------------

n_data = N_ELEMENTS(arr_data)

arr_in   = FLOAT(arr_data)
max_data = MAX(arr_in)
min_data = MIN(arr_in)

IF max_data EQ min_data THEN BEGIN
	arr_out = arr_in*0
	RETURN, arr_out
ENDIF

arr_out = ((arr_in - min_data)/(max_data-min_data))*10.0

RETURN, arr_out


;------------------------------------------------------------





END

