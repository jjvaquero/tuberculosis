function resultado = volf5(imagen)

%vollath(imagen) devuelve F5 de Vollath sobre la imagen seleccionada.

[x,y] = size(imagen);


circ1 = circshift(imagen, -1);

circ1(x,:) = zeros(1, y);

resultado = sum(sum((imagen.*circ1)))-x*y*(mean(mean(imagen)))^2;
end