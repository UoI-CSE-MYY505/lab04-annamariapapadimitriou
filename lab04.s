
.globl str_ge, recCheck

.data

maria:    .string "Maria"
markos:   .string "Markos"
marios:   .string "Marios"
marianna: .string "Marianna"

.align 4  # make sure the string arrays are aligned to words (easier to see in ripes memory view)

# These are string arrays
# The labels below are replaced by the respective addresses
arraySorted:    .word maria, marianna, marios, markos

arrayNotSorted: .word marianna, markos, maria

.text

            la   a0, arrayNotSorted
            li   a1, 4
            jal  recCheck

            li   a7, 10
            ecall

str_ge:
#---------
# Write the subroutine code here
#  You may move jr ra   if you wish.
#---------
            jr   ra
 
# ----------------------------------------------------------------------------
# recCheck(array, size)
# if size == 0 or size == 1
#     return 1
# if str_ge(array[1], array[0])      # if first two items in ascending order,
#     return recCheck(&(array[1]), size-1)  # check from 2nd element onwards
# else
#     return 0

recCheck:
#---------
# Write the subroutine code here
#  You may move jr ra   if you wish.
    addi sp, sp, -12            # adjust stack for 3
    sw ra, 8(sp)
    sw a1, 0(sp)
    sw a0, 4(sp)
                                # get first two words of current array
    lw a1, 0(a0)
    lw a0, 4(a0)
    
    jal str_ge                  # check the two words for correct order
    addi t1, a0, 0              # save value of comparison to t1 
    lw ra, 8(sp)                # restore values
    lw a0, 4(sp)
    lw a1, 0(sp)
    bne t1, zero, L1            # check if array is not in order
    j exit_zero
#---------
    
L1:
    addi a1, a1, -1             # make new size = size - 1 and new array = array - first element
    addi a0, a0, 4
    li t2, 1                    # check if size == 0 or size == 1
    beq a1, t2, exit_one     
    beq a1, zero, exit_one

    jal recCheck                # recur

                                # restore values to starting except a0 and adjust stack
    lw ra, 8(sp)
    lw a1, 0(sp)
    addi sp, sp, 12
  
    jr ra                       # return to caller
#---------
    
exit_one:
    addi a0, zero, 1            # value 1 to a0
    addi sp, sp, 12             # adjust stack
    jr ra                       # return to caller
#---------

exit_zero:
    addi a0, zero, 0            # value 0 to a0
    addi sp, sp, 12             # adjust stack
    jr ra                       # return to caller
#  You may move jr ra   if you wish.
#---------
            
