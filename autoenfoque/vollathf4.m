function resultado = vollathf4(imagen)

%vollath(imagen) devuelve F4 de Vollath sobre la imagen seleccionada.

[y, x] = size(imagen);

imagen = uint32(imagen);
resultado = uint32(0);

circ1 = circshift(imagen, [1, 0]);
circ2 = circshift(imagen, [2, 0]);

circ1(:,x) = zeros(1, y);
circ2(:,x) = zeros(1, y);
circ2(:,x-1) = zeros(1, y);

resultado = sum(sum(uint32(imagen.*circ1)))-sum(sum(uint32(imagen.*circ2)));
end
