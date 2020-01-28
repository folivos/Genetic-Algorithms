function [individual] = randomIndivid(templateTruss)
%Crea un individuo desde la estructura original, cambiando la posicion de sus
%nodos de manera aleatoria

mean = 0;
sD = 1;

numVerts = size(templateTruss.Coord,2); %numero de nodos. OJO: supone orden, 
%es decir el primer par de coordenadas es el nodo 1 y asi...

noChangeVerts = cat(2, templateTruss.loaded, templateTruss.fixed);%concatena
%y deja en una sola matriz los nodos que estan cargados y los que estan fijos
%para no modificarlos, de tal manera que los que mutan sean los del cuerpo

individual = templateTruss;


for i = 1:numVerts
    if(~any(i==noChangeVerts)) % si no esta el nodo en la lista...
        offset = random('Normal',mean,sD,3,1);%aleatorio normal, media 0 y desv
        %estandar 2, 3 filas, 1 columna
        
        individual.Coord(:,i) = individual.Coord(:,i)+offset;
    end
end

end

