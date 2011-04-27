function resultado = totalvariation(imagen)
[y, x] = size(imagen);
resultado = sum(sum(abs(imagen(:,2:x)-imagen(:,1:x-1)))) + ...
    sum(sum(abs(imagen(2:y,:)-imagen(1:y-1,:))));
end
