
FUNCTION baciles_separate_2, im, kt


; Separa los bacilos para obtener sus características

; la ultima de norberto
; con mi codigo de reconstruccion
; para ver si son iguales

; Deteccion de bacilos en imagenes de auramina
; Entrada: Imagen original de canales de gris
; Salida:  Imagen binaria de los bacilos detectados


im     = SMOOTH(im,5)
kernel = REPLICATE(1,kt,kt)
reckernel = [[0,1,0],[1,0,1],[0,1,0]]
opim = MORPH_OPEN(UINT(im), kernel, /GRAY, /PRESERVE_TYPE)
;opim = grayopen(im,Estructura=kernel)
recim = reconstruction_c(im,opim, OPTION=4)		; Kernel = 7x7 hay que hacerlo con cualquier kernel

topim = im - recim
tim = topim GT 30

objim = tim*im

RETURN, objim

END