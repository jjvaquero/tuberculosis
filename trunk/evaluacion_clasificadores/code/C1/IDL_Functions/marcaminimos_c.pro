
;**************************************************************************************
;
; FUNCION:  Marcaminimos_c.pro
;
; LLAMADA:  image_s = marcaminimos_c(image_o, OPTION=option)
;                          I
; PROPOSITO:  Etiqueta una imagen de mínimos
;
; ENTRADAS:   image_o    - Imagen de entrada binaria con mínimos a uno
;
; SALIDA:     image_s    - Imagen de mínimos marcados
;
; KEYWORDS:
;       OPTION:    - Tipo de conectividad
;                1 - Conectividad 4
;                2 - Conectividad 8
;
;
; COMENTARIOS:    Utiliza funciones compiladas en C (Watershed2.dll)
;                 Se usa conjuntamente con minimos_c (que marca los minimos antes)
;
; AUTOR:          Juan E. Ortuño Fisac -  18-04-2001
;
;**************************************************************************************


FUNCTION marcaminimos_c, image_o, OPTION=option

IF (SIZE(image_o))[0] NE 2 THEN BEGIN
    PRINT, 'Los Datos de entrada no son válidos'
    RETURN, -1
ENDIF

IF N_ELEMENTS(option) EQ 0 THEN opt=1  ELSE opt = option
IF N_ELEMENTS(opt)    NE 1 THEN BEGIN & PRINT, 'OPTION no válida'    & RETURN, -1 & END
IF MAX(opt EQ [1,2])  LT 1 THEN BEGIN & PRINT, 'OPTION no válida'    & RETURN, -1 & END

CASE opt OF
    1 : key = 'marcaminimos_s1'
    2 : key = 'marcaminimos_s2'
ENDCASE

imag_o   = FIX(image_o)
imag_s   = FIX(imag_o*0)

xsize    = FIX((SIZE(imag_o))[1])
ysize    = FIX((SIZE(imag_o))[2])

;------------------------------------------------------------------------------------------
PRINT, 'LLamada a dll' & T = SYSTIME(1)
r = CALL_EXTERNAL('dlls\Watershed2', key, $
                    imag_o, imag_s, xsize, ysize , $
                     /UNLOAD, /CDECL)
PRINT, 'Watershed2.dll - marcaminimos_s*.c:               ',  SYSTIME(1) - T, ' Seg'
;------------------------------------------------------------------------------------------

RETURN, imag_s

;tipado 1

END ;

