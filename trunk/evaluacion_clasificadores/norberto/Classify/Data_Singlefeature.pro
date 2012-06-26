

;--------------------------------------------------------------------
;
; Esta función toma como entrada una característica y un arra de clases (dos clases, 1 y 2)
; Y retorma el parámetro de diferencia de medias entre suma de varianzas
; Cuanto mayor sea el valor ,más separados estarán los clusters (más discriminación)
;
;
;ok = data_lambdawilks(mat_data, arr_classes, /FISHER)

FUNCTION data_SingleFeature, arr_data, arr_classes

;--------------------------------------------------------------------

n_samples  = N_ELEMENTS(arr_data)


IF N_ELEMENTS(arr_classes) NE n_samples THEN BEGIN
	PRINT, 'Datos erróneos de entrada'
	RETURN, -1
ENDIF

pos_class_1 = WHERE(arr_classes EQ 0, ct1)
pos_class_2 = WHERE(arr_classes EQ 1, ct2)

IF (ct1 EQ 0) OR (ct2 EQ 0) THEN BEGIN
	PRINT, 'Datos erróneos de entrada'
	RETURN, -1
ENDIF

arr_class_1 = arr_data[pos_class_1]
arr_class_2 = arr_data[pos_class_2]


;-------------------------------------------------
var_1 = varianza(arr_class_1)
var_2 = varianza(arr_class_2)

mean_1 = MEAN(arr_class_1)
mean_2 = MEAN(arr_class_2)

result = ABS(mean_1 - mean_2)/ABS(var_1 + var_2)

RETURN, result

END