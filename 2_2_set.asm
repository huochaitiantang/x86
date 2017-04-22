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
	
	call	prt_hlp	
ma_lp1:	
	call	scf_int
	mov	switch,ax
	
	lea	dx,info_12
	mov	ah,9
	int	21h
	mov	ax,switch
	call	prt_int
	call	prt_nl
	
	mov	ax,switch
	cmp	ax,0
	jb	ma_lp1
	cmp	ax,5
	ja	ma_lp1
	cmp	ax,5
	jne	ma_nor
exit:	mov	ax,4c00h
	int	21h

	;read two str
ma_nor:	lea	dx,info_8
	mov	ah,9
	int	21h
	lea	di,str1
	call	scf_str
	lea	dx,info_9
	mov	ah,9
	int	21h
	lea	di,str2
	call	scf_str	

	mov	ax,switch
	cmp	ax,0
	je	do_cpy
	cmp	ax,1
	je	do_cmp
	cmp	ax,2
	je	do_ins
	cmp	ax,3
	je	do_fnd
	cmp	ax,4
	je	do_del
	jmp	ma_lp1

do_cpy:	;copy str1 to str2
	lea	si,str1
	lea	di,str2
	call	cpy_str
	jmp	do_res	

do_cmp:	;compare two str
	lea	si,str1
	lea	di,str2
	call	cmp_str
	mov	dl,symb
	mov	ah,2
	int	21h
	call	prt_nl
	jmp	do_res

do_ins:	;insert str1 into str2 with index bx
	lea	dx,info_11
	mov	ah,9
	int	21h
	call	scf_int
	mov	bx,ax
	lea	si,str1
	lea	di,str2
	call	insert
	jmp	do_res

do_fnd:	;find str1 in the str2
	lea	si,str1
	lea	di,str2
	call	fnd_str
	call	prt_int	
	call	prt_nl		
	jmp	do_res	

	;del str1 in the str2
do_del:	lea	si,str1
	lea	di,str2
	call	delete
	jmp	do_res	
		
	;print two str
do_res:	lea	dx,info_6
	mov	ah,9
	int	21h
	lea	si,str1
	call	prt_str
	call	prt_nl
	lea	dx,info_7
	mov	ah,9
	int	21h
	lea	si,str2
	call	prt_str
	call	prt_nl
		
	jmp	ma_lp1
	
main	endp

;print help
prt_hlp	proc
	push	dx
	push	ax
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
	pop	ax
	pop	dx
	ret
prt_hlp	endp

;print str, addr with si
prt_str proc
	mov	ah,2
ps_lp1:	mov	dl,[si]
	cmp	dl,0	;str end with /0
	je	end_ps
	int	21h
	inc	si
	jmp	ps_lp1	
end_ps:	
	ret
prt_str endp

;read str, addr with di
scf_str proc
	mov	ah,1
ss_lp1:	int	21h
	cmp	al,0dh
	je	end_ss
	mov	[di],al
	inc	di
	jmp	ss_lp1
end_ss:	mov	byte ptr [di],0
	call	prt_nl
	ret
scf_str endp

;lenth of a str, addr with si
len_str	proc
	mov	bx,0
ls_lp1:	mov	al,[si]
	cmp	al,0
	je	end_ls
	inc	si
	inc	bx
	jmp	ls_lp1
end_ls:	mov	ax,bx	;answer in the ax
	ret	
len_str endp

;lower to uper, addr with si
lo_up	proc
	mov	di,si
	push	si
	call	len_str
	pop	si
	mov	cx,ax
	cld
lp_lp1:	lodsb
	cmp	al,'a'
	jb	lp_ctn
	cmp	al,'z'
	ja	lp_ctn
	sub	al,20h
lp_ctn:	stosb
	loop	lp_lp1
	ret
lo_up	endp

;get a integer to ax
scf_int proc
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
	ret
scf_int	endp

;cmp two str,add with si,di
cmp_str	proc
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
cs_nor:	cmp	al,'a'
	jb	cs_jp3
	cmp	al,'z'
	ja	cs_jp3
	sub	al,'a'-'A'
cs_jp3:	cmp	ah,'a'
	jb	cs_jp4
	cmp	ah,'z'
	ja	cs_jp4
	sub	ah,'a'-'A'
cs_jp4:	cmp	al,ah
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
end_cs:	ret
cmp_str	endp

;copy a str to another str, addr si to di
cpy_str proc
	push	si
	call	len_str
	mov	cx,ax
	inc	cx
	pop	si
	cld		
	rep	movsb
	ret
cpy_str	endp

;insert str [si] to another [di] with index [bx]
insert	proc
	push	bx
	push	si
	mov	si,di
	call	len_str	;chenck lenth of dectection
	pop	si
	pop	bx
	cmp	bx,ax	
	ja	end_ins	;if lenth less than index, over
	push	si
	push	bx
	push	di
	mov	cx,ax
	sub	cx,bx	;num of bytes need moved back,lenth of str2 - index + 1(over)
	inc	cx		
	add	di,ax	;di point the tail of str2
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
end_ins:ret
insert	endp

;find str1 [si] in the str2[di],index with ax
fnd_str	proc
	push	si
	call	len_str
	push	ax
	mov	si,di
	call	len_str
	mov	cx,ax	;str2 lenth
	pop	ax	;str1 lenth
	pop	si	
	mov	bx,0	;index of str2
fs_lp1:	push	cx
	push	ax
	push	si
	push	di
	add	di,bx
	mov	cx,ax
	call	cmp_nby
	cmp	ax,0
	jne	fs_cnt
	pop	di
	pop	si
	pop	ax
	pop	cx
	mov	ax,bx
	jmp	end_fs
fs_cnt:	pop	di
	pop	si
	pop	ax
	pop	cx
	inc	bx
	loop	fs_lp1	
	mov	ax,-1
end_fs:	ret
fnd_str	endp

;cmp n [cx] bytes with si and di,equal with ax=0
cmp_nby	proc
	mov	ax,1
	cld
cn_lp1:	cmpsb
	jne	cn_end
	loop 	cn_lp1	
	mov	ax,0		
cn_end:	ret
cmp_nby	endp

;delete str1[si] in the str2[di]
delete	proc
de_lp1:	push	si
	push	di
	call	fnd_str
	pop	di
	pop	si
	cmp	ax,0ffffh
	je	end_de	;str2 not include str1,can not del
	push	ax	;index
	push	si
	call	len_str	
	pop	si
	push	ax	;lenth of str1
	push	si
	mov	si,di
	call	len_str
	pop	si
	mov	cx,ax	;lenth of str2	
	pop	ax	;lenth of str1
	pop	bx	;index
	sub	cx,ax	;cx = len(str2) - len(str1) - index + 1
	sub	cx,bx 
	inc	cx
	push	di
	push	si
	add	di,bx	;di = di + index
	mov	si,di	;si = di + index + len(str1)
	add	si,ax
	cld
	rep	movsb
	pop	si
	pop	di
	;add	di,bx	;di renew the next pointer
	;jmp	de_lp1	;del all the sub str1
end_de:	ret
delete	endp

prt_nl proc
	push	dx
	push	ax
	lea	dx,new_lin
	mov	ah,9
	int	21h
	pop	ax
	pop	dx
	ret
prt_nl 	endp

;print number in the ax
prt_int proc
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
pi_end:	ret
prt_int	endp


code	ends
	end	main
