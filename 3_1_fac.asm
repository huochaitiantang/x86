stack1	segment	para	stack
sta_are	dw	100 dup(?)
sta_bot	equ	$ - sta_are
stack1	ends

data	segment	para
N	dw	6
res	dw	?
new_lin	db	0dh,0ah,'$'
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
	
	lea	si,res
	push	si
	mov	ax,N
	push	ax
	call	cal_fac
	lea	si,res
	push	si
	call	prt_int
		
exit:	mov	ax,4c00h
	int	21h
	
main	endp

;print a new line
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

;print number in the 
prt_int proc
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
prt_int	endp

;calculate the factorial
cal_fac	proc
	push	bp
	mov	bp,sp
	mov	ax,[bp+4]	;N
	mov	di,[bp+6]	;res addr
	cmp	ax,1
	ja	cf_ret
	mov	word ptr [di],1
	jmp	end_cf	
cf_ret:	push	ax
	push	di
	dec	ax
	push	di
	push	ax
	call	cal_fac
	pop	di
	pop	ax
	mov	bx,[di]
	mul	bx
	mov	[di],ax
end_cf:	mov	sp,bp
	pop	bp
	ret 	4
cal_fac	endp

code	ends
	end	main
