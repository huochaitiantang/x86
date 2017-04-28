stack1	segment	para	stack
sta_are	dw	100h dup(?)
sta_bot	equ	$ - sta_are
stack1	ends

data	segment	para
num	dw	4 dup(0)
tmp	dw	4 dup(0)
switch	dw	4 dup(0)
op_1	dw	4 dup(0)
op_2	dw	4 dup(0)
ans	dw	4 dup(0)
modans	dw	4 dup(0)
new_lin	db	0dh,0ah,'$'
info_0	db	'  7 : Exit',0dh,0ah,'$'
info_1	db	'  1 : Dec to Hex [64 bit]',0dh,0ah,'$'
info_2	db	'  2 : Hex to Dec [64 bit]',0dh,0ah,'$'
info_3	db	'  3 : [64 bit] ADD [64 bit]',0dh,0ah,'$'
info_4	db	'  4 : [64 bit] SUB [64 bit]',0dh,0ah,'$'
info_5	db	'  5 : [32 bit] MUL [32 bit]',0dh,0ah,'$'
info_6	db	'  6 : [64 bit] DIV [16 bit]',0dh,0ah,'$'
info_7	db	'Please input a number (1-7)',0dh,0ah,'$'
info_8	db	'Please input a decimalism number (0-18446744073709551615):',0dh,0ah,'$'
info_9	db	'Please input a hexadecimal number (0-ffffffffffffffff):',0dh,0ah,'$'
info_10	db	'>>  ','$'
info_11	db	'Please input opt_1 (0-18446744073709551615):',0dh,0ah,'$'
info_12	db	'Please input opt_2 (0-18446744073709551615):',0dh,0ah,'$'
info_13	db	'Please input opt_1 (0-4294967295):',0dh,0ah,'$'
info_14	db	'Please input opt_2 (0-4294967295):',0dh,0ah,'$'
info_15	db	'Please input opt_2 (1-65535):',0dh,0ah,'$'
fun_ind	dw	6 dup(?)
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
	lea	si,do_dh
	mov	fun_ind,si
	lea	si,do_hd
	mov	fun_ind+2,si
	lea	si,do_add
	mov	fun_ind+4,si
	lea	si,do_sub
	mov	fun_ind+6,si
	lea	si,do_mul
	mov	fun_ind+8,si
	lea	si,do_div
	mov	fun_ind+10,si
ma_lp1:	call	prt_hlp	
	lea	si,switch
	push	si
	call	scf_d	
	mov	ax,switch+6
	cmp	ax,1
	jb	ma_lp1
	cmp	ax,7
	ja	ma_lp1
	cmp	ax,7
	jne	ma_nor
exit:	mov	ax,4c00h
	int	21h
ma_nor:	call	do_swi	
	jmp	ma_lp1
main	endp

;####################### switch part ################################
;swith function
do_swi	proc
	push	bp
	mov	bp,sp
	mov	ax,switch+6
	sub	ax,1
	mov	bx,2
	mul	bx
	lea	si,fun_ind
	add	si,ax
	call	[si]
end_ds:	mov	sp,bp
	pop	bp
	ret
do_swi	endp

;do deca to hex
do_dh 	proc
	push	bp	
	mov	bp,sp
	lea	dx,info_8
	mov	ah,9
	int	21h	
	lea	si,num
	push	si
	call	scf_d
	lea	dx,info_10
	mov	ah,9
	int	21h
	lea	si,num
	push	si
	call	prt_h
	mov	dl,'h'	;tail with h
	mov	ah,2
	int	21h
	call	prt_nl
	mov	sp,bp
	pop	bp
	ret
do_dh	endp	

;do hex to deca
do_hd	proc
	push	bp
	mov	bp,sp
	lea	dx,info_9
	mov	ah,9
	int	21h	
	lea	si,num
	push	si
	call	scf_h
	lea	dx,info_10
	mov	ah,9
	int	21h
	lea	si,num
	push	si
	call	prt_d
	call	prt_nl
	mov	sp,bp
	pop	bp
	ret
do_hd	endp

