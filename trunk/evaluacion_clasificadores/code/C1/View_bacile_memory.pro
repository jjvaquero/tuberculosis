
FUNCTION view_bacile_memory, im_orig, im_mask, n_reg

;---------------------------------------------------------------------------------------
; Función diseñada para visualizar en pantalla un bacilo segmentado y guardado en disco
; Necesita saber el identificador de cultura, el número de imagen y el identificador de
; bacilo
;
; im1 = view_bacile_memory(image_original, image_mask, 23)
;
;
;---------------------------------------------------------------------------------------


;-----------------------------------------------------------------------------
tam = SIZE(im_mask)
xsize = tam[1]
ysize = tam[2]
;-----------------------------------------------------------------------------
pos_pixels = WHERE(im_mask EQ n_reg)
pos_pix    = pos_pixels[0]

pos_pix_xy = INTARR(2)
pos_pix_xy[0] = pos_pix MOD xsize
pos_pix_xy[1] = pos_pix / xsize

box_xmax = pos_pix_xy[0]+128 < (xsize-1)
box_xmin = pos_pix_xy[0]-128 > 0
box_ymax = pos_pix_xy[1]+128 < (ysize-1)
box_ymin = pos_pix_xy[1]-128 > 0

im_mask_frag = im_mask[box_xmin:box_xmax, box_ymin:box_ymax] EQ n_reg
im_orig_frag = im_orig[*, box_xmin:box_xmax, box_ymin:box_ymax]

im_frontier = binreg_frontier(im_mask_frag)

;im_superposition1 = superpone_mask(im_orig_frag, im_mask_frag, COLOR1=[0,0,255], LEVEL=0.5)
im_superposition2 = superpone_mask(im_orig_frag, im_frontier,  COLOR1=[0,0,255], LEVEL=1)

WINDOW,0, XSIZE = 257S*3, YSIZE = 257

TVSCL, im_orig_frag, 0, TRUE=1
TVSCL, im_mask_frag, 1
TVSCL, im_superposition2, 2, TRUE=3
;TVSCL, im_superposition1, 3, TRUE=3, ORDER=order1

RETURN, 1


END