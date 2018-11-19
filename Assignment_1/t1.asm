.686                                ; create 32 bit code
.model flat, C                      ; 32 bit memory model
 option casemap:none                ; case sensitive
.code								

; Not sure what anything above this line does..

public      min					; make sure function name is exported
min:
	push	ebp					; push frame pointer
	mov		ebp,		esp		; Update frame pointer
	sub		esp,		4		; Decrementing based on how many local vars (1 * 4 bytes)
	mov		eax,		[ebp+8]	; eax = a (first parameter is always at ebp + 8)
	mov		[ebp-4],	eax		; v = a (first parameter is always at ebp + 8)
	mov		eax,		[ebp+12]; eax = b (second parameter 4 bytes above..)
	cmp		eax,		[ebp-4]	; if(b < v)
	jge		minExit				; {
	mov		[ebp-4],	eax		;	v = b
minExit:						; }
	mov		eax,		[ebp+16]; eax = c
	cmp		eax,		[ebp-4]	; if(c < v)
	jge		minExit2			; {
	mov		[ebp-4],	eax		;	v = c
minExit2:						; }
	mov		eax,		[ebp-4] ; ...I thiiink you return with this register(confirmed).
	mov		esp,		ebp		; restore esp
	pop		ebp					; resotre ebp
	ret		0					; return




public      p					; make sure function name is exported
p:
	push	ebp					; push frame pointer
	mov		ebp,		esp		; update frame pointer
		
	push	[ebp+12]			; pushing j
	push	[ebp+8]				; pushing i
	push	g					; pushing g
	call	min					; min(g, i, j)
	add		esp,		12		; adding (3*4=12) to esp to remove parameters from stack

	push	[ebp+20]			; pushing l
	push	[ebp+16]			; pushing k
	push	eax					; pushing result of min(g, i, j)
	call	min					; min(min(g,i,j), k, l)
	add		esp,		12		; adding 12 to esp to remove parameters from stack

	mov		esp,		ebp		; restore esp
	pop		ebp					; restore ebp
	ret		0					; return




public      gcd					; make sure function name is exported
gcd:
	push	ebp					; push frame pointer
	mov		ebp,		esp		; update frame pointer
	mov		eax,		0		; eax = 0
	cmp		eax,		[ebp+12]; if(b == 0) {
	je		gcdExit1			;	we're done here }
	mov		eax,		[ebp+8]	; eax = a
	mov		ecx,		[ebp+12]; ecx = b
	xor		edx,		edx		; zero edx since div uses 64 bit edx:eax
	idiv	ecx					; this divides eax by ecx
	push	edx					; remainder is stored in edx and we push in reverse over (a%b is second argument)
	push	[ebp+12]			; pushing b
	call	gcd					; gcd(b, a%b)
	add		esp,		8		; add 8 to esp to remove parameters from stack
	jmp		gcdExit2			; goto exit


gcdExit1:						;
	mov		eax,		[ebp+8]	; return a
				
gcdExit2:						;
	mov		esp,		ebp		; restore esp
	pop		ebp					; restore ebp
	ret		0					; return

;---------------------------------------------------------;
.data ; start of a data section						      ;
public g ; export variable g							  ;	Here is declaring global variable g.
g DWORD 4 ; declare global variable g initialised to 4	  ;
.code													  ;
;---------------------------------------------------------;



end
