function [ valor ] = power_image( image )
%POWER Energ�a de la imagen


valor = sum(sum(image.^2));

end