; do add
do_add	proc	
	push	bp
	mov	bp,sp
	lea	dx,info_11
	mov	ah,9
	int	21h
	lea	si,op_1	
	push	si
	call	scf_d
	lea	dx,info_12
	mov	ah,9
	int	21h
	lea	si,op_2
	push	si
	call	scf_d
	call	op_add
	lea	dx,info_10
	mov	ah,9
	int	21h
	lea	si,ans
	push	si
	call	prt_d
	call	prt_nl
	mov	sp,bp
	pop	bp	
	ret
do_add	endp

; do sub
do_sub	proc
	push	bp
	mov	bp,sp
	lea	dx,info_11
	mov	ah,9
	int	21h
	lea	si,op_1	
	push	si
	call	scf_d
	lea	dx,info_12
	mov	ah,9
	int	21h
	lea	si,op_2
	push	si
	call	scf_d
	call	op_sub
	lea	dx,info_10
	mov	ah,9
	int	21h
	lea	si,ans
	push	si
	call	prt_d
	call	prt_nl
	mov	sp,bp
	pop	bp	
	ret
do_sub	endp

;do mul
do_mul	proc
	push	bp
	mov	bp,sp
	lea	dx,info_13
	mov	ah,9
	int	21h
	lea	si,op_1	
	push	si
	call	scf_d
	lea	dx,info_14
	mov	ah,9
	int	21h
	lea	si,op_2
	push	si
	call	scf_d
	call	op_mul
	lea	dx,info_10
	mov	ah,9
	int	21h
	lea	si,ans
	push	si
	call	prt_d
	call	prt_nl
	mov	sp,bp
	pop	bp	
	ret
do_mul	endp

;do div
do_div	proc
	push	bp
	mov	bp,sp
	lea	dx,info_11
	mov	ah,9
	int	21h
	lea	si,op_1	
	push	si
	call	scf_d
	lea	dx,info_15
	mov	ah,9
	int	21h
	lea	si,op_2
	push	si
	call	scf_d
	call	op_div
	lea	dx,info_10
	mov	ah,9
	int	21h
	lea	si,ans
	push	si
	call	prt_d
	call	prt_nl
	lea	dx,info_10
	mov	ah,9
	int	21h
	lea	si,modans
	push	si
	call	prt_d
	call	prt_nl
	mov	sp,bp
	pop	bp	
	ret
do_div	endp

;####################### scanf part ################################
;clear a 64bits [para1]
clear	proc
	push	bp
	mov	bp,sp
	push	si
	mov	si,[bp+4]
	mov	word ptr [si],0
	mov	word ptr [si+2],0
	mov	word ptr [si+4],0
	mov	word ptr [si+6],0
	pop	si
	mov	sp,bp
	pop	bp	
	ret	2
clear	endp

;64bits[para1] add 16bits para2 to 64bits[para1]
add_61	proc
	push	bp
	mov	bp,sp
	push	si
	push	bx
	mov	si,[bp+6]
	mov	bx,[bp+4]
	add	[si+6],bx
	adc	word ptr [si+4],0
	adc	word ptr [si+2],0
	adc	word ptr [si],0 
	pop	bx
	pop	si	
	mov	sp,bp
	pop	bp
	ret	4
add_61	endp

;mul 64bits num[para1] and a 16bits para2 to tmp
mul_61	proc
	push	bp
	mov	bp,sp
	mov	si,[bp+6]
	mov	bx,[bp+4]
	mov	ax,[si+6]
	mul	bx
	mov	tmp+6,ax
	mov	tmp+4,dx
	mov	ax,[si+4]
	mul	bx
	add	tmp+4,ax
	adc	dx,0
	mov	tmp+2,dx
	mov	ax,[si+2]
	mul	bx
	add	tmp+2,ax
	adc	dx,0
	mov	tmp,dx
	mov	ax,[si]
	mul	bx
	add	tmp,ax	
	mov	sp,bp
	pop	bp
	ret	4
mul_61	endp

;scanf a decimalism 64bits number, to [para1]
scf_d	proc
	push	bp
	mov	bp,sp
	mov	si,[bp+4]
	push	si
	call	clear		;clear to 0
