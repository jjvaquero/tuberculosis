

PRO fbat_classify_allmethods_loo

;fbat_classify_allmethods_loo

;------------------------------------------------------------------------------
;
; Función general de clasificación estadística para datos de entrada de parámetros
; leidos de archivos de texto en el formato creado por "write_SPSS_archive_2.pro"
; Y similares
;
; Lee archivos y en función de las keywords internas calcula varias clasificaciones:
;  - Bayesiana clásica
;  - Knn
;  - Discriminante lineal (previamente calculado con SPSS)
;
;  - También elige los parámetros que se van a utilizar
;
;  - Realiza un LEFT-ONE-OUT rotando el 25% de los datos
;
;------------------------------------------------------------------------------
;-------------------------------------------------------
; Las características que se corresponden a lass columnas,
;en archivos tipo iSAM :
;
; momentos = 29:39
; todos = 4:39
;
; 0 = 'culture'  - Identificador STRING de cultivo
; 1 = 'n_image'  - Número de imagen
; 2 = 'index'    - Número de región (bacilo o negativo)
; 3 = 'class'    - Identificador de clase (0: negativo, no marcado, 1:positivo, marcado)
; 4 = 'size'     - Tamaño (área)
; 5 = 'perim'    - Perímetro
; 6 = 'mean_r'   - Media del canal rojo
; 7 = 'mean_g'   - Media del canal verde
; 8 = 'mean_b'   - Media del canal azul
; 9 = 'stdv_r'   - Desviación estándar del canal rojo
;10 = 'stdv_g'   - Desviación estándar del canal verde
;11 = 'stdv_b'   - Desviación estándar del canal azul
;12 = 'origin_x' - Posición del bacilo en x
;13 = 'origin_y' - Posición del bacilo en y
;14 = 'cmass_x'  - Centro de masas de la máscara binaria, relativo en x
;15 = 'cmass_y'  - Centro de masas de la máscara binaria, relativo en y
;16 = 'gcmass_x' - Centro de masas del canal verde, relativo en x
;17 = 'gcmass_y' - Centro de masas del canal verde, relativo en y
;18 = 'longdim'  - Diatancia máxima entre píxeles de la región
;19 = 'thinness' - Delgadez, mediante autovalores de la matriz de momentos (+delgado, -thinness)
;20 = 'angle'    - Angulo, mediante matriz de momentos
;21 = 'ffactor'  - Factor de forma:  (4.0*!PI*area)/(perimeter^2)
;22 = 'feretd'   - Diámetro de Feret: SQRT((4.0*area)/!PI)
;23 = 'compact'  - Compactación:  diámetro de feret/distancia máxima en la forma
;24 = 'maxr'     - Distancia máxima de un punto al centro de masas
;25 = 'minr'     - Distancia mínima de un punto al centro de masas
;26 = 'maxdist'  - Distancia máxima de un píxel al fondo
;27 = 'rectness' - Rectangularidad (relación entre el área y la de el rectángulo menor circunscrito)
;28 = 'm11'      - Momentos (i,j) (en imagen de gris del canal verde)
;29 = 'm20'
;30 = 'm02'
;31 = 'm21'
;32 = 'm12'
;33 = 'm30'
;34 = 'm03'
;35 = 'm22'
;36 = 'm31'
;37 = 'm13'
;38 = 'm40'
;39 = 'm04'
;-------------------------------------------------------

;------------------

opt_bayes  = 0
opt_knn    = 1
opt_linear = 0
opt_fknn   = 0

opt_equal_n = 0

val_fknn = 0.75

n_knn = 9

opt_detecterrors = 0
opt_normalize    = 1

opt_mahalanobis = 0
opt_euclidean   = 1

opt_weights = 1

opt_invariant = 0

opt_mostdiscriminants = 1
opt_pca = 1
n_good = 20	; Los 20 más discriminantes
 n_pca  = 8 ; Análisis de componentes principales de 20

