

 FUNCTION var_normalize_2, arr_data

;---------------------------------------------------------------------------------------
; Normaliza un array de datos de entrada a variables de media 0 y varianza 1
; (x - mean(x))/var(x)
;
;
;---------------------------------------------------------------------------------------

n_data = N_ELEMENTS(arr_data)

arr_in  = FLOAT(arr_data)

media = MEAN(arr_in)
var   = varianza(arr_in)

arr_out = (arr_in - media)/var

RETURN, arr_out


;------------------------------------------------------------





END


