.text
.global		_start
.org		0x0000


.equ		DATA_OFFSET,		0					# offset of JTAG UART data register
.equ		STATUS_OFFSET,		4					# offset of JTAG UART status register
.equ		WSPACE_MASK,		0xFFFF				# used in AND application to check status
.equ		JTAG_UART_BASE,		0x10001000


_start:

Main:
			movia	sp, 0x7FFFFC			#intial stack opinter 
			movi 	r2, '\n'			# load into r2
			call 	PrintChar			# call function
			call	exp
			
			IF:
					
					movi	r3, 26
					bne 	r2, r3, ELSE
			THEN:
					movi 	r2, 'Y'
					call	PrintChar
					br 	END_IF
			ELSE:
					movi 	r2, 'N'
					call	PrintChar
			END_IF:
			
			break



PrintChar:
			subi	sp, sp, 8				# adjust stack pointer down to reserve space
			stw		r3, 4(sp)				# save value of r3 on stack
			stw		r4, 0(sp)				# save value of r4 on stack
			movia	r3, JTAG_UART_BASE		# point to first memory location on memory-mapped I/O register
pc_loop:
			ldwio	r4, STATUS_OFFSET(r3)	# read bits from status register
			andhi	r4, r4, WSPACE_MASK		# mask lower bits to isolate upper bits
			beq		r4, r0, pc_loop			# if upper bits are zero, loop again
			stwio	r2, DATA_OFFSET(r3)		# if upper bits aren't zero, write character to data register
			ldw 	r3, 4(sp)				# restore r3 from stack
			ldw 	r4, 0(sp)				# restore r4 from stack
			addi	sp, sp, 8				# readjust stack pointer to deallocate space
			ret 							# return to calling routine


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


		.org 0x1000
P:		.skip 4					# save four bytes for sum
Q:		.word 14				# variable declarations
R:		.word 2
S:		.word 14
T:		.word 5
		.end

.end