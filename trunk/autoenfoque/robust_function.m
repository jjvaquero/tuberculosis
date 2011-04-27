function resultado = robust_function(imagen, sigma)

%robust_function(imagen, sigma) implementa el método publicado en Geusebroek et al
%en Cytometry, 2000. Utiliza una derivada gaussiana a lo largo del eje X.

%imagen = uint32(imagen);

[gaussianx, gaussiany] = gaussgradient(imagen, sigma); % Devuelve x, y

resultado = sum(sum(gaussianx.^2)); % Da igual la ponderación

end

