FUNCTION Binreg_frontier, image_o

;; Función que extrae las FRONTERAS INTERIORES (separaciones) de una imagen binaria (0 y 1)
;;
;;      image   > la imagen de entrada binaria
;;
;;      retorna otra imagen con unos en el contorno de la cuenca
;;


;est=REPLICATE(1,3,3)
est=[[0,1,0],[1,1,1],[0,1,0]]
borde = image_o - erode2_bin(image_o,est)

;borde = WHERE(borde EQ 1)

RETURN, borde

END ; Fronterabin.pro

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
