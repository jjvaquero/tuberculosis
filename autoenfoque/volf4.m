function resultado = volf4(imagen)

%vollath(imagen) devuelve F4 de Vollath sobre la imagen seleccionada.

[x,y] = size(imagen);

circ1 = circshift(imagen, -1);
circ2 = circshift(imagen, -2);

circ1(x,:) = zeros(1, y);
circ2(x,:) = zeros(1, y);
circ2(x-1,:) = zeros(1, y);

resultado = sum(sum((imagen.*circ1)))-sum(sum((imagen.*circ2)));
end
