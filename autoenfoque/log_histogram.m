function resultado = log_histogram (imagen)

% loghistogram(imagen) busca la función publicada por Gabriel Cristóbal
% para el autoenfoque. La imagen tiene que estar en formato double.

resultado = 0.0;

[histogram, x] = imhist(imagen);

loghistogram = log10(histogram);
valor_total = sum(histogram);

for i=1:length(histogram),
    
    p_i = double(histogram(i))/valor_total;
    E_log_i = loghistogram(i);
   
    if p_i > 0, resultado = resultado + ((i-E_log_i)^2)*log10(p_i); end
    
end
end

