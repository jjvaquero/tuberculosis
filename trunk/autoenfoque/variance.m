function resultado = variance(imagen)

[y, x] = size(imagen);

imagen = uint32(imagen);

resultado = uint32(0);

media = mean(mean(imagen));

resultado = (1.0/x*y)*sum(sum(uint32(imagen-media^2)));

end
