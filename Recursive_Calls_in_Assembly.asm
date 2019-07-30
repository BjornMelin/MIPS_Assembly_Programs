#+++++
# Recursive_Calls_in_Assembly.asm
# Recursive Calls in Assembly
# Bjorn Melin
# 3/8/19
#
# This program uses recursion to calculate a fibonacci number.
# The function has 1 parameter (which fib number (n)) and 1 return value.
# Using a loop in main, the first 10 fibonacci numbers are printed
# int fibonacci( int n)
# {
#   if( n < 1) return( 0);
#   if( n < 3) return( 1);
#   return( fibonacci( n - 1) + fibonacci( n - 2));
# }
#-----

#+++++
# Data Segment
#-----
.data
    string1:    .asciiz    "Printing out the first 10 fibonacci numbers:\n"
    string2:    .asciiz    ", "


#+++++
# Program Segment
#-----
.text



#+++++
# Main Function
#-----
main:
    # main pushes the $ra onto the stack since main is also a function
    addi   $sp, $sp,   -4           # adjusts the stack pointer for 1 item
    sw     $ra, 0($sp)

    # Using a syscall to print string1 at initialization of the program
    li     $v0, 4                   # syscall to print a string
    la     $a0, string1             # loads string1 into the argument register $a0 to print
    syscall


    li     $s0, 0                   # safe register $s0 is used to store the counter starting at 0

loopbegin:
    move   $a0, $s0                 # places the counter value $s0 into the argument register $a0
    jal    recfib                   # call fibonacci function
    move   $a0, $v0                 # put the answer into $a0 to print result of the curr iteration
    li     $v0, 1                   # 1 in $v0 will make syscall to print_int
    syscall
    li     $v0, 4
    la     $a0, string2             # syscall to print a string, print ", " to separate results
    syscall
    addi   $s0, $s0, 1              # increments the counter $s0
    slti   $t0, $s0, 11             # if $s0 < 11, $t0 = 0, else $t0 = 1
    # if !($t0 == 0), meaning $s0 >= 11, then exit loop, else repeat the loop
    bne    $t0, $zero, loopbegin


    # Restore $ra from the stack
    lw     $ra, 0($sp)
    addi   $sp, $sp,   4            # adjusts stack pointer to pop one item
    jr     $ra



#+++++
# Recursive Fibonacci Function
# Use $s0 to hold value of n ($a0), $s1 to hold fib(n - 1), $t0 to hold 1 for beq condition
#-----
recfib:
    # push $ra, $s0, and $s1 onto the stack
    addi   $sp, $sp, -12            # putting 3 things onto the stack, so move the pointer -12 bytes
    sw     $ra, 0($sp)              # put the return address out onto the stack memory
    sw     $s0, 4($sp)              # put the current content of $s0 out onto the stack memory
    sw     $s1, 8($sp)              # put content of $s1 out onto the stack memory, stores fib(y - 1)

    # move the argument (found in $a0 (n)) into the safe registers $s0
    move   $s0, $a0                 # puts the first argument, n,  into $s0

    li     $t0, 1                   # places the value 1 into temp register $t0, used for beq below
    beq    $s0, $zero, basecase1    # if $s0 (n) = 0, then go to basecase1
    beq    $s0, $t0, basecase2      # if $s0 (n) = 1, then go to basecase2

    addi   $a0, $s0, -1             # Pass along (n - 1)
    jal    recfib
    # the answer from the first call to recmult is now in $v0
    move   $s1, $v0                 # $s1 = fib(n - 1)
    addi   $a0, $s0, -2
    jal    recfib                   # $v0 = fib(n - 2)
    # The answer from the second call to recmult is now in $v0
    add    $v0, $v0, $s1            # $v0 = fib(n - 2) + $s1


restoreAndReturn:
    # put things back into registers from the stack
    lw     $ra, 0($sp)
    lw     $s0, 4($sp)
    lw     $s1, 8($sp)
    addi   $sp, $sp, 12             # pop the stack (restore the stack pointer)
    jr     $ra


basecase1:                          # base case for when n = 0, return 0
    li     $v0, 0
    j      restoreAndReturn


basecase2:                          # base case for when n = 1, return 1
    li     $v0, 1
    j      restoreAndReturn







