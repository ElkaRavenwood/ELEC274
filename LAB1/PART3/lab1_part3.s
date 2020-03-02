.equ		JTAG_UART_BASE,		0x10001000			# address of first JTAG UART register
.equ		DATA_OFFSET,		0					# offset of JTAG UART data register
.equ		STATUS_OFFSET,		4					# offset of JTAG UART status register
.equ		WSPACE_MASK,		0xFFFF				# used in AND application to check status

.text
.global		_start
.org		0x0000

_start:

Main:
			movi 	sp, 0x7FFFFC		# initializing stack pointer
			movi 	r2, '\n'			# load into r2
			call 	PrintChar			# call function
			call	exp
			
			IF:
					movi 	r4, 26
					bne 	r3, r4, ELSE
			THEN:
					movi 	r2, 'Y'
					call	PrintChar
					br		END_IF
			ELSE:
					movi 	r2, 'N'
					call	PrintChar
			END_IF:


PrintChar:
			subi	sp, sp, 8			# adjust stack pointer down to reserve space
			stw		r3, 4(sp)			# save value of r3 so it can be a temp
			stw		r4, 0(sp)
			movia	r3, JTAG_UART_BASE
pc_loop:
			ldwio	r4, STATUS_OFFSET(r3)
			andhi	r4, r4, WSPACE_MASK
			beq		r4, r0, pc_loop
			stwio	r2, DATA_OFFSET(r3)
			ldw 	r3, 4(sp)
			ldw 	r4, 0(sp)
			addi	sp, sp, 8
			ret 


exp:							# start now

		ldw		r2, Q(r0)		# load Q into R0
		addi	r2, r2, 1		# add immediate Q and 1, assign to R2
		ldw		r3, R(r0)		# load R into R3
		sub		r2, r2, r3		# subtract R3 from R2, assign to R2
		ldw		r3, S(r0)		# load S into R3
		mul		r2, r2, r3		# multiply R2 and R3, assign to R2
		ldw		r3, T(r0)		# load T into R4
		addi	r3, r3, 2		# add immediate T and 2, assign to R3
		div		r2, r2, r3		# divide R2 with R4, assign to R2
		stw		r2, P(r0)		# store in W
		ret

loop:
		br		loop			# end program

		.org 0x1000
P:		.skip 4					# save four bytes for sum
Q:		.word 14				# variable declarations
R:		.word 2
S:		.word 14
T:		.word 5
		.end

