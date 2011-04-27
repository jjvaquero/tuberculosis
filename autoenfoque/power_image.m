function [ valor ] = power_image( image )
%POWER Energía de la imagen


valor = sum(sum(image.^2));

end
