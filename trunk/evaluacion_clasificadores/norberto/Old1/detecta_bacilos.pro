function detecta_bacilos, image, kt

; la ultima de norberto

; Deteccion de bacilos en imagenes de auramina
; Entrada: Imagen original de tres canales
; Salida:  Imagen binaria de los bacilos detectados

tam = size(image)

im = bytarr(tam(2),tam(3))
im(*,*) = image(1,*,*)
im = congrid(im,800,600)
im=smooth(im,5)
kernel = replicate(1,kt,kt)
reckernel = [[0,1,0],[1,0,1],[0,1,0]]
opim = grayopen(im,Estructura=kernel)
recim = reconstruction(im,opim,Estructura=kernel)

topim = im - recim
tim = threshold(topim,30)

objim = tim*im
;labelim = GetConnected(tim,Numobj=num)

;medias = bytarr(num+1)
;for i = 1, num do begin
;medias(i)= total((labelim EQ i)*im)/total(labelim EQ i)
;endfor

;print,medias

return, objim

end