function [costs,currMinFit,avgCost ] = assignCosts(uMult)
%[costs,currMinFIt ] = assignCosts(pop)
%run deflection tests
%calculate weight
%input:
%   pop = cell array of truss structs (genes)
%   numIndivid = number of individuals
%output:
%   costs = [numIndivid x 2] array, first col is the cost, second is the
%           index of that individual
%   currMinFit = lowest cost in the population (!) 
%   avgCost = average cost for the population

global pop numIndivid density;


%CALCULATE DEFLECTION MATRIX (de cada individuo de la poblacion)
uScores = findMaxDeflection(uMult);

%CALCULATE MASS MATRIX (de cada individuo de la poblacion)
mScores = calcMass();

%COMBINE SCORES
costs = NaN(numIndivid,2);
costs(:,1) = uScores(:,1) + mScores(:,1);
costs(:,2) = 1:numIndivid;
costs = sortrows(costs);
currMinFit = costs(1,1);
avgCost = mean(costs(:,1));

end

%---------------------------------------------------------------------------

function [uScores] = findMaxDeflection(uMult)
% [uScores] = calcDeflection(pop)
%output max X deflection^2
%%% later try max deflection of specific point(s?)
%input:
%   pop = cell array of truss structs
%   numIndivid = number of trusses
%output:
%   uScores = [numIdivid x 2], first column is the maximum displacement,
%               second column is the index of that individual
%               NaN if no U scores matrix is available (is NaN)

global pop numIndivid;

uScores = NaN(numIndivid,1); % vector de NaN
for i = 1:numIndivid
    %maximum abosulte val x deflection for a given truss
    U = pop{i}.U;
    if(size(U,1)==3)
        maxU = max(abs(U(1,:)));%aca selecciono el maximo desplz. en x
        uScores(i,1) = maxU*uMult;%se mult. al valor uMult
        %entrega un vector con los desplz maximos en x, para toda una poblac.pop
    end
end

end

%---------------------------------------------------------------------------

function [massScores] = calcMass()

global pop numIndivid density;

massScores = NaN(numIndivid,1);
for i = 1:numIndivid
    hasA = isfield(pop{i}, 'A');
    hasCon = isfield(pop{i}, 'Con');
    hasCoord = isfield(pop{i}, 'Coord');
    
    if(hasA && hasCon && hasCoord)
    areas = pop{i}.A';
    edges = pop{i}.Con; % 2 x nEdges
    verts = pop{i}.Coord;
    
    p1 = verts(:,edges(1,:)); % coordenada inicial del elemento
    p2 = verts(:,edges(2,:)); % coordenada final del elemento
    
    
    dists = distanc(p1,p2); % vector con el largo de los elementos
   

    
    volume = sum(areas.*dists);
    mass = density*volume;

    massScores(i) = mass;
    else
    massScores(i) = NaN;
    end
    
end

end

%---------------------------------------------------------------------------

function d = distanc(p1,p2)
% Eucliden distance between points
% rows: different points
% columns: value of each dimension
%

d = sqrt(sum((p1 - p2).^2, 1));
end


