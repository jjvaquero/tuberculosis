function measure = log_hist(I)
% m = fm(path,ind)
% Calculates the focus measure (FM) for images "path[ind].tif"
% path ... path + name of a serie of images; 
% ind ... a vector of numbers that identify the images
% image filenames are expected to have the form: path[index].tif
% ind must contain the correct [index] values
%

% Modified by Rafaael Redondo Jun-2010

    
    % variance of log(histogram)
    h = log(hist(I(:),[1:255]));
    h(h == -Inf) = 0;
    h = h/sum(h);
    measure = h*([1:255]-(h*[1:255]'))'.^2;

