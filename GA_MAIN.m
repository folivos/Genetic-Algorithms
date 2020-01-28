
%function GA_MAIN()

%Cargar las librerias: 
pkg load communications
pkg load statistics
clear all;
close all;
clc;

global pop numIndivid boundBox density;

%% INICIALIZACION DE DATOS GLOBALES
boundBox = [65,65,240]; %XYZ dimensiones maximas donde se moveran los nodos
numIndivid = 96;%240%24%36%48           
%numero de individuos, notar que:
%(numIndivid*ratioParetns)%2 debe ser = 0
density = 7.85/1000; %kg/cm^3 (acero)
ratioParents = (1/3);  %percentage of Parents kept
numKeep = ceil(numIndivid*ratioParents);
mutationRate = .10;
stopCrit = 1*10^-17;                %stopping criterion (error threshold)
offsetMultiplier = 1.6;
displMult = 2;%valor de amplificacion del costo (desplz. y peso)

%% POBLACION INICIAL
pop = cell(numIndivid,1);   % arreglo tipo cell se llama con {}

pop{1} = Estruct_inicial;

for i = 2:numIndivid
    pop{i} = randomIndivid(pop{1});
end

%calcula los .F, .U y .R a todos los reticulados de la poblacion vigente
updateTrusses();

%calcula los costos de deformacion maxima y peso de cada elemento de la 
%poblacion
[costs,currMinFit,avgCost] = assignCosts(displMult);

%selecciona los pares de individuos de la generacion que se van a reproducir
[matePairs] = selMatePairs(costs,numKeep);

%cruza a los padres y reemplaza a los elementos que no se reproducen, con 
%los hijos de los padres mas aptos.
mateTrusses(matePairs,numIndivid,ratioParents);

%realiza la mutacion de los vertices
mutateTrusses(pop,numIndivid,costs,numKeep,mutationRate);
%fprintf('POPULATION SIZE: %d\n',numIndivid);
%fprintf('NUMBER OF PARENTS: %d\n',numKeep);
%fprintf('init Min Cost: %2.4f, avgCost %2.4f\n',currMinFit,avgCost);
numDisplay = 8;
gaPlot = plotGeneration(costs,numKeep,numDisplay);



%RUN OPTIMIZATION LOOP
prevMinFit = Inf;
maxIter = 600;%100%400
minIter = 600;%20%400
currIter = 1;
minCostVec = [];
avgCostVec = [];
%
while(1)
    %ASSIGN COSTS
    updateTrusses();
    [costs,currMinFit,avgCost] = assignCosts(displMult);
    minCostVec = [minCostVec, currMinFit];
    avgCostVec = [avgCostVec, avgCost];
    %VISUALIZE
        
    %plotGeneration(costs,numKeep);
%    fprintf('GENERATION %d\n',currIter);
%    fprintf('   minCost: %2.4f, avgCost %2.5f\n',currMinFit,avgCost);
    %strTitle = ['GENERATION ',num2str(currIter)];
    %uicontrol('Style', 'text',...
    %   'String', strTitle,...
    %   'Units','normalized',...
    %   'Position', [0.9 0.2 0.1 0.1]); 

    %CHECK STOPPING CRITERIA (CONVERGENCE)
    currError = prevMinFit-currMinFit;
    if(currError < stopCrit && currIter>minIter)
        plotGeneration(costs,numKeep,numDisplay);
        fprintf('stop crit met\n');
        break
    elseif(currIter>maxIter)
        plotGeneration(costs,numKeep,numDisplay);
        fprintf('maxIter met\n');
        break
    end
    prevMinFit = currMinFit;

    %SELECT MATE PAIRS
    [matePairs] = selMatePairs(costs,numKeep);

    %MATE (overwrite unfit individualsin pop[])
    mateTrusses(matePairs,numIndivid,ratioParents);

    %MUTATE (overwrites individuals in pop[] with mutated versions)
    mutateTrusses(pop,numIndivid,costs,numKeep,mutationRate);
    
    currIter = currIter + 1;
    
end
genVec = 1:currIter;
figure(3);
plot(genVec,minCostVec,'Marker','.');
title('COSTO MINIMO EN CADA GENERACION');
xlabel('Generacion');
ylabel('Minimo costo');
figure(4);
plot(genVec, avgCostVec,'Marker','o','Color','r');
title('COSTO PROMEDIO EN CADA GENERACION');
xlabel('Generacion');
ylabel('Costo Promedio de la Generacion');


%generation = pop;


fprintf('exited optimization loop');



%end


%---------------------------HIGH LEVEL STRUCTURE---------------------------
%initialize data storage
%create population Array D
%seed with a few parents (rand or imported objs) D

%run optimization loop
%assign Costs D
%run deflection tests D
%run mass tests D
%%% run constraint tests
%-convergence check D
%use most fit individual(s) D
%select mate pairs D
%start with rank pairing D
%mate
%start with single-point cross over
%%% point interpolation
%mutate
%include gene elitism (do not mutate best n genes)


%ouput best individuals
%save obj files
%visualize D

%---------------------------DATA STRUCTURES--------------------------------
%�create history array to save past parents (for visualization )?

%options for fitness data structure:
%1) create seperate fitness array
%2) have fitness variable in each individual <- for now seems good

%GENOME:
%.nodes
%.edges
%.areas
%.F
%.U
%.R

%constant for every genome:
%.elasticmodulus
%.restraints
%.loads

%---------------------------UNRESOLVED HIGHLEVEL---------------------------
%where to include stopping criterion?
%fitness scores:
%are the scores integers or floats??
%are the fitness scores stored in each genome or as a seperate array?

%---------------------------RESOLVED HIGHLEVEL-----------------------------
%DECISION: zero is fittest, Inf unfittest
%DECISION: stopping criterion calculated outside of runGeneration()

