.text
.global 	_start
.org 		0x0000 				# start at address 0

_start:							# start now

		ldw		r2, Q(r0)		# load Q into R0
		addi	r2, r2, 1		# add immediate Q and 1, assign to R2
		ldw		r3, r(r0)		# load R into R3
		sub		r2, r2, r3		# subtract R3 from R2, assign to R2
		ldw		r3, S(r0)		# load S into R3
		mul		r2, r2, r3		# multiply R2 and R3, assign to R2
		ldw		r3, T(r0)		# load T into R4
		addi	r3, r3, 2		# add immediate T and 2, assign to R3
		div		r2, r2, r3		# divide R2 with R4, assign to R2
		stw		r2, P(r0)		# store in W

_end:
		br		_end			# end program


		.org 0x1000
P:		.skip 4					# save four bytes for sum
Q:		.word 14				# variable declarations
R:		.word 2
S:		.word 14
T:		.word 5
		.end