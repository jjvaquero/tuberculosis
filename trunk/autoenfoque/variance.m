function resultado = variance(imagen)

[y, x] = size(imagen);


media = mean(mean(imagen));

resultado = sum(sum((imagen-media).^2))/(x*y);

end
