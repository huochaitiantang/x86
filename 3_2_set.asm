stack1	segment	para	stack
sta_are	dw	100 dup(?)
sta_bot	equ	$ - sta_are
stack1	ends

data	segment	para
symb	db	'='
switch	dw	0
new_lin	db	0dh,0ah,'$'
info_0	db	'0 for copy str1 to str2',0dh,0ah,'$'
info_1	db	'1 for compare str1 with str2',0dh,0ah,'$'
info_2	db	'2 for insert str1 to str2',0dh,0ah,'$'
info_3	db	'3 for find str1 in str2',0dh,0ah,'$'
info_4	db	'4 for delete str1 in str2',0dh,0ah,'$'
info_5	db	'5 for exit',0dh,0ah,'$'
info_6	db	'str1:','$'
info_7	db	'str2:','$'
info_8	db	'please input str1:',0dh,0ah,'$'
info_9	db	'please input str2:',0dh,0ah,'$'
info_10	db	'please input a int:',0dh,0ah,'$'
info_11	db	'please input a int for insert index:',0dh,0ah,'$'
info_12	db	'input:','$'
str1	db	20h dup(?)
str2	db	20h dup(?)
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
	call	scf_int
	mov	switch,ax
	
;	lea	dx,info_12
;	mov	ah,9
;	int	21h
;	mov	ax,switch
;	call	prt_int
;	call	prt_nl
	
;	mov	ax,switch
	cmp	ax,0
	jb	ma_lp1
	cmp	ax,5
	ja	ma_lp1
	cmp	ax,5
	jne	ma_nor
exit:	mov	ax,4c00h
	int	21h
ma_nor:	call	do_red
	call	do_swi	
	jmp	ma_lp1
main	endp

;read two str
do_red 	proc
	push	bp
	mov	bp,sp
	lea	dx,info_8
	mov	ah,9
	int	21h
	lea	di,str1
	push	di
	call	scf_str
	lea	dx,info_9
	mov	ah,9
	int	21h
	lea	di,str2
	push	di
	call	scf_str	
	mov	sp,bp
	pop	bp
	ret
do_red	endp

;swith function
do_swi	proc
	push	bp
	mov	bp,sp
	mov	ax,switch
	cmp	ax,0
	jne	ds_pl1
	call	do_cpy
ds_pl1:	cmp	ax,1
	jne	ds_pl2
	call	do_cmp
ds_pl2:	cmp	ax,2
	jne	ds_pl3
	call	do_ins
ds_pl3:	cmp	ax,3
	jne	ds_pl4
	call	do_fnd
ds_pl4:	cmp	ax,4
	jne	end_ds
	call	do_del
end_ds:	mov	sp,bp
	pop	bp
	ret
do_swi	endp

;call copy
do_cpy 	proc
	push	bp	
	mov	bp,sp
	lea	si,str1
	lea	di,str2
	push	si
	push	di
	call	cpy_str
	call	do_res
	mov	sp,bp
	pop	bp
	ret
do_cpy	endp	

;call compare
do_cmp	proc
	push	bp
	mov	bp,sp
	lea	si,str1
	lea	di,str2
	push	si
	push	di
	call	cmp_str
	mov	dl,symb
	mov	ah,2
	int	21h
	call	prt_nl
	call	do_res
	mov	sp,bp
	pop	bp
	ret
do_cmp	endp

;call insert
do_ins	proc
	push	bp
	mov	bp,sp
	lea	dx,info_11
	mov	ah,9
	int	21h
	call	scf_int
	mov	bx,ax
	lea	si,str1
	lea	di,str2
	push	si
	push	di
	push	bx
	call	insert
	call	do_res
	mov	sp,bp
	pop	bp
	ret
do_ins	endp

;call find
do_fnd	proc
	push	bp
	mov	bp,sp
	lea	si,str1
	lea	di,str2
	push	si
	push	di
	call	fnd_str
	push	ax
	call	prt_int	
	call	prt_nl		
	call	do_res
	mov	sp,bp
	pop	bp
	ret
do_fnd	endp

;call delete
do_del	proc
	push	bp
	mov	bp,sp
	lea	si,str1
	lea	di,str2
	push	si
	push	di
	call	delete
	call	do_res
	mov	sp,bp
	pop	bp
	ret	
do_del	endp	
	
