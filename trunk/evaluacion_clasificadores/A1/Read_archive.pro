

 FUNCTION Read_archive, file

;---------------------------------------------------------------------------------------
; Función de lectura de un fichero ASCII en un array de strings
; Cada fila acabada en un RETURN es una celda del array de salida
;
;
; file = 'e:\micro\results\21_09_01\image2_IDL_spss_iSA.txt'
; file = 'f:\micro\results\124042\image05_IDL_spss_iSA.txt'
; file = 'f:\micro\results\files_tab\Tabfile_all_x100_iSA.txt'
; r = read_archive(file)
;---------------------------------------------------------------------------------------


IF NOT FILE_TEST(file) THEN BEGIN
	PRINT, ' Archivo inexistente'
	RETURN, ''
ENDIF

strarr_file = ''
str_line = ''
i = 0

T = SYSTIME(1)

;------------------------------------------------------------
OPENR, unit, file, /GET_LUN

file_info = FSTAT(unit)

IF file_info.size EQ 0 THEN BEGIN
	PRINT, ' Archivo vacío'
	CLOSE,    unit
	FREE_LUN, unit
	RETURN, ''
ENDIF


WHILE NOT EOF(unit) DO BEGIN
    READF, unit, str_line
    strarr_file[i] = str_line
    strarr_file    = [[strarr_file],['']]
    i=i+1
ENDWHILE

CLOSE,    unit
FREE_LUN, unit
;------------------------------------------------------------

IF i LE 0 THEN BEGIN
	PRINT, 'Archivo vacío'
	RETURN, ''
ENDIF
;------------------------------------------------------------

strarr_file = strarr_file[*, 0:i-1]


PRINT, 'Tiempo de lectura y proceso de archivo  :', SYSTIME(1) - T


RETURN, strarr_file

END


