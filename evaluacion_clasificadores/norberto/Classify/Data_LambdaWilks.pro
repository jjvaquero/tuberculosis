

;--------------------------------------------------------------------
;
; Esta función toma como entrada una matriz de características (formato habitual)
; y un array de clases (dos clases, 1 y 2)
; Y retorma el parámetro Lambda de Wilks como indicador de la discriminación de
; las características (entre 0 y 1, cuando más cerca esté de cero, mayor es el poder discriminante)
; o bien el vector discriminante de Fisher, o las matrices Sb o Sw
; ;
;--------------------------------------------------------------------

;mat_data = DOUBLE(RANDOMN(3, 6,14))*10
;arr_classes = INTARR(14)
;arr_classes[6:13]=1
;ok = data_lambdawilks(mat_data, arr_classes, /FISHER)

FUNCTION data_LambdaWilks, mat_data, arr_classes, FISHER=fisher, WILKS=wilks, TRAC=trac

;--------------------------------------------------------------------

IF KEYWORD_SET(fisher) THEN opt_fisher = 1 ELSE opt_fisher = 0
IF KEYWORD_SET(wilks)  THEN opt_wilks  = 1 ELSE opt_wilks  = 0
IF KEYWORD_SET(trac)   THEN opt_trac   = 1 ELSE opt_trac   = 0

tam = SIZE(mat_data)

n_samples  = tam[2]
n_param    = tam[1]

IF n_param LE 1 THEN RETURN, -1

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

mat_class_1 = mat_data[*, pos_class_1]
mat_class_2 = mat_data[*, pos_class_2]


matrix_within_1 = CORRELATE(mat_class_1, /COVARIANCE, /DOUBLE)*(n_param-1)
matrix_within_2 = CORRELATE(mat_class_1, /COVARIANCE, /DOUBLE)*(n_param-1)

;---------------------------------------------------------------------------
;matrix_within_1 = DBLARR(n_param, n_param)
;matrix_within_2 = DBLARR(n_param, n_param)
arr_means_1 = DBLARR(n_param)
arr_means_2 = DBLARR(n_param)
FOR i=0L, n_param-1 DO BEGIN
	arr_means_1[i] = MEAN(mat_class_1[i,*], /DOUBLE)
	arr_means_2[i] = MEAN(mat_class_2[i,*], /DOUBLE)
ENDFOR
;FOR i=0L, n_param-1 DO BEGIN
;	FOR j=0L, n_param-1 DO BEGIN
;		matrix_within_1[i,j] = TOTAL((mat_class_1[i,*]-arr_means_1[i])*(mat_class_1[j,*]-arr_means_1[j]))
;		matrix_within_2[i,j] = TOTAL((mat_class_2[i,*]-arr_means_2[i])*(mat_class_2[j,*]-arr_means_2[j]))
;	ENDFOR
;ENDFOR
;--------------------------------------------------------------------------

matrix_within  = matrix_within_1+matrix_within_2

arr_diffmeans  = arr_means_1-arr_means_2

matrix_between = REFORM(arr_diffmeans, 1, n_param)##arr_diffmeans

IF opt_fisher EQ 1 THEN BEGIN
	arr_fisher = INVERT(matrix_between, /DOUBLE)##REFORM(arr_diffmeans, 1, n_param)
	RETURN, arr_fisher
ENDIF

IF opt_wilks EQ 1 THEN BEGIN
	IF opt_trac EQ 1 THEN BEGIN
		trace_within  = TRACE(matrix_within)
		trace_between = TRACE(matrix_between)

		lambda_wilks = trace_within/(trace_within+trace_between)
	ENDIF ELSE BEGIN

		determ_within  = DETERM(matrix_within,  /DOUBLE, /CHECK)
		determ_between = DETERM(matrix_between, /DOUBLE ,/CHECK)

		lambda_wilks = determ_within/(determ_within+determ_between)
	ENDELSE

	RETURN, lambda_wilks
ENDIF

RETURN, -1

END