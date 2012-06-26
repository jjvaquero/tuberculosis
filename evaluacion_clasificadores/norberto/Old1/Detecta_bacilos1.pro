
FUNCTION detecta_bacilos1, image

; Deteccion de bacilos en imagenes de auramina
; Entrada: Imagen original (canal verde)
; Salida:  Imagen binaria de los bacilos detectados

; Original norberto


T=SYSTIME(1)

tam = SIZE(image)

im  = FIX(image)

kernel = UINT(REPLICATE(1,7,7))
opim   = MORPH_OPEN(UINT(im), kernel, /GRAY, /PRESERVE_TYPE)

;kernel2 = UINT(REPLICATE(1,9,9))
recim  = reconstruction(im, opim, ESTRUCTURA=kernel)
;recim  = reconstruction_c(im, opim, OPTION=3)
;recim = opim



topim = im - recim
tim =  topim GT 30	;treshold(topin, 30)


labelim = GetConnected(tim,Numobj=num)

medias = bytarr(num+1)
for i = 1, num do begin
medias(i)= total((labelim EQ i)*im)/total(labelim EQ i)
endfor

PRINT, 'Tiempo de detecta_bacilos1.pro : ', SYSTIME(1)-T,  ' Seg'

RETURN, tim

end