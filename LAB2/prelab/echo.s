.equ        JTAG_UART_BASE,     0x10001000          # address of first JTAG UART register
.equ        DATA_OFFSET,        0                   # offset of JTAG UART data register
.equ        STATUS_OFFSET,      4                   # offset of JTAG UART status register
.equ        WSPACE_MASK,        0xFFFF              # used in AND application to check status


.text
.global  _start
.org  0

_start:
            movia  sp, 0x7FFFFC                 # set stack poitner
            movia  r2, MSG                      # load message
            call PrintString                    # prints message

main:
            call GetChar                        # call GetChar


            
#pseudocode here
main::
        PrintString("ELEC 274 Lab 2 Echo Program\n\n")
        loop
            ch = GetChar()
            if (ch = '\n' or ch >= ' ') then
                PrintChar(ch)
            end if
        end loop

#start of my stuff


PrintString:
            subi    sp, sp, 8               # adjust stack pointer down to reserve space
            stw     r3, 4(sp)               # save value of r3 on stack
            stw     r4, 0(sp)               # save value of r4 on stack
            movia   r3, r2                  # point to memory address in str_ptr (assumed to be r2)

ps_loop:
            ldw     r4, r2                  # read byte at str_ptr address  

            ps_IF:  
                    # do we need to and r4 with some address?
                    bne r4, r0, ps_ELSE     # if r4 is 0
            ps_THEN:
                    br ps_ENDIF             # if equal to 0, end if
            ps_ELSE:
                    movi r2, r4             # put byte in r2
                    call PrintChar          # call printChar
                    call ps_loop            # loop again
            ps_ENDIF:

            andi    r3, r3, 1               # increment string pointer

            ldw     r3, 4(sp)               # restore r3 from stack
            ldw     r4, 0(sp)               # restore r4 from stack
            addi    sp, sp, 8               # readjust stack pointer to deallocate space
            ret                             # return


GetChar:
            subi    sp, sp, 8               # adjust stack pointer down to reserve space
            stw     r3, 4(sp)               # save value of r3 on stack
            stw     r4, 0(sp)               # save value of r4 on stack
            movia   r3, JTAG_UART_BASE      # point to first memory location on memory-mapped I/O register

    
gc_loop:
            ldwio   r4, STATUS_OFFSET(r3)   # read bits from status register
            andhi   r4, r4, 0x8000          # mask lower bits to isolate upper bits
            beq     r4, r0, pc_loop         # if upper bits are zero, loop again
            stw     r2, char(r0)            # store in char on stack should this be smth wJTAG? see commented below
            #stwio   r2, DATA_OFFSET(r3)     # if upper bits aren't zero, write character to data register
            lldw    r3, 4(sp)               # restore r3 from stack
            ldw     r4, 0(sp)               # restore r4 from stack
            addi    sp, sp, 8               # readjust stack pointer to deallocate space
            ret     


PrintChar:
            subi    sp, sp, 8               # adjust stack pointer down to reserve space
            stw     r3, 4(sp)               # save value of r3 on stack
            stw     r4, 0(sp)               # save value of r4 on stack
            movia   r3, JTAG_UART_BASE      # point to first memory location on memory-mapped I/O register
pc_loop:
            ldwio   r4, STATUS_OFFSET(r3)   # read bits from status register
            andhi   r4, r4, WSPACE_MASK     # mask lower bits to isolate upper bits
            beq     r4, r0, pc_loop         # if upper bits are zero, loop again
            stwio   r2, DATA_OFFSET(r3)     # if upper bits aren't zero, write character to data register
            ldw     r3, 4(sp)               # restore r3 from stack
            ldw     r4, 0(sp)               # restore r4 from stack
            addi    sp, sp, 8               # readjust stack pointer to deallocate space
            ret     

.org 0x1000
# place any word-sized elements FIRST
# to ensure word alignment
# then place byte-sized elements
# (including character strings)
char:       .skip 4                 # save four bytes for character
MSG: .asciz  "ELEC 274 Lab 2 Echo Program\n\n"

    .end


