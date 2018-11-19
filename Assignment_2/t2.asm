includelib	legacy_stdio_definitions.lib 
extrn		printf:near
.data


option casemap:none             ; case sensitive
 
.code


public  min                      ; export function name
min:
	mov		rax,		rcx		; eax = a (first parameter is always at rcx)
	mov		rbx,		rax		; v = a
	mov		rax,		rdx		; eax = b (second parameter is at rdx..)
	cmp		rax,		rbx  	; if(b < v)
	jge		minExit				; {
	mov		rbx,		rax		;	v = b
minExit:						; }
	mov		rax,		r8		; eax = c (third parameter is at r8..)
	cmp		rax,		rbx		; if(c < v)
	jge		minExit2			; {
	mov		rbx,	rax	    	;	v = c
minExit2:						; }
	mov		rax,		rbx		; ...I thiiink you return with this register(confirmed).
	ret							; return




public  p                       ; export function name
p:
	sub		rsp,		32		; Allocating 32 bits shadow space
	mov		rax,		rdx		; temp = j
	mov		rbx,		r8		; temp2 = k
	mov		r10,		rcx		; temp3 = i
	mov		rcx,		g		; param1 = g
	mov		rdx,		r10		; param2 = i
	mov		r8,			rax		; param3 = j
	push	rbx					; save rbx
	call	min					; min(g, i, j)

	pop		rbx					; restore rbx
	mov		rcx,		rax		; param1 = min(g, i, j)
	mov		rdx,		rbx		; param2 = k
	mov		r8,			r9		; param3 = l
	call	min					; min(min(g, i, j), k, l)
	add		rsp,		32		; Deallocating 32 bits shadow space

	ret





public  gcd                     ; export function name

gcd:
	add		rsp,		32		; Allocating 32 bits shadow space
	mov		r8,			rdx		; temp = b
	xor		rax,		rax		; rax = 0	
	cmp		rax,		rdx		; if(b == 0) {
	je		gcdExit1			;	we're done here }
	mov		rax,		rcx		; rax = a
	mov		rbx,		rdx		; rbx = b
	xor		rdx,		rdx		; zero rdx since div uses 64 bit edx:eax
	idiv	rbx					; divides eax by ecx
	mov		rcx,		r8		; param1 = b
	mov		rdx,		rdx		; param2 = a%b (should be stored in rdx)
	call	gcd					; gcd(b, a%b)
	jmp		gcdExit2			; goto exit

gcdExit1:
	mov		rax,		rcx		; returns a

gcdExit2:
	sub		rsp,		32		; Deallocating 32 bits shadow space
	ret
	



public  q                       ; export function name

testS db 'a = %I64d b = %I64d c = %I64d d = %I64d e = %I64d sum = %I64d\n', 0AH, 00H ; Format string
q:
	xor		rax,		rax		; rax = 0
	add		rax,		rcx		; rax += a
	add		rax,		rdx		; rax += b
	add		rax,		r8		; rax += c
	add		rax,		r9		; rax += d
	add		rax,		[rbp-16]; rax += e
	mov		r10,		rax		; r10 = sum
	push	r10					; push sum on stack to preserve 

	sub		rsp,		32		; Allocating shadow space
	sub		rsp,		24		; Allocating 24 bits stack space for extra parameters
	mov		rax,		rcx		; temp = a
	mov		rbx,		rdx		; temp1 = b
	lea		rcx,		testS	; param1 = format string
	mov		rdx,		rax		; param2 = a
	mov		rax,		r8		; temp = c
	mov		r8,			rbx		; param3 = b
	mov		rbx,		r9		; temp2 = d
	mov		r9,			rax		; param4 = c
	mov		[rsp+32],	rbx		; param5 = d
	mov		rbx,		[rbp-16]; temp2 = e
	mov		[rsp+40],	rbx		; param6 = e
	mov		[rsp+48],	r10		; param7 = sum

	call	printf				; printf(formatString, a, b, c, d, e, sum)
	add		rsp,		32		; Deallocating shadow space
	add		rsp,		24		; Deallocating extra stack space
	pop		r10					; restoring sum
	mov		rax,		r10		; result = sum
	ret							; return



public qns						; export function name

testS2 db 'qns\n', 0AH, 00H		; Format string
qns:
	sub		rsp,		32		; Allocating shadow space
	lea		rcx,		testS2	; param1 = format string
	call	printf				; printf("Hello world!")
	add		rsp,		32		; Deallocating shadow space

	lea		rcx,		testS2	; param1 = format string
	call	printf				; printf("Hello world!") // Without shadow space
	
	; Not allocating shadow space results in the program crashing with the following error:
	; "Unhandled exception at 0x00007FF6A8E1BC6F in t2Test.exe: 0xC0000096: Privileged instruction."
	; I guess the printf function assumes the shadow space is there and writes over memory we want to 
	; preserve.



	xor		rax,		rax		; zero rax just to pass test..
	ret




;---------------------------------------------------------;
.data ; start of a data section						      ;
public g ; export variable g							  ;	Here is declaring global variable g.
g QWORD 4 ; declare global variable g initialised to 4	  ;
.code													  ;
;---------------------------------------------------------;

end
