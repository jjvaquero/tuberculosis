function pilla_objetos_negativos

obj = bytarr(40,800,600)
for i = 1,8 do begin
fichero = 'e:\nmalpica\images\microbiologia\negativas\127820\image'+ strtrim(i,1) +'.tif'
im=read_tiff(fichero)
obj(i-1,*,*) = detecta_bacilos(im,7)
print,'Procesada imagen ', i
fichero_salida = 'e:\nmalpica\images\microbiologia\negativas\127820\obj'+ strtrim(i,1) +'.tif'
im=bytarr(800,600)
im(*,*)=obj(i-1,*,*)
write_tiff,fichero_salida, im
endfor

obj = bytarr(40,800,600)
for i = 1,8 do begin
fichero = 'e:\nmalpica\images\microbiologia\negativas\127855\image'+ strtrim(i,1) +'.tif'
im=read_tiff(fichero)
obj(i-1,*,*) = detecta_bacilos(im,7)
print,'Procesada imagen ', i
fichero_salida = 'e:\nmalpica\images\microbiologia\negativas\127855\obj'+ strtrim(i,1) +'.tif'
im=bytarr(800,600)
im(*,*)=obj(i-1,*,*)
write_tiff,fichero_salida, im
endfor

obj = bytarr(40,800,600)
for i = 1,8 do begin
fichero = 'e:\nmalpica\images\microbiologia\negativas\127857\image'+ strtrim(i,1) +'.tif'
im=read_tiff(fichero)
obj(i-1,*,*) = detecta_bacilos(im,7)
print,'Procesada imagen ', i
fichero_salida = 'e:\nmalpica\images\microbiologia\negativas\127857\obj'+ strtrim(i,1) +'.tif'
im=bytarr(800,600)
im(*,*)=obj(i-1,*,*)
write_tiff,fichero_salida, im
endfor

obj = bytarr(40,800,600)
for i = 1,8 do begin
fichero = 'e:\nmalpica\images\microbiologia\negativas\127858\image'+ strtrim(i,1) +'.tif'
im=read_tiff(fichero)
obj(i-1,*,*) = detecta_bacilos(im,7)
print,'Procesada imagen ', i
fichero_salida = 'e:\nmalpica\images\microbiologia\negativas\127858\obj'+ strtrim(i,1) +'.tif'
im=bytarr(800,600)
im(*,*)=obj(i-1,*,*)
write_tiff,fichero_salida, im
endfor

obj = bytarr(40,800,600)
for i = 1,8 do begin
fichero = 'e:\nmalpica\images\microbiologia\negativas\127859\image'+ strtrim(i,1) +'.tif'
im=read_tiff(fichero)
obj(i-1,*,*) = detecta_bacilos(im,7)
print,'Procesada imagen ', i
fichero_salida = 'e:\nmalpica\images\microbiologia\negativas\127859\obj'+ strtrim(i,1) +'.tif'
im=bytarr(800,600)
im(*,*)=obj(i-1,*,*)
write_tiff,fichero_salida, im
endfor

obj = bytarr(40,800,600)
for i = 1,8 do begin
fichero = 'e:\nmalpica\images\microbiologia\negativas\127860\image'+ strtrim(i,1) +'.tif'
im=read_tiff(fichero)
obj(i-1,*,*) = detecta_bacilos(im,7)
print,'Procesada imagen ', i
fichero_salida = 'e:\nmalpica\images\microbiologia\negativas\127860\obj'+ strtrim(i,1) +'.tif'
im=bytarr(800,600)
im(*,*)=obj(i-1,*,*)
write_tiff,fichero_salida, im
endfor

obj = bytarr(40,800,600)
for i = 1,8 do begin
fichero = 'e:\nmalpica\images\microbiologia\negativas\127861\image'+ strtrim(i,1) +'.tif'
im=read_tiff(fichero)
obj(i-1,*,*) = detecta_bacilos(im,7)
print,'Procesada imagen ', i
fichero_salida = 'e:\nmalpica\images\microbiologia\negativas\127861\obj'+ strtrim(i,1) +'.tif'
im=bytarr(800,600)
im(*,*)=obj(i-1,*,*)
write_tiff,fichero_salida, im
endfor








return, obj
end