
FUNCTION baciles_separate_1, im, kt

; la ultima de norberto
; separa los bacilos para obtener sus características


; Deteccion de bacilos en imagenes de auramina
; Entrada: Imagen original de canales de gris
; Salida:  Imagen binaria de los bacilos detectados


im     = SMOOTH(im,5)
kernel = REPLICATE(1,kt,kt)
reckernel = [[0,1,0],[1,0,1],[0,1,0]]
opim = MORPH_OPEN(UINT(im), kernel, /GRAY, /PRESERVE_TYPE)
;opim = grayopen(im,Estructura=kernel)
recim = reconstruction(im,opim,Estructura=kernel)

topim = im - recim
tim = topim GT 30

objim = tim*im

RETURN, objim

END