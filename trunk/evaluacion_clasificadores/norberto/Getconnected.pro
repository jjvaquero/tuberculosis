;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; FUNCTION GetConnected, Imag, Conectividad=Conectividad, NumObj=NumObj
;
; PROGRAMADO POR:		José Ignacio Roldán Lozón
; ULT. MODIFICACION:	25/03/98
; VERSION IDL:			5.02
; PROPOSITO:			Distingue los diversos objetos de una imagen binaria
; PARAMETROS:			Imag -> Imagen binaria original
;						Conectividad -> 4 u 8. Por defecto = 8.
;						NumObj -> Devuelve en esta vble el nº de objetos identificados
;						RETURN -> Imagen en los bits de cada objeto separado tiene el valor
;							distinto: 0 = Fondo, Objetos = 1..NumObj
; ALGORITMO:			Rosenfeld y Pfaltz(1966)
; BIBLIOGRAFIA:			Robert M. HARALICK, Linda G. SHAPIRO
;						"Computer and Robot Vision. Volume I"
;						Addison Wesley Publishing Company 1992. Pags 33-37
; COMENTARIOS:			Resulta Lento.
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


FUNCTION GetConnected, Imag, Conectividad=Conectividad, NumObj=NumObj

	; Compruebo Parámetros Externos
	i_Bin = (Imag GE 1)	; Me aseguro de que la imagen sea binaria

	IF (KEYWORD_SET(Conectividad) EQ 0) THEN BEGIN
	   		Conectividad = 8
	ENDIF

	; Obtengo dimensiones de la imagen
	S = SIZE(i_Bin)
	Width = S[1]+2	; +2 para recuadro externo a cero
	Height = S[2]+2

	; Inicializo tabla de equivalencias:
	EqTable = INTARR(1,2)

	; Inicializo Indice de Labels
	Indice = 1

	; Inicializo Labels
	i_Labels = REPLICATE(0, Width, Height)
	i_Labels[1,1] = i_Bin
	;Pasada 1 Arriba->Abajo:
	Unos = WHERE(i_Labels EQ 1)
	i_Labels = REPLICATE(0, Width, Height)
	IF (Unos[0] EQ -1L) THEN BEGIN
		NumObj = 0
		return, i_Bin
	ENDIF
	TotalUnos = (SIZE(Unos))[1]
	A = REPLICATE(0,3,3)

Time0 = SYSTIME(1)
	FOR P = 0L, TotalUnos-1 DO BEGIN
		; Obtengo Label apropiado para el pixel
		Pto = Unos[P]
		Sup = Pto+Width
		Inf = Pto-Width

		A[1] = i_Labels[Sup]
		A[3] = i_Labels[Pto-1]
		A[5] = i_Labels[Pto+1]
		A[7] = i_Labels[Inf]
		IF Conectividad EQ 8 THEN BEGIN
			A[0] = i_Labels[Sup-1]
			A[2] = i_Labels[Sup+1]
			A[6] = i_Labels[Inf-1]
			A[8] = i_Labels[Inf+1]
		ENDIF

		NoCero = WHERE(A NE 0, Count)
		IF (Count EQ 0) THEN BEGIN
			M = Indice
			Indice = Indice + 1
		ENDIF ELSE BEGIN
			M = MIN(A[NoCero])
			IF (MAX(A) NE M) THEN BEGIN
				NewEquiv = WHERE ( A GT M, Count )
				New = REPLICATE(M,Count,2)
				New[*,0] = A[NewEquiv]
				EqTable = [ EqTable, New ]
			ENDIF
		ENDELSE
		i_Labels[Pto] = M
	ENDFOR
Time1 = SYSTIME(1)
print, '     1ª pasada de Getconnected = ', Time1-Time0


	; Resuelve clases equivalentes
	EqFinal = INDGEN(Indice)
	S = SIZE(EqTable)
	N_Equiv = S[1]

	FOR i = 1, N_Equiv-1 DO BEGIN
		EqFinal[EqTable[i,0]] = EqFinal[EqTable[i,0]] < EqTable[i,1]
	ENDFOR
	FOR i = 1, N_Equiv-1 DO BEGIN
		EqFinal[EqTable[i,1]] = EqFinal[EqTable[i,1]] < EqFinal[EqTable[i,0]]
	ENDFOR
	FOR i = 1, Indice-1 DO BEGIN
		EqFinal[i] = EqFinal[i] < EqFinal[EqFinal[i]]
	ENDFOR
	Ind = 1
	FOR i = 1, Indice-1 DO BEGIN
		Aux = WHERE(EqFinal EQ i, Count)
		IF (Count NE 0) THEN BEGIN
			EqFinal[Aux] = Ind
			Ind = Ind + 1
		ENDIF
	ENDFOR


	;Pasada 2 Arriba->Abajo:
	FOR P = 0L, TotalUnos-1 DO BEGIN
		i_Labels[Unos[P]] = EqFinal[i_Labels[Unos[P]]]
	ENDFOR
	i_Labels = i_Labels[1:Width-2,1:Height-2]	; Elimino recuadro de ceros

	NumObj = Ind-1
Time1 = SYSTIME(1)
print, '     Fin de Getconnected = ', Time1-Time0

return, i_Labels
END
