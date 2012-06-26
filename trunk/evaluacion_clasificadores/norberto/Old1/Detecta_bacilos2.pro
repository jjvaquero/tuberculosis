
FUNCTION detecta_bacilos2, image

; Deteccion de bacilos en imagenes de auramina
; Entrada: Imagen original (canal verde)
; Salida:  Imagen binaria de los bacilos detectados

; con reconstrucción rapida con elemento de cruz 3x3


T=SYSTIME(1)

tam = SIZE(image)

im  = FIX(image)

kernel = UINT(REPLICATE(1,7,7))
opim   = MORPH_OPEN(UINT(im), kernel, /GRAY, /PRESERVE_TYPE)
;recim  = reconstruction(im, opim, ESTRUCTURA=kernel)
recim  = reconstruction_c(im, opim, OPTION=3)



topim = im - recim
tim =  topim GT 30	;treshold(topin, 30)


labelim = GetConnected(tim,Numobj=num)

medias = bytarr(num+1)
for i = 1, num do begin
medias(i)= total((labelim EQ i)*im)/total(labelim EQ i)
endfor

PRINT, 'Tiempo de detecta_bacilos2.pro : ', SYSTIME(1)-T,  ' Seg'

RETURN, tim

end