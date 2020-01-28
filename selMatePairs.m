function[ maits ] = selMatePairs( costs,numKeep )
%[ maitPairs ] = selMatePairs( costs )
%selects the mate pairs using rank selection. (other options later)
%input:
%   costs = [numIndivid x2] array, col1 is cost, col2 is index in pop,
%           ordered by rank
%ouput:
%   maitPairs = [numPairs x 2] array, col1 = mom, col2 = dad, :)
%               if numKeep is odd then someone mates twice

numPairs = ceil(numKeep/2);%numero de parejas
maits = zeros(numPairs,2); %matriz que guardara las parejas
for i =1:numPairs
    mI = 2*i-1; %impares
    
    mom = costs(mI,2);%saca de la matriz de costos, el indice impar de los
    %primeros rankeados (el primer tercio)
    if (i==numPairs && mod(numKeep,2)==1)
        %last pair, if it was an odd numKeep, use random dad
        %(hermaphodites,clearly)
        dad = costs(randi(numKeep),2);
    else
        dad = costs(mI+1,2);
    end
    
    maits(i,:) = [mom,dad];
end


end
