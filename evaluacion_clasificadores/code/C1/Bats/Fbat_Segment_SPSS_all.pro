
;fbat_Segment_SPSS_all

PRO fbat_segment_spss_all

;Ojo, aqui se pretende pasar por la trituradora a un monton de imagenes
;---------------------------------------------------------------------

opt_segment = 1
opt_measure = 1

positive_begin = 2	;  1 a 3
positive_end   = 3  ;

negative_begin = 1  ; 1 a 41
negative_end   = 41

;---------------------------------------------------------------------

T =SYSTIME(1)

culture_pos = STRARR(3)

culture_pos[0] ='13_10_01'
culture_pos[1] ='21_09_01'
culture_pos[2] ='27_09_01'

culture_neg = STRARR(41)

culture_neg[0] ='123139'
culture_neg[1] ='123210'
culture_neg[2] ='123930'
culture_neg[3] ='123931'
culture_neg[4] ='123944'
culture_neg[5] ='123945'
culture_neg[6] ='123950'
culture_neg[7] ='123986'
culture_neg[8] ='124042'
culture_neg[9] ='124206'

culture_neg[10] ='126711'
culture_neg[11] ='126734'
culture_neg[12] ='126738'
culture_neg[13] ='126752'
culture_neg[14] ='126790'
culture_neg[15] ='126818'
culture_neg[16] ='126930'
culture_neg[17] ='126951'
culture_neg[18] ='126985'
culture_neg[19] ='127011'

culture_neg[20] ='127653'
culture_neg[21] ='127667'
culture_neg[22] ='127668'
culture_neg[23] ='127670'
culture_neg[24] ='127673'
culture_neg[25] ='127685'
culture_neg[26] ='127686'
culture_neg[27] ='127708'
culture_neg[28] ='127714'
culture_neg[29] ='127776'

culture_neg[30] ='127812'
culture_neg[31] ='127817'
culture_neg[32] ='127819'
culture_neg[33] ='127820'
culture_neg[34] ='127855'
culture_neg[35] ='127857'
culture_neg[36] ='127858'
culture_neg[37] ='127859'
culture_neg[38] ='127860'
culture_neg[39] ='127861'
culture_neg[40] ='A-1'

;---------------------------------------------------------------------------

IF opt_segment EQ 1 THEN BEGIN
	FOR j=positive_begin-1, positive_end-1 DO BEGIN
		ok = FBatch_Baciles_Segment_1(CULTURE=culture_pos[j])
	ENDFOR

	FOR i=negative_begin-1, negative_end-1 DO BEGIN
		ok = FBatch_Baciles_Segment_1(CULTURE=culture_neg[i])
	ENDFOR
ENDIF

IF opt_measure EQ 1 THEN BEGIN
	FOR j=positive_begin-1, positive_end-1 DO BEGIN
		;ok = Fbatch_baciles_toSPSS_1(CULTURE=culture_pos[j], /MARKED, /SIMPLE)
		;ok = Fbatch_baciles_toSPSS_1(CULTURE=culture_pos[j], /MARKED, /MOMENTS)
		;ok = Fbatch_baciles_toSPSS_1(CULTURE=culture_pos[j], /MARKED, /ADVANCED)
		;ok = Fbatch_baciles_toSPSS_1(CULTURE=culture_pos[j], /MARKED, /SIMPLE, /ADVANCED)
		ok = Fbatch_baciles_toSPSS_1(CULTURE=culture_pos[j], /MARKED, /SIMPLE, /ADVANCED, /MOMENTS)
	ENDFOR

	FOR i=negative_begin-1, negative_end-1 DO BEGIN
		;ok = Fbatch_baciles_toSPSS_1(CULTURE=culture_neg[i], /SIMPLE)
		;ok = Fbatch_baciles_toSPSS_1(CULTURE=culture_neg[i], /MOMENTS)
		;ok = Fbatch_baciles_toSPSS_1(CULTURE=culture_neg[i], /ADVANCED)
		;ok = Fbatch_baciles_toSPSS_1(CULTURE=culture_neg[i], /SIMPLE, /ADVANCED)
		ok = Fbatch_baciles_toSPSS_1(CULTURE=culture_neg[i], /SIMPLE, /ADVANCED, /MOMENTS)
	ENDFOR
ENDIF

PRINT, '----------------------------------------------------------------'
PRINT, 'TIEMPO TOTAL  :', SYSTIME(1) - T
PRINT, '----------------------------------------------------------------'

END