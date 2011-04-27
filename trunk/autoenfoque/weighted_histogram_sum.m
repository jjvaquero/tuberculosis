function value = weighted_histogram_sum(I)

h = imhist(uint8(I));
value = sum(h'.^(1/5).*([0:255].^5))*10^-15;