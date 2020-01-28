function D=Estruct_inicial
%  Definicion de la estructura inicial
pkg load io
pkg load windows 


% Definicion de coordenadas, conectividad y restrains
Coord = xlsread('Joint Coordinates.xlsx',1,'B4:D19');
Con = xlsread('Connectivity - Frame.xlsx',1,'B4:C41');


%Re=zeros(size(Coord));
%Re(1:4,:)=[1 1 1;1 1 1;1 1 1;1 1 1];
fixed = [1,2,3,4];
sizeNodes = size(Coord);
Re = zeros(sizeNodes); %start with all nodes free in all directions.
Re(fixed,:) = ones(size(fixed,2),3); %1 = fixed, 0 = free


% Definicion de las cargas en los nodos
Load=zeros(size(Coord));
Load(13,:)=[50 50 -50];
Load(14,:)=[50 50 -50];
Load(15,:)=[50 50 -50];
Load(16,:)=[50 50 -50];

loaded = [13, 14, 15, 16];
forces = [50 50 -50; 50 50 -50; 50 50 -50; 50 50 -50];

% Definicion del modulo de elasticidad
E=ones(1,size(Con,1))*2038901;

% Definicion del area
A = xlsread('Frame Section Area.xlsx',1,'B4:B41')'; %traspuesta

% Convertir a un arreglo del tipo struct
D=struct('Coord',Coord','Con',Con','Re',Re','Load',Load','E',E','A',A');

%Agregamos los nodos especificos para ocuparlos luego en la funcion 
%que genera la primera poblacion aleatoria
%loaded[] fixed[] y forces[]Estr
D.fixed = fixed;
D.loaded = loaded;
D.forces = forces;

#{


#}