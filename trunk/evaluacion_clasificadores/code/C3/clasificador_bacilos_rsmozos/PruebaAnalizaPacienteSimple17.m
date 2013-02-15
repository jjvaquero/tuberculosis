% pruebaAnalizaImagenSimple
%load TrainOtherFeaturesBase5_RSM1_cm modelF_F2_F4_F6 mediaF_F2_F4_F6 desvF_F2_F4_F6
load _aux modelF_F2_F4_F6 mediaF_F2_F4_F6 desvF_F2_F4_F6
modelL=load(['Base5_RSM1_2nd_class_gauss_alldims_no_weights_' num2str(1)]);
class3=modelL.model;
class2=modelF_F2_F4_F6;
media2=mediaF_F2_F4_F6;
desv2=desvF_F2_F4_F6;
minPixels=20;
normalizacion3.tipo=1;

[alfas,vs,rho,gamma_p,grado_p,coef_p,kernel_type] = rsm_extrae_LIBSVM_model(class2);
t.kernel=kernel_type;
t.g=gamma_p; 
t.c=coef_p;
t.d=grado_p;
C2.t=t;
C2.VS=full(vs');
C2.rho=rho;
C2.alfas=alfas;

[alfas,vs,rho,gamma_p,grado_p,coef_p,kernel_type] = rsm_extrae_LIBSVM_model(class3);
t.kernel=kernel_type;
t.g=gamma_p; 
t.c=coef_p;
t.d=grado_p;
C3.t=t;
C3.VS=full(vs');
C3.rho=rho;
C3.alfas=alfas;

%directorio='C:\bacilos\bacilos\data\data\pacientesMuestreados\negativasTrain';
directorio='/home/rsmozos/Ricardo/bacilos/pacientesMuestreado/positivos/train/32742'
%pacientes={'29994'  '30207'   '30214'  '30261' ... 
%'30262' '30304' '30619' '30663' '30783' '30825' '30855' '30877' '30880' ...
%'30881' '30911' '30986' '30998' '31060' '31230' '31245' '31522' '31547' '31549' ...
%'31934' '32111' '32497' '32550' '32642' '32688' '32748' '32750' '32955' '38841' '51523'};

pacientes={'32742'};

ynt=cell(1,length(pacientes));
for k=1:length(pacientes)
    paciente=pacientes{k};
visualiza=1;
tic,ynt{k}=analizaPacienteSimple(directorio,paciente,@RSM1,[],minPixels,media2,desv2,C2,normalizacion3,C3,@rsm_image_objects5,visualiza);toc
%pause
end

directorio='G:\bacilos\bacilos\data\data\pacientesMuestreados\negativasTest';
pacientesT={ '30257' '30266' '30295' '30665' '30725' '31228' '31523' '31534'...
    '31684' '31819' '32240' '32633' '32781' '32956' '36856'};
ynT=cell(1,length(pacientesT));
for k=1:length(pacientesT)
    paciente=pacientesT{k};
visualiza=0;
tic,ynT{k}=analizaPacienteSimple(directorio,paciente,@RSM1,[],minPixels,media2,desv2,C2,normalizacion3,C3,@rsm_image_objects5,visualiza);toc
%pause
end

save PruebaAnalizaPacienteSimple17 y*
load PruebaAnalizaPacienteSimple17
pacientes={'29994'  '30207'   '30214'  '30261' ... 
'30262' '30304' '30619' '30663' '30783' '30825' '30855' '30877' '30880' ...
'30881' '30911' '30986' '30998' '31060' '31230' '31245' '31522' '31547' '31549' ...
'31934' '32111' '32497' '32550' '32642' '32688' '32748' '32750' '32955' '38841' '51523'};
pacientesT={ '30257' '30266' '30295' '30665' '30725' '31228' '31523' '31534'...
    '31684' '31819' '32240' '32633' '32781' '32956' '36856'};
elements=unique([unique(cell2mat(ynt(:)));unique(cell2mat(ynT(:)));1]);
Rt=[];
RT=[];


for k=1:length(pacientes)
    Rt(k,:)=hist(ynt{k},elements);
end
for k=1:length(pacientesT)
    RT(k,:)=hist(ynT{k},elements);
end

filename='PruebaAnalizaPacienteSimple.xls';
labelx=rsm_num2cellstr(elements);
labely=[pacientes pacientesT]';
rsm_write_xls_table(filename,labelx,labely,'objects5_20_RSM1_base5',[Rt; RT])
