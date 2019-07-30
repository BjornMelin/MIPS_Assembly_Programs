#+++++
# String_Length_Function.asm
# C-Style String Length
# Bjorn Melin
# 4/1/19
#
# This program uses a function to find the length of a string.
# The length of a string is determined by finding the null
# character which terminates it.
#-----


#+++++
# Data Segment
#-----
.data
    # To ensure that my function is properly measuring string length, 3
    # dif. words are tested and their length is shown after "message"
    # note that ".asciiz" automatically adds in the terminator character
    # "\n" called NUL, I take advantage of this in the strlen function.
    string1:    .asciiz     "Counting"
    string2:    .asciiz     "string"
    string3:    .asciiz     "lengths"
    message1:   .asciiz     "The Length of the First String is:\n"
    message2:   .asciiz     "The Length of the Second String is:\n"
    message3:   .asciiz     "The Length of the Third String is:\n"
    message4:   .asciiz     "The 3 Strings Which Lengths Will Be Found Are:\n"
    lineBreak:  .asciiz     "\n\n"
    quote:      .asciiz     "'"
    commaSep:   .asciiz     "', '"

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

    # prints the initial message ("message4") using syscall for string
    li      $v0, 4
    la      $a0, message4
    syscall

    # prints the 3 strings in which I will be measuring their length
    la      $a0, quote
    syscall
    la      $a0, string1
    syscall
    la      $a0, commaSep
    syscall
    la      $a0, string2
    syscall
    la      $a0, commaSep
    syscall
    la      $a0, string3
    syscall
    la      $a0, quote
    syscall
    la      $a0, lineBreak
    syscall


    ############ String1 ############
    la      $a0, message1
    syscall

    la      $a0, string1        # loads the address of string1 into argument reg $a0
    jal     strlen              # jump and link to the strlen function
    move    $a0, $v0            # copy answer in $v0 into $a0 to print answer
    li      $v0, 1              # loads 1 into $v0 for syscall to print int (answer)
    syscall

    # loads 4 into $v0 for syscall to print string, adds space b/w each answer
    li      $v0,4
    la      $a0, lineBreak
    syscall


    ############ String2 ############
    la      $a0, message2
    syscall

    la      $a0, string2        # loads the address of string1 into argument reg $a0
    jal     strlen              # jump and link to the strlen function
    move    $a0, $v0
    li      $v0, 1
    syscall

    # loads 4 into $v0 for syscall to print string, adds space b/w each answer
    li      $v0,4
    la      $a0, lineBreak
    syscall


    ############ String3 ############
    la      $a0, message3
    syscall

    la      $a0, string3        # loads the address of string1 into argument reg $a0
    jal     strlen              # jump and link to the strlen function
    move    $a0, $v0
    li      $v0, 1
    syscall


    # Restore $ra from the stack
    lw      $ra, 0($sp)
    addi    $sp, $sp, 4         # adjusts stack pointer to pop one item
    jr      $ra



#+++++
# Length of a String function
#
# int strlen( char *string) {
#    int length = 0;
#    while( *(string + length) != NULL) {
#        length++;
#    }
#    return( length);
# }
# 2 local variables (string ($s0) and length of the string ($s1))
#-----
strlen:
    # push the $ra
    addi    $sp, $sp, -12       # adjusts the stack pointer for 4 items
    sw      $ra, 0($sp)
    sw      $s0, 4($sp)         # $s0 used to store the address of the string
    sw      $s1, 8($sp)         # used to store length of the string

    addi    $s1, $zero, 0       # sets the length in $s1 to 0 to start
    move    $s0, $a0            # copies into $s0 the arg string address in $a0


loopbegin:
    lb      $t1, 0($s0)         # $t1 = Memory[$s0 + 0]
    beq     $t1, $zero, loopend # if ($t1 == 0) denoting NUL, go to loopend
    addi    $s0, $s0, 1         # increment the string address by 1
    addi    $s1, $s1, 1         # increment the counter, in this case, length
    j       loopbegin           # jump back to the top of the loop


loopend:
    # copy the length of the string now stored in $s1 into $v0 (answer reg)
    move    $v0, $s1


restoreAndReturn:
    # put things back into registers from the stack
    lw      $ra, 0($sp)
    lw      $s0, 4($sp)
    lw      $s1, 8($sp)
    addi    $sp, $sp, 12        # pop the stack (restore the stack pointer)
    jr      $ra                 # jump back to the function caller in main
