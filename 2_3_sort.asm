stack1	segment	para	stack
sta_are	dw	100 dup(?)
sta_bot	equ	$ - sta_are
stack1	ends

data	segment	para
symb	db	'='
tb_len	dw	0
tb_ind	dw	128 dup(?)
all_str	db	16384 dup(?)
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
	
l1:	mov	ah,1
	int	21h
	cmp	al,0dh
	je	next1
	sub	al,30h
	xor	ah,ah
	mov	bx,ax
	mov	ax,tb_len
	push	bx
	mov	bx,10
	mul	bx
	pop	bx
	add	ax,bx
	mov	tb_len,ax
	jmp	l1

next1:	mov	cx,tb_len
	lea	bx,all_str	;bx store the str index
	lea	di,tb_ind;di	store the index table index 
l2:	mov	[di],bx	
	push	di
	mov	di,bx
	call	scf_str
	mov	si,bx	
	call	lo_up
	mov	si,bx
	call	len_str
	add	bx,ax
	inc	bx
	pop	di
	inc	di
	loop	l2
	
	call	prt_tab

exit:	mov	ax,4c00h
	int	21h
main	endp

;print str, addr with si
prt_str proc
	push	ax
	push	dx
	push	si
	mov	ah,2
ps_lp1:	mov	dl,[si]
	cmp	dl,0	;str end with /0
	je	end_ps
	int	21h
	inc	si
	jmp	ps_lp1	
end_ps:	pop	si
	pop	dx
	pop	ax
	ret
prt_str endp

;read str, addr with di
scf_str proc
	push	ax
	push	dx
	push	di
	mov	ah,1
ss_lp1:	int	21h
	cmp	al,0dh
	je	end_ss
	mov	[di],al
	inc	di
	jmp	ss_lp1
end_ss:	mov	[di],0
	pop	di
	pop	dx
	pop	ax
	ret
scf_str endp

;lenth of a str, addr with si
len_str	proc
	push	bx
	push	si
	mov	bx,0
ls_lp1:	mov	al,[si]
	cmp	al,0
	je	end_ls
	inc	si
	inc	bx
	jmp	ls_lp1
end_ls:	mov	ax,bx	;answer in the ax
	pop	si
	pop	bx
	ret	
len_str endp

;lower to uper, addr with si
lo_up	proc
	push	di
	push	si
	push	cx
	push	ax
	mov	di,si
	call	len_str
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
	pop	ax
	pop	cx
	pop	si
	pop	di
	ret
lo_up	endp

;cmp two str,add with si,di
cmp_str	proc
	push	ax
	push	si	
	push	di
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
end_cs:	pop	di
	pop	si
	pop	ax
	ret
cmp_str	endp

prt_nl proc
	mov	dl,0dh
	mov	ah,2
	int	21h
	mov	dl,01h
	mov	ah,2
	int	21h
	ret
prt_nl 	endp

prt_tab proc
	mov	cx,tb_len
	lea	si,tb_ind
pt_l1:	push	si
	mov	si,[si]
	call	prt_str
	call	prt_nl
	pop	si
	inc	si
	loop pt_l1
	
prt_tab endp
	
code	ends
	end	main
