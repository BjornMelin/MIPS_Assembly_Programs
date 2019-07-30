#+++++
# Largest_in_Array.asm
# Finding Largest in Array
# Bjorn Melin
# 3/12/19
#
# This program uses a function to find the largest value in an array of integers.
# A "largest" function is implemented and tested from main on three different arrays.
#-----


#+++++
# Data Segment
#-----
.data
# To ensure that my function worked properly, 3 cases are tested.
# Case 1: max value is at the beginning of the array
array1:         .word       400, 6, 23, -7, 18, 201, 13, 302, 68, -39
array1Length:   .word       10

# Case 2: max value is at the end of the array
array2:         .word       6, -12, 14, 27, 67
array2Length:   .word       5

# Case 3: max value is near the middle of the array
array3:         .word       34, 27, 1, 5, 256, 89, 72, 34, 55
array3Length:   .word       9

message:        .asciiz     "Printing the Maximum Value in the Array:\n"
lineBreak:      .asciiz     "\n\n"


#+++++
# Program Segment
#-----
.text


#+++++
# Main Function
#-----
main:
    # main pushes the $ra onto the stack since main is also a function
    addi    $sp, $sp, -4            # adjusts the stack pointer for 1 item
    sw      $ra, 0($sp)


    ############ Case 1 ############
    # loads 4 into $v0 for syscall to print string
    li      $v0,4
    la      $a0, message            # loads message into the argument register $a0 to print
    syscall

    la      $a0, array1             # load the first arrays address into $a0
    lw      $a1, array1Length       # loads 10 into $a1
    jal     largest
    move    $a0, $v0
    li      $v0, 1
    syscall

    # loads 4 into $v0 for syscall to print string
    li      $v0,4
    la      $a0, lineBreak
    syscall


    ############ Case 2 ############
    # loads 4 into $v0 for syscall to print string
    li      $v0,4
    la      $a0, message
    syscall

    la      $a0, array2             # load the second arrays address into $a0
    lw      $a1, array2Length       # loads 5 into $a1
    jal     largest
    move    $a0, $v0
    li      $v0, 1
    syscall

    # loads 4 into $v0 for syscall to print string
    li      $v0,4
    la      $a0, lineBreak
    syscall


    ############ Case 3 ############
    # loads 4 into $v0 for syscall to print string
    li      $v0,4
    la      $a0, message
    syscall

    la      $a0, array3             # load the third arrays address into $a0
    lw      $a1, array3Length       # loads 9 into $a1
    jal     largest
    move    $a0, $v0
    li      $v0, 1
    syscall


    # Restore $ra from the stack
    lw      $ra, 0($sp)
    addi    $sp, $sp, 4             # adjusts stack pointer to pop one item
    jr      $ra



#####Detab CODE###
#+++++
# Largest in Array Function
#
# int largest( int* array, int arrayLength) {
#       int largest = array[0];
#       int index = 1;
#       while( index < arrayLength) {
#           if( array[index] > largest {
#               largest = array[index];
#           }
#           index++;
#       }
#       return(largest);
#   }
# 3 local variables (largest ($s2), index ($s0), arrayLength ($s1))
#-----
largest:
    # push the $ra, $s0, $s1, $s2 onto the stack, need to push $s registers b/c preserved across a call
    addi    $sp, $sp, -16           # adjusts the stack pointer for 4 items
    sw      $ra, 0($sp)
    sw      $s0, 4($sp)             # $s0 used to store the indices address
    sw      $s1, 8($sp)             # $s1 used to store the last indices address (arrayLength)
    sw      $s2, 12($sp)            # $s2 used to store the maximum value in the array

    move    $s0, $a0                # index = foo stored in $s0
    move    $s1, $a1                # arrayLength = $a0, stored in $s1
    sll     $s1, $s1, 2             # shift arrayLength left logical to multiply indices by 4
    add     $s1, $s0, $s1           # arrayEnd = index + arrayLength

    lw      $s2, 0($s0)             # first value in array into $s2 (maximum)



loopbegin:
    beq     $s0, $s1, loopend       # if (index == arrayEnd) go to loopend
    lw      $t0, 0($s0)             # $t0 = *index
    addi    $s0, $s0, 4             # index++

    slt     $t2, $t0, $s2           # if $t0 < max then $t2 = 1, else $t2 = 0
    bne     $t2, $zero, loopbegin   # if $t2 != 0, jump back to loopbegin.  Else, keep going.

    move    $s2, $t0                # if we get here, then $t0 > max so set $t0 as our new max value in $s2
    j       loopbegin               # jump back to top of the loop


loopend:
    move    $v0, $s2                # get max value in the array stored in $s2 and load it into $v0
    j restoreAndReturn              # jump to restoreAndReturn since we now have max saved in $v0


restoreAndReturn:
    # put things back into registers from the stack
    lw      $ra, 0($sp)
    lw      $s0, 4($sp)
    lw      $s1, 8($sp)
    lw      $s2, 12($sp)
    addi    $sp, $sp, 16             # pop the stack (restore the stack pointer)
    jr      $ra
