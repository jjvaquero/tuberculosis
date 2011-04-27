function resultado = vollathf5(imagen)

%vollath(imagen) devuelve F5 de Vollath sobre la imagen seleccionada.

[y, x] = size(imagen);

imagen = uint32(imagen);
resultado = uint32(0);
size_imagen = size(imagen);

circ1 = circshift(imagen, [1, 0]);

circ1(:,x) = zeros(1, y);


resultado = sum(sum(uint32(imagen.*circ1)))...
    -size_imagen(1)*size_imagen(2)*(mean(mean(imagen)))^2;
end
