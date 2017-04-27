stack1	segment	para	stack
sta_are	dw	100h dup(?)
sta_bot	equ	$ - sta_are
stack1	ends

data	segment	para
num	dw	0,0,0,0
res	db	20 dup(0)
switch	dw	0
new_lin	db	0dh,0ah,'$'
info_0	db	'0 : exit',0dh,0ah,'$'
info_1	db	'1 : decimalism to hexadecimal for 16 bits',0dh,0ah,'$'
info_2	db	'2 : hexadecimal to decimalism for 16 bits',0dh,0ah,'$'
info_3	db	'3 :',0dh,0ah,'$'
info_4	db	'4 :',0dh,0ah,'$'
info_5	db	'5 :',0dh,0ah,'$'
info_6	db	'6 :',0dh,0ah,'$'
info_7	db	'please input a number (0-6)',0dh,0ah,'$'
info_8	db	'please input a decimalism number (0-65535):',0dh,0ah,'$'
info_9	db	'please input a hexadecimal number (0-ffff):',0dh,0ah,'$'
err_1	db	'error input',0dh,0ah,'$'
data	ends

code	segment	para
	assume	cs:code,ds:data,es:data,ss:stack1

main	proc	far
	mov	ax,data
	mov	ds,ax
	mov	es,ax
	mov	ax,stack1
	mov	ss,ax
	mov	sp,sta_bot
	
ma_lp1:	
	call	prt_hlp	
	lea	si,switch
	push	si
	call	scf_dw
	
	mov	ax,switch
	cmp	ax,0
	jb	ma_lp1
	cmp	ax,6
	ja	ma_lp1
	cmp	ax,0
	jne	ma_nor
exit:	mov	ax,4c00h
	int	21h
ma_nor:	call	do_swi	
	jmp	ma_lp1
main	endp

;swith function
do_swi	proc
	push	bp
	mov	bp,sp
	mov	ax,switch
	cmp	ax,1
	jne	ds_pl1
	call	do_dwh
ds_pl1:	cmp	ax,2
	jne	ds_pl2
	call	do_hwd
ds_pl2:	cmp	ax,3
	jne	ds_pl3
	
ds_pl3:	cmp	ax,4
	jne	ds_pl4
	
ds_pl4:	cmp	ax,5
	jne	ds_pl5
	
ds_pl5:	cmp	ax,6
	jne	end_ds
	
end_ds:	mov	sp,bp
	pop	bp
	ret
do_swi	endp

;do deca to hex for 16bits
do_dwh 	proc
	push	bp	
	mov	bp,sp
	lea	dx,info_8
	mov	ah,9
	int	21h
	
	lea	si,num
	push	si
	call	scf_dw
	
	lea	si,num
	push	si
	call	prt_wd
	call	prt_nl
	mov	sp,bp
	pop	bp
	ret
do_dwh	endp	

;do hex to deca for 16bits
do_hwd	proc
	push	bp
	mov	bp,sp
	
	mov	sp,bp
	pop	bp
	ret
do_hwd	endp

;read a 16bits decimalism number -> [para1]
scf_dw	proc
	push	bp
	mov	bp,sp
	mov	di,[bp+4]
	mov	word ptr [di],0
si_lp1:	mov	ah,1
	int	21h
	cmp	al,0dh
	je	end_si
	sub	al,30h
	xor	ah,ah
	push	ax
	mov	ax,[di]
	mov	bx,10
	mul	bx
	pop	bx
	add	ax,bx
	mov	[di],ax
	jmp	si_lp1
end_si:	call	prt_nl
	mov	sp,bp	
	pop	bp
	ret	2
scf_dw	endp

;print a 16bits number in [para1] to decimalism
prt_wd	proc
	push	bp
	mov	bp,sp
	mov	si,[bp+4]
	mov	ax,[si]
	mov	bx,0
	push	bx
	mov	bx,10
pi_jp2:	xor	dx,dx
	div	bx
	or	dl,30h
	push	dx
	cmp	ax,0
	jne	pi_jp2
pi_prt:	pop	dx
	cmp	dx,0
	je	pi_end
	mov	ah,2
	int 	21h
	jmp	pi_prt
pi_end:	mov	sp,bp
	pop	bp
	ret	2
prt_wd	endp

;print a 16bits number in [para1] to hex
prt_wh	proc
	push	bp
	mov	bp,sp
	mov	si,[bp+4]
	mov	ax,[si]
	mov	bx,0
	push	bx
	mov	bx,10
pw_1:	xor	dx,dx
	div	bx
	or	dl,30h
	push	dx
	cmp	ax,0
	jne	pw_1
pw_2:	pop	dx
	cmp	dx,0
	je	pw_end
	mov	ah,2
	int 	21h
	jmp	pw_2
pw_end:	mov	sp,bp
	pop	bp
	ret	2
prt_wh	endp

;print help
prt_hlp	proc
	push	bp
	mov	bp,sp
	lea	dx,info_7
	mov	ah,9
	int 	21h	
	lea	dx,info_0	
	int 	21h
	lea	dx,info_1	
	int 	21h
	lea	dx,info_2	
	int 	21h
	lea	dx,info_3	
	int 	21h
	lea	dx,info_4	
	int 	21h
	lea	dx,info_5	
	int 	21h
	lea	dx,info_6
	int	21h
	mov	sp,bp
	pop	bp
	ret
prt_hlp	endp

;print new line
prt_nl proc
	push	bp
	mov	bp,sp
	push	dx
	push	ax
	lea	dx,new_lin
	mov	ah,9
	int	21h
	pop	ax
	pop	dx
	mov	sp,bp
	pop	bp
	ret
prt_nl 	endp

code	ends
	end	main
