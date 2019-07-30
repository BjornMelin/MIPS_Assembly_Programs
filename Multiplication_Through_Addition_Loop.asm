#+++++
# Multiplication_Through_Addition_Loop.asm
# Bjorn Melin
# This program multiplies two numbers together
# by using addition inside of a loop.
# X times Y can be calculated by adding
# the number X, Y times.
#-----

#+++++
# Data Segment
#-----

.data
x:          .word   4           # Creates a 4 byte integer labeled "x" assigned the value of 4
y:          .word   3           # Creates a 4 byte integer labeled "y" assigned the value of 3
output:     .word   0           # Creates a 4 byte integer labeled "output" assigned the value of 0 to be used to keep track of the total




#+++++
# Program Segment
#-----

.text

main:
    lw  $s0,     x               # Loads in all of the integers created in .data
    lw  $s1,     y
    lw  $s2,     output

topOfLoop:
    beq $s1,    $zero,  endOfLoop   # Test if the counter, in this case y, has reached 0
    add $s2,    $s2,    $s0     # Adds 4 (x) to the output and sets that as the new output
    addi $s1,   $s1,    -1      # Decrement the counter "y"
    j topOfLoop                 # Jump to the top of the loop to test if y equals 0

endOfLoop:
    sw  $s2,    output          # Put the new output back into the output variable
    nop                         # By this point, $s2 will contain c, which is 12 in hex.  Success!
    nop





