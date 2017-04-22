stack1	segment	para	stack
sta_are	dw	100 dup(?)
sta_bot	equ	$ - sta_are
stack1	ends

data	segment	para
symb	db	'='
new_lin	db	0dh,0ah,'$'
str1	db	20h dup(0)
str2	db	20h dup(0)
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

	lea	di,str1
	call	scf_str
	lea	di,str2
	call	scf_str
	
	;lea	si,str1
	;call	lo_up
	;lea	si,str2
	;call	lo_up
	
	lea	si,str1
	lea	di,str2
	call	cmp_str
	
	lea	si,str1
	call	prt_str
	mov	dl,symb
	mov	ah,2
	int	21h	
	lea	si,str2
	call	prt_str
	

exit:	mov	ax,4c00h
	int	21h
main	endp

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
end_ss:	mov	byte ptr [di],0
	pop	di
	pop	dx
	pop	ax
	call	prt_nl
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
end_cs:	pop	di
	pop	si
	pop	ax
	ret
cmp_str	endp
	
code	ends
	end	main
