function [a,vs,rho,gamma_p,grado_p,coef_p,kernel_type,param] = rsm_extrae_LIBSVM_model(model)
% EXTRAE_LIBSVM_MODEL - Devuelve los parámetros de la SVM 
% f(x)=sum_i a_i k(x,vs_i) + rho
% 
%  c2=evalua_svm(X_test',vs',sqrt(1/(2*gamma_p))*ones(1,size(vs,1)),as,rho);
kernel_type=model.Parameters(2);
grado_p = model.Parameters(3);
gamma_p = model.Parameters(4);
coef_p = model.Parameters(5);
%sigma_p = sqrt(1/(2*gamma));
rho = model.rho*(model.Label(2));
a = (model.sv_coef)*(model.Label(1));
vs = full(model.SVs);
param.a=a;
param.vs=vs;
param.rho=rho;
param.gamma_p=gamma_p;
param.grado_p=grado_p;
param.coef_p=coef_p;
param.kernel_type=kernel_type;