

;PRO fbat_classify_Bayesian

;@fbat_classify_bayesian

str_disk1 = 'e:\'
str_path1 = 'micro\results\files_tab_training\'
str_file1 = 'Tabfile_all_x1_20_iSAM_c01_norm.txt'

str_disk2 = 'e:\'
str_path2 = 'micro\results\files_tab_test\'
str_file2 = 'Tabfile_all_x21_41_iSAM_c01_norm.txt'

;str_disk3 = 'e:\'
;str_path3 = 'micro\results\files_tab_all\'
;str_file3 = 'Tabfile_all_iSAM.txt'

path_file1 = str_disk1 + str_path1 + str_file1
path_file2 = str_disk2 + str_path2 + str_file2
;path_file3 = str_disk3 + str_path3 + str_file3

;--------------------------------------------------------
str_names1   = read_spss_archive(path_file1, /NAMES)
strmat_file1 = read_spss_archive(path_file1)

str_names2   = read_spss_archive(path_file2, /NAMES)
strmat_file2 = read_spss_archive(path_file2)

;str_names3   = read_spss_archive(path_file3, /NAMES)
;strmat_file3 = read_spss_archive(path_file3)
;--------------------------------------------------------

tam1 = SIZE(strmat_file1)
tam2 = SIZE(strmat_file2)
n_samples1 = tam1[2]
n_samples2 = tam2[2]
strmat_file1 = strmat_file1[*,1:n_samples1-1]
strmat_file2 = strmat_file2[*,1:n_samples2-1]
tam1 = SIZE(strmat_file1)
tam2 = SIZE(strmat_file2)
n_samples1 = tam1[2]
n_samples2 = tam2[2]

;momentos = 15:22
;todos = 4:38

;0 = 'culture'
;1 = 'n_image'
;2 = 'class'
;3 = 'index'
;4 = 'size'
;5 = 'perim'
;6 = 'mean_r'
;7 = 'mean_g'
;8 = 'mean_b'
;9 = 'stdv_r'
;10 = 'stdv_g'
;11 = 'stdv_b'
;12 = 'm00'
;13 = 'm10'
;14 = 'm01'
;15 = 'm11'
;16 = 'm20'
;17 = 'm02'
;18 = 'm21'
;19 = 'm12'
;20 = 'm22'
;21 = 'm31'
;22 = 'm13'
;23 = 'origin_x'
;24 = 'origin_y'
;25 = 'cmass_x'
;26 = 'cmass_y'
;27 = 'gcmass_x'
;28 = 'gcmass_y'
;29 = 'longdim'
;30 = 'thinness'
;31 = 'angle'
;32 = 'ffactor'
;33 = 'feretd'
;34 = 'compact'
;35 = 'maxr'
;36 = 'minr'
;37 = 'maxdist'
;38 = 'rectness'
;-------------------------------------------------------

;params_valid = [4:11,15:22,29,30,32:38]

arr_classes1 = FIX(strmat_file1[3,*])
mat_params1  = FLOAT([strmat_file1[4:11,  *], strmat_file1[15:22, *], $
					  strmat_file1[29:30, *], strmat_file1[32:38, *]])

arr_classes2 = FIX(strmat_file2[3,*])
mat_params2  = FLOAT([strmat_file2[4:11,  *], strmat_file2[15:22, *], $
					  strmat_file2[29:30, *], strmat_file2[32:38, *]])

strarr_paramnames = [str_names1[4:11], str_names1[15:22], $
					str_names1[29:30], str_names1[32:38]]

PRINT, strarr_paramnames


mat_training = mat_params2*10
mat_classify = mat_params1*10
arr_classtrain   = arr_classes2
arr_classmeasure = arr_classes1

n_param = (SIZE(mat_training))[1]
arr_weights = FLTARR(1, n_param) + 1.0
arr_weights[0]=1

;arr_discriminant =[8.655, 0.477, -138.577, -0.540, 0.234, 1.030, 1.374, 2.570, -0.336, -0.194, $
;					363.781, 69.214, 0.714,-6.399, 0.243, 0.881, 2.627, 95.754, 1.558, -9.840, $
;					22.451, -3.422, 2.417, -45.398, -102.610, 4.972]

;mat_gauss = Get_GaussianMultivariate(mat_training)
;arr_means = mat_gauss[*,0]
;mat_covar = mat_gauss[*,1:n_param]
;provav = Value_gaussianMultivariate(mat_training[*,0], arr_means, mat_covar, EXP=1)

arr_sal = classify_bayesian(mat_training, mat_classify, arr_classtrain, WEIGTHS=arr_weights)

arr_1 = arr_classmeasure
arr_2 = arr_sal

PRINT, 'Aciertos negativos :  ', TOTAL((arr_1 EQ 0) AND (arr_2 EQ 0))
PRINT, 'Falsos positivos   :  ', TOTAL((arr_1 EQ 0) AND (arr_2 EQ 1))
PRINT, 'Aciertos positivos :  ', TOTAL((arr_1 EQ 1) AND (arr_2 EQ 1))
PRINT, 'Falsos negativos   :  ', TOTAL((arr_1 EQ 1) AND (arr_2 EQ 0))


;END