loo_buc = 4 ; 25% de test y cuatro repeticiones en el LOO

;------------------

sensibilidad  = FLTARR(loo_buc)
especificidad = FLTARR(loo_buc)

str_disk1 = 'e:\'
str_path1 = 'micro\results\files_tab_training\'
str_file1 = 'Tabfile_training_iSAM_class01.txt'       ; Entrenamiento
;str_file1 = 'Tabfile_training_iSAM_class01_norm.txt'  ; Entrenamiento

str_disk2 = 'e:\'
str_path2 = 'micro\results\files_tab_test\'
str_file2 = 'Tabfile_test_iSAM_class01.txt'		    ; Test
;str_file2 = 'Tabfile_test_iSAM_class01_norm.txt'   ; Entrenamiento

path_file1 = str_disk1 + str_path1 + str_file1
path_file2 = str_disk2 + str_path2 + str_file2


; El conjunto de entrenamiento y el de test se pueden intercambiar,
; menos en Discriminante lineal

;--------------------------------------------------------
str_names1   = read_spss_archive(path_file1, /NAMES)
strmat_file1 = read_spss_archive(path_file1)

;str_names2   = read_spss_archive(path_file2, /NAMES)
strmat_file2 = read_spss_archive(path_file2)

;str_names3   = read_spss_archive(path_file3, /NAMES)
;strmat_file3 = read_spss_archive(path_file3)
;--------------------------------------------------------

tam1 = SIZE(strmat_file1)
tam2 = SIZE(strmat_file2)
n_samples1 = tam1[2] - 1
n_samples2 = tam2[2] - 1
strmat_file1 = strmat_file1[*,1:n_samples1]  ; Elimina los nombres
strmat_file2 = strmat_file2[*,1:n_samples2]  ; Elimina los nombres

;-------------------------------------------------------

IF opt_linear EQ 1 THEN BEGIN
	params_valid = [8,9,10,22,23,26,27,39]
	;arr_discriminant =[0.0, 0.115, 0.352, 0.416, 0.458, -0.799, -0.209, 0.490, -0.264]
	arr_discriminant = [-4.618, 0.005, 0.030, 0.045, 0.367, -7.752, -0.297, 9.079, 0.000]
	opt_pca     = 0
	opt_weights = 0
	opt_mostdiscriminants = 0
	opt_invariant = 0
	opt_normalize = 0
ENDIF ELSE BEGIN
	params_valid = [4,5,6,7,8,9,10,11,14,15,16,17,18,19,21,22, $
		23,24,25,26,27,28,29,30,31,32,33,34,35,36,37,38,39]		;33 caracteristicas
	;params_valid = [4,6,7,8,28,29,30,31,32,33,34,35,36,37,38]
	;params_valid = [8,9,10,22,23,26,27,39] ; los de SPSS
	;mean_b stdv_r, stdv_g, feretd, compact, maxdist, rectness, m04]
ENDELSE


arr_classes1 = FIX(strmat_file1[3,*])
mat_params1  = FLOAT(strmat_file1[params_valid,  *])
mat_indexes1 = strmat_file1[0:2,  *]
arr_classes2 = FIX(strmat_file2[3,*])
mat_params2  = FLOAT(strmat_file2[params_valid,  *])
mat_indexes2 = strmat_file2[0:2,  *]

strarr_paramnames = str_names1[params_valid]

;----------------------------
PRINT, strarr_paramnames
;----------------------------

;-------------------------------------------------------
;-------------------------------------------------------
arr_classes = [[arr_classes1], [arr_classes2]]
mat_params  = [[mat_params1],  [mat_params2]]
mat_indexes = [[mat_indexes1], [mat_indexes2]]

pos_class1 = WHERE(arr_classes EQ 0)
pos_class2 = WHERE(arr_classes EQ 1)

n_class1 = N_ELEMENTS(pos_class1)
n_class2 = N_ELEMENTS(pos_class2)

