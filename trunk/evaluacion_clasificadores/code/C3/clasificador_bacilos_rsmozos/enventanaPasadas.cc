#include <iostream>
#include "mex.h"
#include <math.h>

using namespace std;

template <class T>
void  enventana(double *solucion, T X, mwSize fi, mwSize co, mwSize di, 
		mwSize ventana, mwSize Nbarridos, mwSize desplazamiento,mwSize filas) {
  register mwIndex i, j, k, k2;
  mwSize nfil, ncol,ventana2,indice,ventanak,filask,desfasedimvec,desfasedimim, 
    m, n,indiceventana;
  
  /*desplazamiento 0 */
  nfil=(mwSize) floor(1.0*fi/ventana);
  ncol=(mwSize) floor(1.0*co/ventana);
  for (m=0;m<di;m++) {
    desfasedimvec=ventana*ventana*m;
    desfasedimim=fi*co*m;
    indice=0;
    for (i=0;i<nfil;i++) {
      for (j=0;j<ncol;j++) { 
	/* primera posición de la ventana */
	indiceventana=ventana*(i+j*fi)+desfasedimim; 
	for (k=0;k<ventana;k++) {
	  ventanak=ventana*k+desfasedimvec;
	  filask=k*fi;
	  for (k2=0;k2<ventana;k2++) {
	    *(solucion + indice + filas*(k2+ventanak)) =
	      *(X + indiceventana + k2 + filask);
	  }
	}
	indice++;
      }
    }
  }
  /*resto de desplazamientos. */
  nfil--;
  ncol--;
  for (n=1;n<Nbarridos;n++) {
    for (m=0;m<di;m++) {
      desfasedimvec=ventana*ventana*m;
      desfasedimim=fi*co*m;
      indice=(nfil+1) * (ncol+1) + (n-1) * nfil * ncol;
      for (i=0;i<nfil;i++) {
	for (j=0;j<ncol;j++) { 
	  /* primera posición de la ventana */
	  indiceventana=ventana*(i+j*fi) + desfasedimim + 
	    n*desplazamiento*(1+fi); 
	  for (k=0;k<ventana;k++) {
	    ventanak=ventana*k+desfasedimvec;
	    filask=k*fi;
	    for (k2=0;k2<ventana;k2++) {
	      *(solucion + indice + filas*(k2+ventanak)) =
		*(X + indiceventana + k2 + filask);
	    }
	  }
	  indice++;
	}
      }
    }
  }
}

void mexFunction(int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[])
{
  double *solucion,*aux;
 mwSize fi,co,di,ventana,Nbarridos,desplazamiento,filas;
  void *X;
mxClassID tipo_datos;
 mwSize *dims, ndims;

 if(nrhs!=4) {
	 mexErrMsgTxt("Four input required: X , tamVent , nPasadas , desp ");
  	} 
 
 
 ndims=mxGetNumberOfDimensions(prhs[0]);
 dims=(mwSize *) mxGetDimensions(prhs[0]);

 fi = dims[0];
 co = (ndims>1) ? dims[1]: 1;
 di = (ndims>2) ? dims[2]: 1;

 tipo_datos=mxGetClassID(prhs[0]);

 X = (void *) mxGetPr(prhs[0]);

 aux = mxGetPr(prhs[1]);
 ventana = (mwSize) aux[0];
 aux = mxGetPr(prhs[2]);
 Nbarridos = (mwSize) aux[0];
 aux = mxGetPr(prhs[3]);
 desplazamiento = (mwSize) aux[0];

 /*salida*/
 filas=(mwSize) int(floor(1.0*fi/ventana)*floor(1.0*co/ventana)+(Nbarridos-1)*(floor(1.0*fi/ventana)-1)*(floor(1.0*co/ventana)-1));

 /* Es mejor hacer esto para no perder tiempo en inicializar a cero la memoria*/
  /* plhs[0] = mxCreateDoubleMatrix(filas,ventana*ventana*di,mxREAL); */
 plhs[0] = mxCreateDoubleMatrix(0,0,mxREAL); /* Creamos un mxArray vacio */

 /*dims[0]=filas;
 dims[1]=ventana*ventana*di; */
/* mxSetDimensions(plhs[0],dims,2);*/ /* Ajustamos los valores del mxArray */
 solucion=(double *) mxMalloc(filas*ventana*ventana*di*((mwSize)sizeof(double)));
 mxSetM(plhs[0],filas);
 mxSetN(plhs[0],ventana*ventana*di);
 mxSetPr(plhs[0],solucion);
 switch (tipo_datos) {
	 case mxUINT8_CLASS:
 enventana(solucion, (unsigned char *) X,fi,co,di,ventana,Nbarridos,desplazamiento,filas);
		 break;
	 case mxDOUBLE_CLASS:
 enventana(solucion, (double *) X,fi,co,di,ventana,Nbarridos,desplazamiento,filas);
 break;
	 default:
 enventana(solucion, (unsigned char *) X,fi,co,di,ventana,Nbarridos,desplazamiento,filas);
		 break;
}
}
