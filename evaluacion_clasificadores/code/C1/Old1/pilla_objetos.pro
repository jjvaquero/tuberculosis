function pilla_objetos


obj = bytarr(20,800,600)
for i = 1,20 do begin
fichero = 'e:\nmalpica\images\microbiologia\27_9_01\image'+ strtrim(i,1) +'.tif'
im=read_tiff(fichero)
obj(i-1,*,*) = detecta_bacilos(im,7)
print,'Procesada imagen ', i
fichero_salida = 'e:\nmalpica\images\microbiologia\27_9_01\obj'+ strtrim(i,1) +'.tif'
im=bytarr(800,600)
im(*,*)=obj(i-1,*,*)
write_tiff,fichero_salida, im
endfor

return, obj
end