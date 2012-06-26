

PRO fbat_classify_knn

;@fbat_classify_knn

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

arr_classes1 = FIX(strmat_file1[3,*])
mat_params1  = FLOAT(strmat_file1[4:30, *]) ; momentos

arr_classes2 = FIX(strmat_file2[3,*])
mat_params2  = FLOAT(strmat_file2[4:30, *])

strarr_paramnames = str_names1[4:30]
PRINT, strarr_paramnames

n_begin_1 = 0
n_end_1   = 300
n_begin_2 = n_samples1-50
n_end_2   = n_samples1-1


;mat_training1 = mat_params1[*, n_begin_1:n_end_1]
;mat_training2 = mat_params1[*, n_begin_2:n_end_2]
;mat_training = [[mat_training1], [mat_training2]]

;arr_class1 = arr_classes1[0, n_begin_1:n_end_1]
;arr_class2 = arr_classes1[0, n_begin_2:n_end_2]
;arr_classtrain = [[arr_class1], [arr_class2]]

;mat_classify      = mat_params1[*, n_end_1+1:n_begin_2-1]
;arr_classmeasure = mat_classes1[0, n_end_1+1:n_begin_2-1]

mat_training = mat_params1
mat_classify = mat_params2
arr_classtrain   = arr_classes1
arr_classmeasure = arr_classes2

n_param = (SIZE(mat_training))[1]
arr_weights = FLTARR(1, n_param) + 1.0
arr_weights[0]=1

arr_sal = classify_knn(mat_training, mat_classify, arr_classtrain, K=7, N=2, WEIGTHS=arr_weights)

arr_1 = arr_classmeasure
arr_2 = arr_sal

PRINT, 'Aciertos negativos :  ', TOTAL((arr_1 EQ 0) AND (arr_2 EQ 0))
PRINT, 'Falsos positivos   :  ', TOTAL((arr_1 EQ 0) AND (arr_2 EQ 1))
PRINT, 'Aciertos positivos :  ', TOTAL((arr_1 EQ 1) AND (arr_2 EQ 1))
PRINT, 'Falsos negativos   :  ', TOTAL((arr_1 EQ 1) AND (arr_2 EQ 0))


END