sd_1:	mov	ah,1
	int	21h	
	cmp	al,0dh
	je	end_sd
	call	ax_vl
	push	ax
	mov	si,[bp+4]
	push	si
	mov	bx,10
	push	bx
	call	mul_61		;num * 10 -> tmp
	pop	ax	
	lea	si,tmp
	push	si
	push	ax
	call	add_61		;tmp = tmp + ax
	lea	si,tmp
	push	si
	mov	si,[bp+4]
	push	si
	call	cp_num		;num = tmp
	jmp	sd_1	
end_sd:	call	prt_nl
	mov	sp,bp
	pop	bp
	ret	2
scf_d	endp

;handle al to value instead of char,30h->0,a->10
ax_vl	proc
	push	bp
	mov	bp,sp
	xor	ah,ah
	cmp	al,30h
	jb	end_ax
	cmp	al,39h
	ja	ax_1
	sub	al,30h		;0-9 sub 30h
	jmp	end_ax	
ax_1:	cmp	al,'a'
	jb	end_ax
	cmp	al,'f'
	ja	end_ax
	sub	al,'a'
	add	al,10		;a-f sub 'a' + 10
end_ax:	mov	sp,bp
	pop	bp	
	ret
ax_vl	endp

;scanf a hexadecimal 64bits number, to [para1]
scf_h	proc
	push	bp
	mov	bp,sp
	mov	si,[bp+4]
	push	si
	call	clear		;clear to 0
sh_1:	mov	ah,1
	int	21h	
	cmp	al,0dh
	je	end_sh
	call	ax_vl
	push	ax
	mov	si,[bp+4]
	push	si
	mov	bx,16
	push	bx
	call	mul_61		;num * 10 -> tmp
	pop	ax	
	lea	si,tmp
	push	si
	push	ax
	call	add_61		;tmp = tmp + ax
	lea	si,tmp
	push	si
	mov	si,[bp+4]
	push	si
	call	cp_num		;num = tmp
	jmp	sh_1	
end_sh:	call	prt_nl
	mov	sp,bp
	pop	bp
	ret	2
scf_h	endp
;####################### print part ################################
;judge a 64bits number if 0, addr with [para1]
is_0	proc
	push	bp
	mov	bp,sp
	push	si
	mov	si,[bp+4]
	mov	ax,[si]	
	cmp	ax,0
	jne	not_0
	mov	ax,[si+2]
	cmp	ax,0
	jne	not_0
	mov	ax,[si+4]
	cmp	ax,0
	jne	not_0
	mov	ax,[si+6]
	cmp	ax,0
	jne	not_0
	mov	ax,0	;all 64bits is 0
	jmp	end_is
not_0:	mov	ax,1
end_is:	pop	si
	mov	sp,bp
	pop	bp
	ret	2
is_0	endp

;copy a 64bits number from [para1] to [para2]
cp_num	proc
	push	bp
	mov	bp,sp
	push	ax
	push	si
	push	di
	mov	si,[bp+6]
	mov	di,[bp+4]
	mov	ax,[si]
	mov	[di],ax
	mov	ax,[si+2]
	mov	[di+2],ax
	mov	ax,[si+4]
	mov	[di+4],ax
	mov	ax,[si+6]
	mov	[di+6],ax
	pop	di
	pop	si
	pop	ax
	mov	sp,bp
	pop	bp
	ret	4
cp_num	endp

;tmp 64bits div 16bit number para1, ans to tmp, mod to dx
tp_div	proc
	push	bp
	mov	bp,sp
	mov	bx,[bp+4]
	xor	dx,dx
	mov	ax,tmp
	div	bx
	mov	tmp,ax
	mov	ax,tmp+2
	div	bx
	mov	tmp+2,ax
	mov	ax,tmp+4
	div	bx
	mov	tmp+4,ax
	mov	ax,tmp+6
	div	bx
	mov	tmp+6,ax	
	mov	sp,bp
	pop	bp
	ret	2	
tp_div	endp

;print a number in [para1] to decimalism, at most 64bits
prt_d	proc
	push	bp
	mov	bp,sp
	mov	si,[bp+4]	;addr of number
	push	si
	lea	di,tmp
	push	di
	call	cp_num		;cpy num to tmp
	mov	cx,0
	push	cx		;sign for char end
pd_1:	mov	bx,10	
	push	bx
	call	tp_div		;tmp / bx and res to tmp, mod to dx	
	or	dl,30h
	push	dx
	lea	si,tmp
	push	si
	call	is_0
	cmp	ax,0
	jne	pd_1
