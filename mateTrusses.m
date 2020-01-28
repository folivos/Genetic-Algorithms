function mateTrusses(matePairs,numIndivid,ratioParents)
%mateTrusses(matePairs,numIndivid,ratioParents)
%mateTrusses, various mating schemes, start with random single point
%cross-over for only vertices
%
%input:
%   pop = [nIndivid x1] array of structs which are trusses (genomes)
%   matePairs = [nPairs x 2] array of individuals to be mated from pop
%   numIndivid = number of individuals in pop
%   ratioParents = ratio of pop that is kept as parents from prev. gen.
%ouput:
%   ??
global pop;

numPairs = size(matePairs,1);
numKids = numIndivid-numIndivid*ratioParents;
idxCull = setdiff(1:numIndivid, matePairs(:)); % id de los que no se reproducen

assert(size(idxCull,2)==numKids);%tira un error si la condicion es falsa

kidsPerPair = round(2*(1-ratioParents)/ratioParents);% 4
assert(kidsPerPair*numPairs==numKids);%160

idxKid = 1;
for i =1:numPairs % 40
    mom = pop{matePairs(i,1)};%uso el indice de matePairs y asigno su reticulado
    dad = pop{matePairs(i,2)};
    for j = 1:kidsPerPair
        idxReplace = idxCull(1,idxKid);
        pop{idxReplace} = snglPntCrossOver(mom,dad);
        idxKid = idxKid+1;
    end
    
end



end

