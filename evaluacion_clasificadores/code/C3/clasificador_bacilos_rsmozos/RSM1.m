function [soft]=RSM1(X,param);
% see BasePositivos5_bacilosAll.m
%param.MING
%param.MEDIA_MIN
%param.UMBRAL_MEDIA_MIN

try
    param=param;
    MING=param.MING;
MEDIA_MIN=param.MEDIA_MIN;
UMBRAL_MEDIA_MIN=param.UMBRAL_MEDIA_MIN;
catch
MING=75;% 75;% 80; % the minimum database is 99
MEDIA_MIN=56;
UMBRAL_MEDIA_MIN=14; %14; %16 % the value of the database.
end

soft=-ones(size(X,1),1);

% calculos
IG=(37*37+1):(2*37*37);
NPIXELS_GREATER=sum(X(:,IG)>=MING,2);
NPIXELS_GREATER2=sum(X(:,IG)>MEDIA_MIN,2);

soft((NPIXELS_GREATER > 0) & (NPIXELS_GREATER2 >UMBRAL_MEDIA_MIN))=1;


