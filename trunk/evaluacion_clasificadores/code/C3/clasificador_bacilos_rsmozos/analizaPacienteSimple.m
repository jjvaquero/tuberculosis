function [salida,objects,patches]=analizaPacienteSimple(directorio,paciente,clasificador1,param1,minPixels,media2,desv2,C2,normalizaC3,C3,objectdetector,visualiza)

salida=[];
objects=[];
patches=[];
dire=dir(directorio);
for o = 1:length(dire)
[PATHSTR,NAME,EXT] = fileparts(dire(o).name);
if strcmp(EXT,'.bmp') && strcmp(paciente,strtok(NAME,'_'))    
dire(o).name                    
[y,y2,obs,patc]=analizaImagenSimple(directorio,dire(o).name,clasificador1,param1,minPixels,media2,desv2,C2,normalizaC3,C3,objectdetector,visualiza);
salida=[salida;y2];
obs=obs(y>0);
for k=1:length(obs)
    for k2=1:length(obs{k})
objects=[objects;obs{k}{k2}(:)'];
    end
end
patches=[patches; patc];
end
end

