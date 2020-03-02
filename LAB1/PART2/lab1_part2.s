.equ		JTAG_UART_BASE,		0x10001000			# address of first JTAG UART register
.equ		DATA_OFFSET,		0					# offset of JTAG UART data register
.equ		STATUS_OFFSET,		4					# offset of JTAG UART status register
.equ		WSPACE_MASK,		0xFFFF				# used in AND application to check status

.text
.global		_start
.org		0x0000

_start:

Main:
			movi 	sp, 0x0100
			movi 	r2, '\n'				# load into r2
			call 	PrintChar				# call function
			movi 	r2, 'D'
			call 	PrintChar
			movi 	r2, 'E'
			call 	PrintChar
			movi 	r2, 'O'
			call 	PrintChar
loop:
			br	loop
		

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

.end