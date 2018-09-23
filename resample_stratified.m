% From Jose-Luis Blanco
% Adjusted it so that you can specify how many samples you want out and
% also handling unnormalized weight arrays

function [ indx ] = resample_stratified( w, newN )

N = length(w);

if sum(w) == 0
    disp(sprintf('Weights are all zero, will not work to resample, resetting weights'))
    w = ones(1,N)/N;
end

Q = cumsum(w);


T = rand(1,newN)/newN + (0:(newN-1))/newN;
T(newN+1) = 1;

T = Q(end)*T;

i=1;
j=1;

while (i<=newN),
    if (T(i)<Q(j)),
        indx(i)=j;
        i=i+1;
    else
        j=j+1;        
    end
end