;call	res
do_res	proc
	push	bp
	mov	bp,sp	
	lea	dx,info_6
	mov	ah,9
	int	21h
	lea	si,str1
	push	si
	call	prt_str
	call	prt_nl
	lea	dx,info_7
	mov	ah,9
	int	21h
	lea	si,str2
	push	si
	call	prt_str
	call	prt_nl
	mov	sp,bp
	pop	bp
	ret
do_res	endp	

;print help
prt_hlp	proc
	push	bp
	mov	bp,sp
	lea	dx,info_10	
	mov	ah,9
	int 21h	
	lea	dx,info_0	
	mov	ah,9
	int 21h
	lea	dx,info_1	
	mov	ah,9
	int 21h
	lea	dx,info_2	
	mov	ah,9
	int 21h
	lea	dx,info_3	
	mov	ah,9
	int 21h
	lea	dx,info_4	
	mov	ah,9
	int 21h
	lea	dx,info_5	
	mov	ah,9
	int 21h
	mov	sp,bp
	pop	bp
	ret
prt_hlp	endp

;print str, addr with para1
prt_str proc
	push	bp
	mov	bp,sp
	mov	ah,2
	mov	si,[bp+4]
ps_lp1:	mov	dl,[si]
	cmp	dl,0	;str end with /0
	je	end_ps
	int	21h
	inc	si
	jmp	ps_lp1	
end_ps:	mov	sp,bp
	pop	bp
	ret	2
prt_str endp

;read str, addr with para1
scf_str proc
	push	bp
	mov	bp,sp
	mov	ah,1
	mov	di,[bp+4]
ss_lp1:	int	21h
	cmp	al,0dh
	je	end_ss
	mov	[di],al
	inc	di
	jmp	ss_lp1
end_ss:	mov	byte ptr [di],0
	call	prt_nl
	mov	sp,bp
	pop	bp
	ret	2
scf_str endp

;lenth of a str, addr with para1
len_str	proc
	push	bp
	mov	bp,sp
	push	si
	push	bx
	mov	si,[bp+4]
	mov	bx,0
ls_lp1:	mov	al,[si]
	cmp	al,0
	je	end_ls
	inc	si
	inc	bx
	jmp	ls_lp1
end_ls:	mov	ax,bx	;answer in the ax
	pop	bx
	pop	si
	mov	sp,bp
	pop	bp
	ret	2
len_str endp

;get a integer to ax
scf_int proc
	push	bp
	mov	bp,sp
	mov	ax,0
	push	ax
si_lp1:	mov	ah,1
	int	21h
	cmp	al,0dh
	je	end_si
	sub	al,30h
	xor	ah,ah
	mov	bx,ax
	pop	ax
	push	bx
	mov	bx,10
	mul	bx
	pop	bx
	add	ax,bx
	push	ax
	jmp	si_lp1
end_si:	pop	ax
	call	prt_nl
	mov	sp,bp	
	pop	bp
	ret
scf_int	endp

;lower to upper ret with ax
lo_up	proc
	push	bp
	mov	bp,sp
	mov	ax,[bp+4]
	cmp	al,'a'
	jb	lu_lp1
	cmp	al,'z'
	ja	lu_lp1
	sub	al,'a'-'A'
lu_lp1:	cmp	ah,'a'
	jb	end_lu
	cmp	ah,'z'
	ja	end_lu
	sub	ah,'a'-'A'
end_lu:	mov	sp,bp
	pop	bp
	ret	2
lo_up	endp

;cmp two str,add with para1,para2
cmp_str	proc
	push	bp	
	mov	bp,sp
	mov	si,[bp+6]
	mov	di,[bp+4]
cs_lp1:	mov	al,[si]
	mov	ah,[di]
	cmp	al,0
	jne	cs_jp1
	cmp	ah,0
	jne	cs_jp2
	jmp	equal	;end at the same lenth with 0
cs_jp1:	cmp	ah,0
	jne	cs_nor	;nor at the end
	jmp	big	;si not end but di end
cs_jp2:	jmp	small	;si end but di not end
cs_nor:	push	ax
	call	lo_up
	cmp	al,ah
	ja	big
	cmp	al,ah
	jb	small		
	inc	si
	inc	di
	jmp	cs_lp1
equal:	mov	symb,'='
	jmp	end_cs
small:	mov	symb,'<'
	jmp	end_cs
big:	mov	symb,'>'
end_cs:	mov	sp,bp
	pop	bp
	ret	4
cmp_str	endp

