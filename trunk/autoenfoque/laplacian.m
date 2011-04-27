function resultado = laplacian(imagen)

%imagen = uint32(imagen);

mat1 = circshift(imagen, [1, 0]);
mat2 = circshift(imagen, [-1, 0]);
mat3 = circshift(imagen, [0, 1]);
mat4 = circshift(imagen, [0, -1]);

resultado = sum(sum((mat1 + mat2 + mat3 + mat4 - 4*imagen).^2));
end