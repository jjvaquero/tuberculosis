function out = distancia_vecino_knn(varargin)

%La función distancia_vecino_knn(xi,xj) determina la distancia al vecino 
%más próximo de cada elemento de xi respecto al vector xj.
%distancia_vecino_knn(xi) -> determinar la distancia al vecino más próximo de
%cada elemento de xi respecto a si mismo.

if (nargin==1)
    
    %se dese determinar la distancia al vecino más próximo de cada elemento de xi
    %respecto a si mismo.
    
    xi = varargin{1};
    distancia = zeros(size(xi));
    vectorOrdenado = sort(xi);
    shiftDerecha   = [vectorOrdenado(2) vectorOrdenado(1:end-1)];
    shiftIzquierda = [vectorOrdenado(2:end) vectorOrdenado(end-1)];
    
    dd = abs(vectorOrdenado - shiftDerecha);
    di = abs(vectorOrdenado - shiftIzquierda);
    D  = dd - di;
    indices_derecha   = find(D<=0);
    indices_izquierda = find(D>0);
    distancia(indices_derecha)   = dd(indices_derecha);
    distancia(indices_izquierda) = di(indices_izquierda);
    
    
    
elseif (nargin==2)

    %se dese determinar la distancia al vecino más próximo de cada elemento de xi
    %respecto al vector xj.
    
    xi = varargin{1};
    xj = varargin{2};
    distancia = zeros(size(xi));
    long_xi = length(xi);
    vector = [xi xj];
    [vectorOrdenado ind] = sort(vector);
    indices_xj = find(ind > long_xi);
    n = 1;
    
    for i = 1:length(vectorOrdenado)
       
        if(ind(i)>long_xi)
            continue;
        end
        
        derecha   = find(indices_xj > i);
        izquierda = find(indices_xj < i);
        
        if(~isempty(derecha))
            der = ind(indices_xj(derecha(1)));
        else
            der = ind(indices_xj(izquierda(end))); 
        end
        
        if (~isempty(izquierda))
            izq = ind(indices_xj(izquierda(end)));
        else
            izq = ind(indices_xj(derecha(1)));
        end
        
        dd = abs(vectorOrdenado(i) - vector(der));
        di = abs(vectorOrdenado(i) - vector(izq));
        
        d = dd - di;
        
        if (d<=0)
           
            distancia(n) = dd;
            
        else
            
            distancia(n) = di;
            
        end
        
        n = n + 1;
        
    end
    
end
    
out = distancia;