pd_2:	pop	dx
	cmp	dx,0
	je	end_pd
	mov	ah,2
	int	21h
	jmp	pd_2		
end_pd:	mov	sp,bp
	pop	bp
	ret	2
prt_d	endp

;print a number in [para1] to hexadecimal, at most 64bits
prt_h	proc
	push	bp
	mov	bp,sp
	mov	si,[bp+4]	;addr of number
	push	si
	lea	di,tmp
	push	di
	call	cp_num		;cpy num to tmp
	mov	cx,0
	push	cx		;sign for char end
ph_1:	mov	bx,16	
	push	bx
	call	tp_div		;tmp / bx and res to tmp, mod to dx	
	cmp	dl,10
	ja	ph_2
	or	dl,30h
	jmp	ph_3
ph_2:	sub	dl,10		;char more than 9
	add	dl,'a'
ph_3:	push	dx
	lea	si,tmp
	push	si
	call	is_0
	cmp	ax,0
	jne	ph_1
ph_:	pop	dx
	cmp	dx,0
	je	end_ph
	mov	ah,2
	int	21h
	jmp	ph_		
end_ph:	mov	sp,bp
	pop	bp
	ret	2
prt_h	endp

;####################### add part ################################
; 64bits + 64bits in op_1 and op_2 to ans
op_add	proc
	push	bp
	mov	bp,sp
	lea	si,ans
	push	si
	call	clear
	mov	ax,op_1+6
	add	ax,op_2+6
	adc	ans+4,0
	add	ans+6,ax
	mov	ax,op_1+4
	add	ax,op_2+4
	adc	ans+2,0
	add	ans+4,ax
	mov	ax,op_1+2
	add	ax,op_2+2
	adc	ans,0
	add	ans+2,ax
	mov	ax,op_1
	add	ax,op_2
	add	ans,ax
	mov	sp,bp
	pop	bp
	ret	
op_add	endp

;####################### sub part ################################
; 64bits - 64bits in op_1 and op_2 to ans
op_sub	proc
	push	bp
	mov	bp,sp
	lea	si,ans
	push	si
	call	clear
	lea	si,op_1
	push 	si
	lea	si,ans
	push	si
	call	cp_num
	mov	ax,op_2+6
	sub	ans+6,ax
	mov	ax,op_2+4
	sbb	ans+4,ax
	mov	ax,op_2+2
	sbb	ans+2,ax
	mov	ax,op_2
	sbb	ans,ax
	mov	sp,bp
	pop	bp
	ret	
op_sub	endp

;####################### mul part ################################
; 32bits x 32bits in op_1 and op_2 to ans
op_mul	proc
	push	bp
	mov	bp,sp
	lea	si,ans
	push	si
	call	clear
	mov	ax,op_1+6
	mov	bx,op_2+6
	mul	bx
	mov	ans+6,ax
	mov	ans+4,dx
	mov	ax,op_1+4
	mul	bx
	add	ans+4,ax
	adc	ans+2,dx
	adc	word ptr ans,0
	mov	ax,op_1+6
	mov	bx,op_2+4
	mul	bx
	add	ans+4,ax
	adc	ans+2,dx
	adc	word ptr ans,0
	mov	ax,op_1+4
	mul	bx
	add	ans+2,ax
	adc	ans,dx
	mov	sp,bp
	pop	bp
	ret	
op_mul	endp

;####################### div part ################################
; 64bits - 64bits in op_1 and op_2 to ans
op_div	proc
	push	bp
	mov	bp,sp
	lea	si,ans
	push	si
	call	clear
	lea	si,modans
	push	si
	call	clear
	lea	si,op_1
	push	si
	lea	si,tmp
	push	si
	call	cp_num
	mov	bx,op_2+6
	push	bx
	call	tp_div
	lea	si,tmp
	push	si
	lea 	si,ans
	push	si
	call	cp_num
	mov	modans+6,dx
	mov	sp,bp
	pop	bp
	ret	
op_div	endp

;####################### other part ################################
;print help
prt_hlp	proc
	push	bp
	mov	bp,sp
	lea	dx,info_7
	mov	ah,9
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
	int 	21h
	lea	dx,info_0
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
