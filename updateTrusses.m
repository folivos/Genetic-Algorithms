function updateTrusses()
%analiza el reticulado usando el metodo de rigidez directa con la funcion
%analyizeTruss, la que entrega las fuerzas en los elementos F,
%los desplazamientos en los nodos U, y las reacciones en los nodos de apoyo R.

%La funcion updateTrusses le agrega el .F, .U y .R a todos los reticulados
%que han sido analizados.

global pop numIndivid;
for i = 1:numIndivid
    %truss = trusses{i};
    [F, U, R] = analyizeTruss(pop{i});
    pop{i}.F = F;
    pop{i}.U = U;
    pop{i}.R = R;
end

end



