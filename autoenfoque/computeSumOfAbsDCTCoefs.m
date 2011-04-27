function sumOfAbsDCTCoefs = computeSumOfAbsDCTCoefs(blockA, Low, bandSize);
%% Computes the sum of abs DCT coefs from the area marked within a block:

% Example: the values marked x are considered for the sum
%     Low High
% - - x x x - - -
% - - x x x - - - 
% x x x x x - - - Low  |
% x x x x x - - -      | bandSize (s)
% x x x x x - - - High |
% - - - - - - - -
% - - - - - - - -
% 

blockSize = size(blockA);

High = Low  + bandSize - 1;
if (High > blockSize(1)) 
    High = blockSize(1);
end
LowMinus1 = Low -1;
dctA = dct2(blockA);

dctA1 = dctA(Low:High, 1:High);
%dctA2 = dctA(1:(Low-1), Low:High);
dctA2 = dctA(1:LowMinus1, Low:High);

sumOfAbsDCTCoefs = sum(abs(dctA1(:)))+  sum(abs(dctA2(:)));
 