n_loo_c1 = n_class1/loo_buc ;n_loo_c2 = n_class1/loo_buc
n_loo_c2 = n_class2/loo_buc;

;-------------------------------------------------------
;-------------------------------------------------------
;LOO

FOR k=0L, loo_buc-1 DO BEGIN

	pos_classify_c1 = INDGEN(n_loo_c1)+(k*n_loo_c1)
	pos_classify_c2 = INDGEN(n_loo_c2)+(k*n_loo_c2)

	pos_training_c1 = INDGEN(n_class1)
	pos_1 = WHERE(pos_training_c1 LT pos_classify_c1[0], ct1)
	pos_2 = WHERE(pos_training_c1 GT pos_classify_c1[n_loo_c1-1], ct2)
	IF (ct1 GT 0) AND (ct2 GT 0) THEN $
		pos_training_c1 = [pos_training_c1[pos_1], pos_training_c1[pos_2]]
	IF (ct1 EQ 0) THEN $
		pos_training_c1 = pos_training_c1[pos_2]
	IF (ct2 EQ 0) THEN $
		pos_training_c1 = pos_training_c1[pos_1]

	pos_training_c2 = INDGEN(n_class2)
	pos_1 = WHERE(pos_training_c2 LT pos_classify_c2[0], ct1)
	pos_2 = WHERE(pos_training_c2 GT pos_classify_c2[n_loo_c2-1], ct2)
	IF (ct1 GT 0) AND (ct2 GT 0) THEN $
		pos_training_c2 = [pos_training_c2[pos_1], pos_training_c2[pos_2]]
	IF (ct1 EQ 0) THEN $
		pos_training_c2 = pos_training_c2[pos_2]
	IF (ct2 EQ 0) THEN $
		pos_training_c2 = pos_training_c2[pos_1]

	;--------------------------------------------------------
	IF opt_equal_n THEN BEGIN
		n_c2 = N_ELEMENTS(pos_training_c2)
		n_c1 = N_ELEMENTS(pos_training_c1)

		IF n_c2 LT n_c1 THEN BEGIN
			pos_training_c1 = pos_training_c1[0:n_c2-1]
		ENDIF ELSE BEGIN
			pos_training_c2 = pos_training_c2[0:n_c1-1]
		ENDELSE
	ENDIF
	;--------------------------------------------------------

	mat_training_c1 = mat_params[*, pos_class1[pos_training_c1]]
	mat_training_c2 = mat_params[*, pos_class2[pos_training_c2]]

	mat_training = [[mat_training_c1], [mat_training_c2]]

	mat_classify_c1 = mat_params[*, pos_class1[pos_classify_c1]]
	mat_classify_c2 = mat_params[*, pos_class2[pos_classify_c2]]

	mat_classify = [[mat_classify_c1], [mat_classify_c2]]

	arr_classtrain_c1   = arr_classes[pos_class1[pos_training_c1]]
	arr_classtrain_c2   = arr_classes[pos_class2[pos_training_c2]]

	arr_classtrain = [arr_classtrain_c1, arr_classtrain_c2]

	arr_classmeasure_c1 = arr_classes[pos_class1[pos_classify_c1]]
	arr_classmeasure_c2 = arr_classes[pos_class2[pos_classify_c2]]

	arr_classmeasure = [arr_classmeasure_c1,arr_classmeasure_c2]


	n_param = (SIZE(mat_training))[1]

	;------------------------------------------------------------------------------
	;------------------------------------------------------------------------------
	IF opt_invariant EQ 1 THEN BEGIN	;transforma los 6 primeros momentos en invariantes

		pos_m11 = WHERE(strarr_paramnames EQ 'm11', ct)
		IF ct EQ 0 THEN RETURN
		pos_m11 = pos_m11[0]
		mat_training_inv = data_invariantmoments(mat_training[pos_m11:pos_m11+6, *])
		mat_classify_inv = data_invariantmoments(mat_classify[pos_m11:pos_m11+6, *])
		mat_training = [mat_training, mat_training_inv]
		mat_classify = [mat_classify, mat_classify_inv]
		strarr_paramnames =[strarr_paramnames, 'inv1', 'inv2', 'inv3', 'inv4', 'inv5', 'inv6', 'inv7']

	ENDIF

	n_param = (SIZE(mat_training))[1]

	;-------------------------------------------------------

	IF opt_normalize EQ 1 THEN BEGIN
		FOR i=0, n_param-1 DO BEGIN
			mat_classify[i,*] = var_normalize_3(mat_classify[i,*])
			mat_training[i,*] = var_normalize_3(mat_training[i,*])

		ENDFOR
	ENDIF

	;------------------------------------------------------------------------------
	;------------------------------------------------------------------------------
	; elección de los parámetros más discriminantes

	strarr_paramnames_good = strarr_paramnames

	IF opt_mostdiscriminants THEN BEGIN
		mat_classdis = DBLARR(n_param)
		FOR i=0, n_param-1 DO BEGIN
			mat_classdis[i] = data_singlefeature(mat_training[i,*], arr_classtrain)
		ENDFOR
		arr_sort = REVERSE(SORT(mat_classdis))
		strarr_paramnames_good = strarr_paramnames[arr_sort[0:n_good-1]]
		mat_classify = mat_classify[arr_sort[0:n_good-1],*]
		mat_training = mat_training[arr_sort[0:n_good-1],*]

		n_param = (SIZE(mat_training))[1]
		;arr_weights = mat_classdis[arr_sort[0:n_good-1]]
	ENDIF

	;------------------------------------------------------------------------------
	;------------------------------------------------------------------------------
	; Componentes principales

	IF opt_pca EQ 1 THEN BEGIN

		mat_covar = CORRELATE(mat_training, /COVARIANCE, /DOUBLE)

		mat_training = data_PCA(mat_training, mat_covar, N_DIM=n_pca)
		mat_classify = data_PCA(mat_classify, mat_covar, N_DIM=n_pca)

		n_param = (SIZE(mat_training))[1]

		arr_weights = FLTARR(1, n_param) + 1.0

	ENDIF

	;------------------------------------------------------------------------------
	;------------------------------------------------------------------------------

	IF opt_weights EQ 1 THEN BEGIN
		arr_weights = data_weights(mat_training, OPTION=1)
	ENDIF ELSE BEGIN
		arr_weights = FLTARR(1, n_param) + 1.0
	ENDELSE

	PRINT, arr_weights

	;------------------------------------------------------------------------------
	;------------------------------------------------------------------------------
	IF opt_bayes EQ 1  THEN BEGIN
		str_method ='Bayesiano'
		arr_sal = classify_bayesian(mat_training, mat_classify, arr_classtrain, WEIGTHS=arr_weights)
	ENDIF
	IF opt_knn  EQ 1   THEN BEGIN
		str_method ='Knn'
		arr_sal = classify_knn(mat_training, mat_classify, arr_classtrain, K=n_knn, N=2, $
				MAHALANOBIS=opt_mahalanobis, EUCLIDEAN=opt_euclidean, WEIGTHS=arr_weights)
	ENDIF
	IF opt_fknn  EQ 1   THEN BEGIN
		str_method ='Fuzzy Knn'
		arr_sal = classify_fuzzyknn(mat_training, mat_classify, arr_classtrain, K=n_knn, N=2, $
				THRESHOLD=val_fknn, M_MULT=2, WEIGTHS=arr_weights)
	ENDIF
	IF opt_linear EQ 1 THEN BEGIN
		str_method = 'Discriminante_lineal'
		arr_sal = classify_Lineardiscriminant(mat_classify, arr_discriminant, WEIGTHS=arr_weights)
	ENDIF
	;------------------------------------------------------------------------------
	;------------------------------------------------------------------------------

	arr_1 = arr_classmeasure
	arr_2 = arr_sal

	;---------------------------------------------------------------------------------

	Aciertos_Negativos = TOTAL((arr_1 EQ 0) AND (arr_2 EQ 0))
	Falsos_positivos   = TOTAL((arr_1 EQ 0) AND (arr_2 EQ 1))
	Aciertos_Positivos = TOTAL((arr_1 EQ 1) AND (arr_2 EQ 1))
	Falsos_Negativos   = TOTAL((arr_1 EQ 1) AND (arr_2 EQ 0))

	Sensibilidad[k]  = Aciertos_positivos/(Aciertos_positivos + Falsos_negativos)
	Especificidad[k] = Aciertos_negativos/(Aciertos_negativos + falsos_positivos)


	Pos_fpos = WHERE((arr_1 EQ 0) AND (arr_2 EQ 1), ct_1)
	Pos_fneg = WHERE((arr_1 EQ 1) AND (arr_2 EQ 0), ct_2)

	IF ct_1 EQ 0 THEN arr_fpos = [0] ELSE $
		arr_fpos = mat_indexes[*, Pos_fpos]

	IF ct_2 EQ 0 THEN arr_fneg = [0] ELSE $
		arr_fneg = mat_indexes[*, Pos_fneg]

	;---------------------------------------------------------------------------------

	IF opt_detecterrors EQ 1 THEN BEGIN

		str_var =''
		FOR i=0L, falsos_positivos-1 DO BEGIN
			culture  = arr_fpos[0,i]
			culture = STRMID(culture, 1)
			n_image  = FIX(arr_fpos[1,i])
			n_object = FIX(arr_fpos[2,i])
			im1 = view_bacile_disk(n_image, n_object, CULTURE=culture)
			WAIT, 3
			;READ, str_var, prompt='Pausa, presione una tecla'
		ENDFOR
	ENDIF

	;------------------------------------------------------------------------------

	;PRINT, ''
	;PRINT, 'Objetos falsos negativos'
	;PRINT, ''
	;PRINT, arr_fneg
	;PRINT, ''
	;PRINT, 'Objetos falsos positivos'
	;PRINT, ''
	;PRINT, arr_fpos
	;PRINT, ''

	PRINT, ''
	PRINT, 'Positivos de entrenamiento: ', N_ELEMENTS(WHERE(arr_classtrain   EQ 1))
	PRINT, 'Negativos de entrenamiento: ', N_ELEMENTS(WHERE(arr_classtrain   EQ 0))
	PRINT, 'Positivos de Test         : ', N_ELEMENTS(WHERE(arr_classmeasure EQ 1))
	PRINT, 'Negativos de Test         : ', N_ELEMENTS(WHERE(arr_classmeasure EQ 0))
	PRINT, ''

	PRINT, str_method
	PRINT, ''
	PRINT, 'Aciertos negativos :  ', Aciertos_Negativos
	PRINT, 'Falsos positivos   :  ', Falsos_positivos
	PRINT, 'Aciertos positivos :  ', Aciertos_Positivos
	PRINT, 'Falsos negativos   :  ', Falsos_Negativos
	PRINT, ''
	PRINT, 'Sensibilidad  :  ', sensibilidad[k]
	PRINT, 'Especificidad :  ', especificidad[k]
	PRINT, ''
	PRINT, strarr_paramnames_good
	PRINT, ''

	;------------------------------------------------------------------------------

	;fisher = data_lambdawilks(mat_training, arr_classtrain, /FISHER)
	;wilks  = data_lambdawilks(mat_training, arr_classtrain, /WILKS, /TRAC)
	;res = data_singlefeature(mat_training[0,*], arr_classtrain)

ENDFOR

sensibilidad_t  = MEAN(sensibilidad)
especificidad_t = MEAN(especificidad)

PRINT, ''
PRINT, ''
PRINT, 'Sensibilidad media  :  ', sensibilidad_t
PRINT, 'Especificidad media :  ', especificidad_t
PRINT, ''



END
