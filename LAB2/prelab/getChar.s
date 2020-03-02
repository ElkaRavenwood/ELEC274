.equ		JTAG_UART_BASE,		0x10001000			# address of first JTAG UART register
.equ		DATA_OFFSET,		0					# offset of JTAG UART data register
.equ		STATUS_OFFSET,		4					# offset of JTAG UART status register
.equ		WSPACE_MASK,		0x8000				# used in AND application to check status


GetChar:
			subi	sp, sp, 8				# adjust stack pointer down to reserve space
			stw		r3, 4(sp)				# save value of r3 on stack
			stw		r4, 0(sp)				# save value of r4 on stack
			movia	r3, JTAG_UART_BASE		# point to first memory location on memory-mapped I/O register

	
gc_loop:
			ldwio	r4, STATUS_OFFSET(r3)	# read bits from status register
			andhi	r4, r4, 0x8000			# mask lower bits to isolate upper bits
			beq		r4, r0, pc_loop			# if upper bits are zero, loop again
			stwio	r2, DATA_OFFSET(r3)		# if upper bits aren't zero, write character to data register
			stw 	r2, char(r0)			# store in P
			ldw 	r3, 4(sp)				# restore r3 from stack
			ldw 	r4, 0(sp)				# restore r4 from stack
			addi	sp, sp, 8				# readjust stack pointer to deallocate space
			ret 							# return to calling routine


.org 0x1000
		char:		.skip 4					# save four bytes for character
# what was changed
# gc_loop: andhi to 0x8000 instead of 0xFFFF