%% function focusMeasure = computeFocus(imgA, fLow, fBandSize, step );

% computes focus as from imgA as the sum of abs DCT coefs per pixel
%
% The sum of abs DCT coefs is computed from each block
% for the interval of frequencies Low ... High, see the example: 
%
%     Low High
% - - x x x - - -
% - - x x x - - - 
% x x x x x - - - Low = 3 |
% x x x x x - - -         | bandSize = 3
% x x x x x - - - High =5 |
% - - - - - - - -
% - - - - - - - -
% 
% uses m-file: computeSumOfAbsDCTCoefs(blockA, Low, bandSize)
%%-----------------------------------------------------------

%% ---
function focusMeasure = computeFocus(imgA, fLow,fBandSize, step );
Low = fLow;
bandSize = fBandSize;
BLOCKSIZE = 40;   % for DCT2
%BSize2 = int32(BLOCKSIZE/2);
[M,N] = size(imgA);
% -------------------------------------

blockA = zeros(BLOCKSIZE,BLOCKSIZE); 
sumOfAllBlocks = 0;

for x = 1: step : (M - BLOCKSIZE)
   for y = 1: step : (N - BLOCKSIZE)
                       
       blockA = imgA(x:x+BLOCKSIZE-1,y:y+BLOCKSIZE-1);
       % Compute sum of given DCT coefs
%        dctA=dct2(blockA);
%        dctA1 = (abs(dctA(5,5)+dctA(5,6)+dctA(6,5)));
%        sumBlockA=dctA1;
%        sumOfAbsDCTCoefs = sum(abs(dctA1(:))) +  sum(abs(dctA2(:)));
       sumBlockA = computeSumOfAbsDCTCoefs(blockA, Low, bandSize);
       sumOfAllBlocks = sumOfAllBlocks + sumBlockA;
   end
end

% xx = [1: step : M - BLOCKSIZE];
% yy = [1: step : N - BLOCKSIZE];
% numOfBlocksComputed = length(xx)* length(yy);
focusMeasure = sumOfAllBlocks; %/ numOfBlocksComputed;

            
            