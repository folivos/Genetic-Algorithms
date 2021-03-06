function mutateTrusses(pop,numIndivid,costs,numKeep,mutationRate)
%mutateTrusses(pop,costs,numKeep)
%   mutate Trusses!! start with only mutating the verts

numVertsPerTruss = size(pop{1}.Coord, 2);
%numero de mutaciones en todos los nodos de la poblacion total
numMutations = ceil(mutationRate*numVertsPerTruss*numIndivid);

%solo los menos adaptados mutan. Se rescata su id
idxTrussCanMutate = sort(costs(numKeep+1:end,2));

%VERT MUTATION
offset = 2; %cm.
mutateVerts(offset, idxTrussCanMutate,numMutations, numVertsPerTruss);


end

function mutateVerts(offset,idxTrussCanMutate,numMutations, numVerts)
%[mutatedVerts] = mutateVerts(boxLen,pop,idxCanMutate,mutationRate)
%mutate vertices using local constraints on mutation
global pop boundBox;

idxVertNoMutate = cat(2,pop{1}.loaded,pop{1}.fixed);
idxVertCanMutate = setdiff(1:numVerts,idxVertNoMutate);
numVertCanMutate = size(idxVertCanMutate,2);


for i = 1:numMutations
    randTruss = randi(size(idxTrussCanMutate,1));
    idxTruss = idxTrussCanMutate(randTruss);
    randVert = randi(numVertCanMutate);
    idxVert = idxVertCanMutate(randVert);
    
    if(isfield(pop{idxTruss}, 'mutatedVerts'))
        %fprintf('       had mutatedVerts added idxVert:,%d\n',idxVert);
        pop{idxTruss}.mutatedVerts = cat(2,pop{idxTruss}.mutatedVerts,idxVert);
    else
        %fprintf('       new mutatedVerts added idxVert:,%d\n',idxVert);
        pop{idxTruss}.mutatedVerts = idxVert;
    end
    
    pop{idxTruss}.Coord(:,idxVert) = randomVert(pop{idxTruss}.Coord(:,idxVert));
    
    
end

    function newVert = randomVert(initVert)
        mean = 0;
        sD = 2;
        offsets = random('Normal',mean,sD,3,1);
        newVert = offsets+initVert;
        
        %Constrain X to boundBoxX [-30.2,0]
        if(newVert(1)<boundBox(1))
            newVert(1) = boundBox(1);
        elseif newVert(1)>0
            newVert(1) = 0;
        end
        
        %Constrain Y to boundBoxY [0,30]
        if(newVert(2)>boundBox(2))
            newVert(2) = boundBox(2);
        elseif newVert(2)<0
            newVert(2) = 0;
        end
        
        %Constrain Z to boundBoxZ [0,17.8]
        if(newVert(3)>boundBox(3))
            newVert(3) = boundBox(3);
        elseif newVert(3)<0
            newVert(3) = 0;
        end
        
        %disp(newVert);
        
    end


end