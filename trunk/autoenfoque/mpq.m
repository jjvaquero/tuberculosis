function m=m(p,q,L)

% Computation of central moment  \mu{pq} of the image L
% (16.3.95)

if p+q == 1  m=0; %Los momentos centrales de orden 1 son cero
else
 
 [n1,n2]=size(L);

 m00 =sum(sum(L)); 
 w=linspace(1,n2,n2); 
 v=linspace(1,n1,n1);
 tx=(sum(L*w'))/m00;    %Momento m10 definido como sum(xf(x,y))
 ty=(sum(v*L))/m00;     
 a=(w-tx).^p;           %w y v equivalen a los puntos x e y
 c=(v-ty).^q;
 m=c*L*a';   
end;


