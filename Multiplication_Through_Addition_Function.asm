#+++++
# Multiplication_Through_Addition_Function.asm
# Bjorn Melin
# 2/12/19
# This program multiplies two numbers together
# by using addition inside of a loop.
# Makes multiplier code into a function & uses syscalls
# X times Y can be calculated by adding
# the number X, Y times.
#-----

#+++++
# Data Segment
#-----
.data
x:          .word   4           # Creates a 4 byte integer labeled "x" assigned the value of 4
y:          .word   3           # Creates a 4 byte integer labeled "y" assigned the value of 3
string1:    .asciiz " times "
string2:    .asciiz " is "

#+++++
# Program Segment
#-----
.text



#+++++
# Main Function
#-----
main:

    # main pushes the $ra onto the stack since main is also a function
    addi  $sp, $sp, -4          # adjusts the stack pointer for 1 item
    sw    $ra, 0($sp)

    # The lines below use syscall to print off the strings along
    # with the integers being multiplied found in the book that
    # this format is simpler to use than in endofloop for syscall
    li  $v0, 1                 # loads imm 1 into register $v0 to print int
    la  $a0, 4                 # loads 4 which is the value for x to display
    syscall
    li  $v0, 4                 # load imm 4 into register $v0 to print string
    la  $a0, string1           # same follows for the rest, the book helped w/ these
    syscall
    li  $v0, 1
    la  $a0, 3
    syscall
    li  $v0, 4
    la  $a0, string2
    syscall


    # Do the (minimal) work of calling the function by placing
    # the argument to the function in $a0 and then using jal.
    lw    $a0, x                # loads value x from memory into $a0
    lw    $a1, y                # loads value y from memory into $a1
    jal   multiply

    add     $a0, $v0, $zero
    li      $v0, 1
    syscall


    # Restore $ra from the stack
    lw    $ra, 0($sp)
    addi  $sp, $sp, 4           # adjusts stack pointer to pop one item
    # jump back to the calling routine to start program over
    jr    $ra



#+++++
# Multiplier Function
# Use $s0 to hold counter to hold the output and $s1 to hold the output
#-----
multiply:
    # push $s0 and $ra onto the stack
    addi  $sp, $sp, -16
    sw    $s2, 12($sp)          # used to store output in safe register
    sw    $s1, 8($sp)           # used to store y in safe register
    sw    $s0, 4($sp)           # used to store x in safe register
    sw    $ra, 0($sp)
    # Move the arguments into the safe registers ($s0)
    add   $s0, $a0, $zero       # saves x in safe register
    add   $s1, $a1, $zero       # saves y in safe register
    add   $s2, $zero, $zero


loopbegin:
    beq   $s1, $zero, loopend
    addi  $s1, $s1, -1          # decrements y each time as the counter
    add   $s2, $s2, $s0         # adds 4 to the safe register $s2 (output)each iteration
    j loopbegin



loopend:
    # store answer into $v0
    add     $v0, $s2, $zero
    # Restore values from the stack
    lw    $s0, 12($sp)
    lw    $s1, 8($sp)
    lw    $s2, 4($sp)
    lw    $ra, 0($sp)
    addi  $sp, $sp, 16          # pop the stack
    jr    $ra                   # return to the caller



