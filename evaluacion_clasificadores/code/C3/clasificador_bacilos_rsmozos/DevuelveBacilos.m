function [IMBW,y2,y3]=DevuelveBacilos(fil,col,tamVent,pas,desp,y,objects)
% retorna una imagen binaria con los bacilos y elimina los repetidos en y2

IMBW=zeros(fil,col);
IMnumbers=IMBW;
IMnumbers(1:end)=1:numel(IMnumbers);
RejillaBase=enventanaPasadas( IMnumbers , tamVent , 1 , 0 );
y2=y;
indices=find(y>0);
f=floor(fil/tamVent);
c=floor(col/tamVent);
y3=zeros(f*c,1);
AUX=zeros(length(y),2);
[xx,yy]=meshgrid(1:tamVent:fil-tamVent,1:tamVent:col-tamVent);
% AUX has the first pixel in the window
AUX(1:f*c,:)=[xx(:) yy(:)];
[xx,yy]=meshgrid(1:tamVent:fil-2*tamVent,1:tamVent:col-2*tamVent);
for k=2:pas
    AUX(f*c+1+(k-2)*(f-1)*(c-1):f*c+(k-1)*(f-1)*(c-1),:)=[xx(:) yy(:)]+desp*(k-1);
end

for k=1:length(indices)
    %obtener la ventana
    
    for k2=1:length(objects{indices(k)})
       OBJ=objects{indices(k)}{k2}(:,:,1)|objects{indices(k)}{k2}(:,:,2)|objects{indices(k)}{k2}(:,:,3);
       [f2,c2]=find(OBJ);
       f2=f2+AUX(indices(k),1)-1;
       c2=c2+AUX(indices(k),2)-1;
       indicesObjeto=sub2ind(size(IMBW),f2,c2);
       if sum(sum(IMBW(indicesObjeto)))>1
           %objeto repetido.
           y2(indices(k))=y2(indices(k))-1;
       else
           %objeto nuevo
           IMBW(sub2ind(size(IMBW),f2,c2))=1;
           %vemos en qu'e ventana va
          [nada,I]=max(sum(ismember(RejillaBase,indicesObjeto),2));
          y3(I)=y3(I)+1;
       end
    end
end
y2(y2==0)=-1;
y3(y3==0)=-1;
if sum(y2(y2>0)) ~= sum(y3(y3>0))
    keyboard
end