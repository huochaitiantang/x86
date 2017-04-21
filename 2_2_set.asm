stack1	segment	para	stack
sta_are	dw	100 dup(?)
sta_bot	equ	$ - sta_are
stack1	ends

data	segment	para
symb	db	'='
new_lin	db	0dh,0ah,'$'
str1	db	128 dup(?)
str2	db	128 dup(?)
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
	
	;read two str
	lea	di,str1
	call	scf_str
	lea	di,str2
	call	scf_str
	
	;lower to upper
	;lea	si,str1
	;call	lo_up
	;lea	si,str2
	;call	lo_up
	
	;copy str1 to str2
	;lea	si,str1
	;lea	di,str2
	;call	cpy_str
	
	;compare two str
	;lea	si,str1
	;lea	di,str2
	;call	cmp_str
	;mov	dl,symb
	;mov	ah,2
	;int	21h
	;call	prt_nl
	
	;insert str1 into str2 with index bx
	;call	scf_int
	;mov	bx,ax
	;lea	si,str1
	;lea	di,str2
	;call	insert
	
	;find str1 in the str2
	;lea	si,str1
	;lea	di,str2
	;call	fnd_str
	;call	prt_int	
	;call	prt_nl		
	
	;del str1 in the str2
	lea	si,str1
	lea	di,str2
	call	delete
		
	;print two str
	lea	si,str1
	call	prt_str
	call	prt_nl
	lea	si,str2
	call	prt_str
	
	

exit:	mov	ax,4c00h
	int	21h
main	endp

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
end_ss:	mov	[di],0
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
cs_nor:	cmp	al,ah
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
	add	di,bx	;di renew the next pointer
	jmp	de_lp1	;del all the sub str1
end_de:	ret
delete	endp

prt_nl proc
	lea	dx,new_lin
	mov	ah,9
	int	21h
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