;copy a str to another str, addr para1 to para2
cpy_str proc
	push	bp
	mov	bp,sp
	mov	si,[bp+6]
	mov	di,[bp+4]
	push	si
	call	len_str
	mov	cx,ax
	inc	cx
	cld		
	rep	movsb
	mov	sp,bp
	pop	bp
	ret	4
cpy_str	endp

;insert str [para1] to another [para2] with index [para3]
insert	proc
	push	bp
	mov	bp,sp
	mov	si,[bp+8]
	mov	di,[bp+6]
	mov	bx,[bp+4]
	push	di
	call	len_str	;chenck lenth of dectection
	cmp	bx,ax	
	ja	end_ins	;if lenth less than index, over
	push	si
	push	bx
	push	di
	mov	cx,ax
	sub	cx,bx	;num of bytes need moved back,lenth of str2 - index + 1(over)
	inc	cx		
	add	di,ax	;di point the tail of str2
	push	si
	call	len_str
	mov	si,di	
	add	di,ax	;ax is the move step,lenth of str1
	std		
	rep	movsb	;move over, gene a empty space
	pop	di
	pop	bx
	pop	si
	mov	cx,ax	;fill the str in the empty space
	add	di,bx
	cld
	rep	movsb
end_ins:mov	sp,bp
	pop	bp
	ret	6
insert	endp

;find str1 [para1] in the str2[para2],index with ax
fnd_str	proc
	push	bp
	mov	bp,sp
	mov	si,[bp+6]
	mov	di,[bp+4]
	push	si
	call	len_str
	push	ax
	push	di
	call	len_str
	mov	cx,ax	;str2 lenth
	pop	ax	;str1 lenth	
	mov	bx,0	;index of str2
fs_lp1:	push	ax
	push	di
	add	di,bx
	push	si
	push	di
	push	ax
	call	cmp_nby
	cmp	ax,0
	jne	fs_cnt
	pop	di
	pop	ax
	mov	ax,bx
	jmp	end_fs
fs_cnt:	pop	di
	pop	ax
	inc	bx
	loop	fs_lp1	
	mov	ax,-1
end_fs:	mov	sp,bp
	pop	bp
	ret	4
fnd_str	endp

;cmp n [para3] bytes with para1 and para2,equal with ax=0
cmp_nby	proc
	push	bp
	mov	bp,sp
	push	cx
	push	di
	push	si
	mov	cx,[bp+4]
	mov	di,[bp+6]
	mov	si,[bp+8]
	mov	ax,1
	cld
cn_lp1:	cmpsb
	jne	cn_end
	loop 	cn_lp1	
	mov	ax,0		
cn_end:	pop	si
	pop	di
	pop	cx
	mov	sp,bp
	pop	bp
	ret	6
cmp_nby	endp

;delete str1[para1] in the str2[para2]
delete	proc
	push	bp
	mov	bp,sp
	mov	si,[bp+6]
	mov	di,[bp+4]
de_lp1:	push	si
	push	di
	call	fnd_str
	mov	si,[bp+6]
	mov	di,[bp+4]
	cmp	ax,0ffffh
	je	end_de	;str2 not include str1,can not del
	push	ax	;index
	push	si
	call	len_str	
	push	ax	;lenth of str1
	push	di
	call	len_str
	mov	cx,ax	;lenth of str2	
	pop	ax	;lenth of str1
	pop	bx	;index
	sub	cx,ax	;cx = len(str2) - len(str1) - index + 1
	sub	cx,bx 
	inc	cx
	add	di,bx	;di = di + index
	mov	si,di	;si = di + index + len(str1)
	add	si,ax
	cld
	rep	movsb
end_de:	mov	sp,bp
	pop	bp
	ret	4
delete	endp

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

;print number in the para1
prt_int proc
	push	bp
	mov	bp,sp
	mov	ax,[bp+4]
	mov	bx,0
	push	bx
	cmp	ax,0ffffh
	je	pi_jp1
	mov	bx,10
pi_jp2:	xor	dx,dx
	div	bx
	or	dl,30h
	push	dx
	cmp	ax,0
	jne	pi_jp2
	jmp	pi_prt
pi_jp1:	xor	bh,bh
	mov	bl,'1'
	push	bx
	mov	bl,'-'
	push	bx
pi_prt:	pop	dx
	cmp	dx,0
	je	pi_end
	mov	ah,2
	int 	21h
	jmp	pi_prt
pi_end:	mov	sp,bp
	pop	bp
	ret	2
prt_int	endp


code	ends
	end	main
